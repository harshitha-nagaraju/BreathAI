import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final HistoryService historyService = HistoryService();

  List<Map<String, dynamic>> scans = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // ===============================
  // LOAD HISTORY
  // ===============================

  Future<void> loadHistory() async {

    final data = await historyService.getHistory();

    if (!mounted) return;

    setState(() {
      scans = data.reversed.toList(); // newest first
    });
  }

  // ===============================
  // UI
  // ===============================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Scan History"),
      ),

      body: scans.isEmpty
          ? const Center(
              child: Text(
                "No scan history available",
                style: TextStyle(fontSize: 16),
              ),
            )

          : ListView.builder(

              itemCount: scans.length,

              itemBuilder: (context, index) {

                final scan = scans[index];

                double confidence =
                    (scan["confidence"] ?? 0).toDouble();

                String prediction =
                    scan["prediction"] ?? "Unknown";

                String risk =
                    scan["risk"] ?? "Unknown";

                String date =
                    scan["date"] ?? "";

                String? reportPath =
                    scan["reportPath"];

                // format date
                String formattedDate = date.isNotEmpty
                    ? DateFormat("dd MMM yyyy  HH:mm")
                        .format(DateTime.parse(date))
                    : "";

                return Card(

                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),

                  child: ListTile(

                    leading: const Icon(
                      Icons.monitor_heart,
                      color: Colors.blue,
                    ),

                    title: Text(prediction),

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text("Risk: $risk"),

                        Text(formattedDate),
                      ],
                    ),

                    trailing: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Text(
                          "${(confidence * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height:4),

                        if (reportPath != null)
                          GestureDetector(
                            onTap: () {
                              OpenFile.open(reportPath);
                            },
                            child: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}