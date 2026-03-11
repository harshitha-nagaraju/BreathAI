import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {

  final String reportPath;

  const ReportScreen({super.key, required this.reportPath});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Medical Report")),

      body: Center(
        child: Text(
          "Report saved at:\n$reportPath",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}