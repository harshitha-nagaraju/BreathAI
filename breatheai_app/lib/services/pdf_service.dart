import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFService {

  static Future<String> generateReport(
    String prediction,
    double confidence,
    String severity,
    String recommendation,
  ) async {

    try {

      final pdf = pw.Document();

      final now = DateTime.now();

      String reportId =
          "BR-${now.millisecondsSinceEpoch}";

      pdf.addPage(

        pw.Page(

          build: (pw.Context context) {

            return pw.Padding(

              padding: const pw.EdgeInsets.all(20),

              child: pw.Column(

                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,

                children: [

                  // ===============================
                  // HEADER
                  // ===============================

                  pw.Text(
                    "BreatheAI Lung Health Report",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Text(
                    "AI Powered Respiratory Screening",
                    style: const pw.TextStyle(fontSize: 12),
                  ),

                  pw.Divider(),

                  pw.SizedBox(height: 10),

                  // ===============================
                  // REPORT DETAILS
                  // ===============================

                  pw.Text("Report ID: $reportId"),
                  pw.Text("Date: ${now.toLocal()}"),

                  pw.SizedBox(height: 20),

                  // ===============================
                  // SCAN RESULT
                  // ===============================

                  pw.Text(
                    "Scan Result",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 10),

                  pw.Text("Prediction: $prediction"),

                  pw.Text(
                    "Confidence Score: ${(confidence * 100).toStringAsFixed(2)}%",
                  ),

                  pw.Text("Risk Severity: $severity"),

                  pw.SizedBox(height: 20),

                  // ===============================
                  // RECOMMENDATION
                  // ===============================

                  pw.Text(
                    "Doctor Recommendation",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 10),

                  pw.Text(recommendation),

                  pw.SizedBox(height: 30),

                  // ===============================
                  // DISCLAIMER
                  // ===============================

                  pw.Divider(),

                  pw.Text(
                    "Disclaimer",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Text(
                    "This report is generated using an AI-based lung sound "
                    "analysis system and should not be considered a final "
                    "medical diagnosis. Please consult a certified medical "
                    "professional for clinical evaluation.",
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final dir = await getApplicationDocumentsDirectory();

      final file = File(
        "${dir.path}/breatheai_report_${now.millisecondsSinceEpoch}.pdf",
      );

      await file.writeAsBytes(await pdf.save());

      return file.path;

    } catch (e) {

      throw Exception("PDF generation failed: $e");
    }
  }
}