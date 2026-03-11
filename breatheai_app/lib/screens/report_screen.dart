import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

class ReportScreen extends StatelessWidget {
  final String reportPath;

  const ReportScreen({super.key, required this.reportPath});

  // Copy file path
  void copyPath(BuildContext context) {
    Clipboard.setData(ClipboardData(text: reportPath));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Report path copied"),
      ),
    );
  }

  // Open PDF
  void openReport(BuildContext context) async {
    await OpenFile.open(reportPath);
  }

  // Share PDF
  void shareReport() async {
    await Share.shareXFiles([XFile(reportPath)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Report"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.picture_as_pdf,
              size: 100,
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            const Text(
              "Report Generated Successfully",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Report saved at:",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            SelectableText(
              reportPath,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blueGrey,
              ),
            ),

            const SizedBox(height: 30),

            // OPEN PDF
            ElevatedButton.icon(
              onPressed: () => openReport(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text("Open Report"),
            ),

            const SizedBox(height: 10),

            // SHARE REPORT
            ElevatedButton.icon(
              onPressed: shareReport,
              icon: const Icon(Icons.share),
              label: const Text("Share Report"),
            ),

            const SizedBox(height: 10),

            // COPY PATH
            ElevatedButton.icon(
              onPressed: () => copyPath(context),
              icon: const Icon(Icons.copy),
              label: const Text("Copy Path"),
            ),
          ],
        ),
      ),
    );
  }
}