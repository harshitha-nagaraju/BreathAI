import 'dart:math';

class SpectrogramService {

  static const int frameSize = 512;
  static const int hopSize = 256;
  static const int targetSize = 128;

  // ===============================
  // GENERATE SPECTROGRAM
  // ===============================

  static List<List<double>> generateSpectrogram(List<double> samples) {

    List<List<double>> spectrogram = [];

    // Normalize audio samples
    double maxVal = samples.map((e) => e.abs()).reduce(max);

    if (maxVal == 0) maxVal = 1;

    List<double> normalized =
        samples.map((e) => e / maxVal).toList();

    // Frame processing
    for (int i = 0; i + frameSize < normalized.length; i += hopSize) {

      List<double> frame = normalized.sublist(i, i + frameSize);

      double energy = 0;

      for (double s in frame) {
        energy += s * s;
      }

      energy = sqrt(energy / frameSize);

      // Create one spectrogram row
      List<double> row =
          List.generate(targetSize, (_) => energy);

      spectrogram.add(row);
    }

    // ===============================
    // PAD OR TRIM TO 128 FRAMES
    // ===============================

    while (spectrogram.length < targetSize) {
      spectrogram.add(List.filled(targetSize, 0));
    }

    if (spectrogram.length > targetSize) {
      spectrogram = spectrogram.sublist(0, targetSize);
    }

    return spectrogram;
  }

  // ===============================
  // FLATTEN FOR MODEL INPUT
  // ===============================

  static List<double> flatten(List<List<double>> spec) {
    return spec.expand((row) => row).toList();
  }
}