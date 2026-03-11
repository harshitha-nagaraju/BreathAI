import 'dart:math';

class WaveformHelper {

  static List<double> generateWaveform(double confidence) {

    final random = Random();

    // ensure confidence stays between 0–1
    double strength = confidence.clamp(0.0, 1.0);

    return List.generate(
      40,
      (i) {

        // base waveform pattern
        double base = sin(i * 0.35).abs();

        // add small randomness
        double noise = random.nextDouble() * 0.2;

        double value = (base * strength) + noise;

        // clamp to 0–1
        return value.clamp(0.0, 1.0);
      },
    );
  }
}