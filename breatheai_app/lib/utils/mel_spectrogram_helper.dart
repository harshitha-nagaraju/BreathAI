import 'dart:math';
import 'package:wav/wav.dart';

class MelSpectrogramHelper {

  static const int frameSize = 512;
  static const int hopSize = 256;
  static const int melBins = 128;
  static const int timeFrames = 128;

  // ===============================
  // EXTRACT MEL SPECTROGRAM
  // ===============================

  static Future<List<List<double>>> extractMelSpectrogram(
      String filePath) async {

    final wav = await Wav.readFile(filePath);

    final samples = wav.channels.first;

    List<List<double>> spectrogram = [];

    // ===============================
    // NORMALIZE AUDIO
    // ===============================

    double maxVal = samples
        .map((e) => e.abs())
        .reduce(max);

    if (maxVal == 0) maxVal = 1;

    List<double> normalized =
        samples.map((e) => e / maxVal).toList();

    // ===============================
    // FRAME PROCESSING
    // ===============================

    for (int i = 0; i + frameSize < normalized.length; i += hopSize) {

      List<double> frame =
          normalized.sublist(i, i + frameSize);

      double energy = 0;

      for (var s in frame) {
        energy += s * s;
      }

      energy = sqrt(energy / frameSize);

      // clamp energy between 0 and 1
      energy = energy.clamp(0.0, 1.0);

      spectrogram.add(
        List.generate(melBins, (_) => energy),
      );
    }

    // ===============================
    // PAD TO 128 FRAMES
    // ===============================

    while (spectrogram.length < timeFrames) {

      spectrogram.add(
        List.filled(melBins, 0),
      );
    }

    // ===============================
    // TRIM IF TOO LONG
    // ===============================

    if (spectrogram.length > timeFrames) {
      spectrogram = spectrogram.sublist(0, timeFrames);
    }

    return spectrogram;
  }

  // ===============================
  // FLATTEN FOR TFLITE
  // ===============================

  static List<double> flatten(
      List<List<double>> spec) {

    return spec.expand((row) => row).toList();
  }
}