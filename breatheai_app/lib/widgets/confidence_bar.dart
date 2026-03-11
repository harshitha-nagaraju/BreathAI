import 'package:flutter/material.dart';

class ConfidenceBar extends StatelessWidget {

  final double value;

  const ConfidenceBar({
    super.key,
    required this.value,
  });

  // ===============================
  // GET BAR COLOR
  // ===============================

  Color getColor() {

    if (value < 0.40) {
      return Colors.green;
    }

    if (value < 0.70) {
      return Colors.orange;
    }

    return Colors.red;
  }

  // ===============================
  // CONFIDENCE LABEL
  // ===============================

  String getLevel() {

    if (value < 0.40) {
      return "Low";
    }

    if (value < 0.70) {
      return "Moderate";
    }

    return "High";
  }

  @override
  Widget build(BuildContext context) {

    double percent = value * 100;

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            const Text(
              "Confidence Score",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "${percent.toStringAsFixed(1)}%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        LinearProgressIndicator(
          value: value,
          minHeight: 12,
          borderRadius: BorderRadius.circular(8),
          color: getColor(),
          backgroundColor: Colors.grey.shade300,
        ),

        const SizedBox(height: 6),

        Text(
          "Confidence Level: ${getLevel()}",
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}