import 'package:flutter/material.dart';

class SpectrogramWidget extends StatelessWidget {

  final List<double> spectrogram;

  const SpectrogramWidget({
    super.key,
    required this.spectrogram,
  });

  Color getColor(double value) {

    if (value < 0.3) {
      return Colors.blue.shade300;
    }

    if (value < 0.6) {
      return Colors.blueAccent;
    }

    return Colors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      height: 140,

      padding: const EdgeInsets.symmetric(vertical: 10),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.end,

        children: spectrogram.map((value) {

          final safeValue = value.clamp(0.0, 1.0);

          return Expanded(

            child: Container(

              margin: const EdgeInsets.symmetric(horizontal: 1),

              height: safeValue * 110,

              decoration: BoxDecoration(

                color: getColor(safeValue),

                borderRadius: BorderRadius.circular(2),

              ),
            ),
          );

        }).toList(),
      ),
    );
  }
}