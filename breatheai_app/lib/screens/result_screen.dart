import 'package:flutter/material.dart';

import '../services/risk_engine.dart';
import '../services/pdf_service.dart';

import '../widgets/confidence_bar.dart';
import '../widgets/risk_card.dart';
import '../widgets/spectrogram_widget.dart';

import '../utils/waveform_helper.dart';

import 'report_screen.dart';

class ResultScreen extends StatefulWidget {

  final String prediction;
  final double confidence;
  final String risk;
  final String recommendation;
  final String audioPath;
  final String reportPath;
  final DateTime date;

  const ResultScreen({
    super.key,
    required this.prediction,
    required this.confidence,
    required this.risk,
    required this.recommendation,
    required this.audioPath,
    required this.reportPath,
    required this.date,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  late double riskScore;
  late String severity;

  bool isGenerating = false;

  late List<double> spectrogram;

  @override
  void initState() {
    super.initState();

    // ===============================
    // RISK SCORE
    // ===============================

    riskScore = RiskEngine.calculateRisk(
      widget.prediction,
      widget.confidence,
    );

    severity = RiskEngine.severityLevel(riskScore);

    // ===============================
    // WAVEFORM
    // ===============================

    spectrogram =
        WaveformHelper.generateWaveform(widget.confidence);
  }

  // ===============================
  // GENERATE PDF REPORT
  // ===============================

  Future<void> downloadReport() async {

    try {

      setState(() {
        isGenerating = true;
      });

      final String path = await PDFService.generateReport(
        widget.prediction,
        widget.confidence,
        severity,
        widget.recommendation,
      );

      if (!mounted) return;

      setState(() {
        isGenerating = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReportScreen(reportPath: path),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      setState(() {
        isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to generate report: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Scan Result"),
        centerTitle: true,
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: ListView(

          children: [

            // ===============================
            // PREDICTION
            // ===============================

            Text(
              widget.prediction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ===============================
            // CONFIDENCE BAR
            // ===============================

            ConfidenceBar(
              value: widget.confidence,
            ),

            const SizedBox(height: 25),

            // ===============================
            // RISK CARD
            // ===============================

            RiskCard(
              risk: riskScore,
              severity: severity,
            ),

            const SizedBox(height: 25),

            // ===============================
            // DOCTOR RECOMMENDATION
            // ===============================

            const Text(
              "Doctor Recommendation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.recommendation,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 30),

            // ===============================
            // LUNG SOUND VISUALIZATION
            // ===============================

            const Text(
              "Lung Sound Visualization",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            SpectrogramWidget(
              spectrogram: spectrogram,
            ),

            const SizedBox(height: 40),

            // ===============================
            // DOWNLOAD REPORT BUTTON
            // ===============================

            ElevatedButton.icon(

              onPressed: isGenerating
                  ? null
                  : downloadReport,

              icon: const Icon(Icons.picture_as_pdf),

              label: isGenerating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Download Medical Report",
                      style: TextStyle(fontSize: 16),
                    ),

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),

          ],
        ),
      ),
    );
  }
}