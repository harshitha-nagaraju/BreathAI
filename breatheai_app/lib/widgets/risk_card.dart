import 'package:flutter/material.dart';

class RiskCard extends StatelessWidget {

  final double risk;
  final String severity;

  const RiskCard({
    super.key,
    required this.risk,
    required this.severity,
  });

  // ===============================
  // RISK COLOR
  // ===============================

  Color getColor() {

    if (risk < 0.30) {
      return Colors.green;
    }

    if (risk < 0.60) {
      return Colors.orange;
    }

    if (risk < 0.85) {
      return Colors.red;
    }

    return Colors.purple;
  }

  // ===============================
  // RISK MESSAGE
  // ===============================

  String getMessage() {

    if (risk < 0.45) {
      return "Low risk detected";
    }

    if (risk < 0.60) {
      return "Moderate respiratory risk";
    }

    if (risk < 0.85) {
      return "High respiratory risk";
    }

    return "Critical respiratory condition";
  }

  @override
  Widget build(BuildContext context) {

    final double safeRisk = risk.clamp(0.0, 1.0);

    return Card(

      elevation: 5,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const Text(
              "Risk Assessment",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              severity,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: getColor(),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "${(safeRisk * 100).toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: safeRisk,
              minHeight: 12,
              borderRadius: BorderRadius.circular(8),
              color: getColor(),
              backgroundColor: Colors.grey.shade300,
            ),

            const SizedBox(height: 12),

            Text(
              getMessage(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}