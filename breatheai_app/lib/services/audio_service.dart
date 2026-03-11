import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {

  final AudioRecorder recorder = AudioRecorder();

  // ===============================
  // RECORD BREATH AUDIO
  // ===============================

  Future<String> recordAudio() async {

    try {

      bool hasPermission = await recorder.hasPermission();

      if (!hasPermission) {
        throw Exception("Microphone permission not granted");
      }

      final dir = await getTemporaryDirectory();

      // unique filename for every scan
      String filePath =
          "${dir.path}/lung_scan_${DateTime.now().millisecondsSinceEpoch}.wav";

      await recorder.start(

        const RecordConfig(

          encoder: AudioEncoder.wav,

          sampleRate: 16000, // matches ML training

          bitRate: 128000,

          numChannels: 1, // mono audio (important for model)

        ),

        path: filePath,

      );

      // record for 5 seconds (better breath capture)
      await Future.delayed(const Duration(seconds: 5));

      final path = await recorder.stop();

      if (path == null) {
        throw Exception("Recording failed");
      }

      return path;

    } catch (e) {

      throw Exception("Audio recording error: $e");
    }
  }
}