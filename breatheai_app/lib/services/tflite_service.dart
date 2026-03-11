import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../core/class_mapping.dart';
import '../utils/mel_spectrogram_helper.dart';

class TFLiteService {

  Interpreter? _interpreter;

  // ===============================
  // LOAD MODEL
  // ===============================

  Future<void> loadModel() async {

    try {

      _interpreter = await Interpreter.fromAsset(
        "assets/model/breatheai_model.tflite",
      );

      debugPrint("Model loaded successfully");

      debugPrint(
        "Input shape: ${_interpreter!.getInputTensor(0).shape}",
      );

      debugPrint(
        "Output shape: ${_interpreter!.getOutputTensor(0).shape}",
      );

    } catch (e) {

      debugPrint("Model load error: $e");
      rethrow;

    }
  }

  // ===============================
  // RUN MODEL
  // ===============================

  Future<Map<String, dynamic>> runModel(String audioPath) async {

    if (_interpreter == null) {
      throw Exception("Model not loaded");
    }

    try {

      // Extract Mel Spectrogram (128x128)
      final spectrogram =
          await MelSpectrogramHelper.extractMelSpectrogram(audioPath);

      // Safety check
      if (spectrogram.length != 128 || spectrogram[0].length != 128) {
        throw Exception("Invalid spectrogram size");
      }

      // ===============================
      // CREATE MODEL INPUT
      // Shape: [1,128,128,3]
      // ===============================

      final input = List.generate(
        1,
        (_) => List.generate(
          128,
          (i) => List.generate(
            128,
            (j) {

              double value = spectrogram[i][j];

              // normalize
              value = value.clamp(0.0, 1.0);

              return [value, value, value]; // RGB channels
            },
          ),
        ),
      );

      // ===============================
      // PREPARE OUTPUT
      // ===============================

      final outputShape =
          _interpreter!.getOutputTensor(0).shape;

      final int classes = outputShape.last;

      final output =
          List.generate(1, (_) => List.filled(classes, 0.0));

      // ===============================
      // RUN INFERENCE
      // ===============================

      _interpreter!.run(input, output);

      final scores = List<double>.from(output[0]);

      // ===============================
      // FIND BEST CLASS
      // ===============================

      int predictedIndex = 0;
      double maxScore = scores[0];

      for (int i = 1; i < scores.length; i++) {

        if (scores[i] > maxScore) {
          maxScore = scores[i];
          predictedIndex = i;
        }

      }

      // ===============================
      // GET LABEL
      // ===============================

      String label = ClassMapping.getLabel(predictedIndex);


      if (label != "Healthy" && maxScore < 0.50) {
        label = "Healthy";
      }

      // ===============================
      // RETURN RESULT
      // ===============================

      return {
        "label": label,
        "confidence": maxScore,
      };

    } catch (e) {

      throw Exception("Model inference failed: $e");

    }
  }
}