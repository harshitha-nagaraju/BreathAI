import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../services/tflite_service.dart';
import '../services/history_service.dart';
import '../services/risk_engine.dart';
import '../services/recommendation_engine.dart';

import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AudioService audioService = AudioService();
  final TFLiteService tfliteService = TFLiteService();
  final HistoryService historyService = HistoryService();

  bool isRecording = false;
  bool modelLoaded = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // ===============================
  // LOAD MODEL
  // ===============================

  Future<void> loadModel() async {
    try {

      await tfliteService.loadModel();

      if (!mounted) return;

      setState(() {
        modelLoaded = true;
      });

    } catch (e) {

      debugPrint("Model load error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load AI model")),
      );
    }
  }

  // ===============================
  // START SCAN
  // ===============================

  Future<void> startScan() async {

    if (!modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("AI model still loading...")),
      );
      return;
    }

    try {

      setState(() {
        isRecording = true;
      });

      // 🎤 Record breath audio
      final String audioPath = await audioService.recordAudio();

      // 🤖 Run AI model
      final Map<String, dynamic> result =
          await tfliteService.runModel(audioPath);

      final String prediction =
          result["label"] as String;

      final double confidence =
          (result["confidence"] as num).toDouble();

      // 📊 Calculate risk
      final double riskScore =
          RiskEngine.calculateRisk(prediction, confidence);

      final String risk =
          RiskEngine.severityLevel(riskScore);

      // 🩺 Doctor recommendation
      final String recommendation =
          RecommendationEngine.recommend(prediction, riskScore);

      // 💾 Save scan history (FIXED)
      await historyService.saveScan(
        prediction: prediction,
        confidence: confidence,
        risk: risk,
        recommendation: recommendation,
        audioPath: audioPath,
        reportPath: "",
        date: DateTime.now(),
      );

      if (!mounted) return;

      setState(() {
        isRecording = false;
      });

      // 📱 Navigate to result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            prediction: prediction,
            confidence: confidence,
            risk: risk,
            recommendation: recommendation,
            audioPath: audioPath,
            reportPath: "",
            date: DateTime.now(),
          ),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      setState(() {
        isRecording = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Scan failed: $e")),
      );
    }
  }

  // ===============================
  // UI
  // ===============================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("BreatheAI"),
        centerTitle: true,
      ),

      body: Center(

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.air,
                size: 120,
                color: Colors.cyan,
              ),

              const SizedBox(height: 20),

              const Text(
                "Smart Lung Health Scanner",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(

                onPressed: isRecording ? null : startScan,

                child: isRecording
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(width: 10),

                          Text("Recording Breath..."),
                        ],
                      )
                    : Text(
                        modelLoaded
                            ? "Start Scan"
                            : "Loading AI Model...",
                      ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(

                onPressed: isRecording
                    ? null
                    : () {
                        Navigator.pushNamed(context, "/history");
                      },

                child: const Text("View Scan History"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}