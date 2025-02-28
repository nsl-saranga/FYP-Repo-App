import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Ensure this package is in your pubspec.yaml

class CircularProgressBar extends StatelessWidget {
  final double percent; // Value between 0 and 1
  final double radius;
  final double lineWidth;
  final Color progressColor;
  final Color backgroundColor;
  final String label; // Text in the center
  final TextStyle? labelStyle; // Style for the text

  const CircularProgressBar({
    super.key,
    required this.percent,
    this.radius = 60,
    this.lineWidth = 12,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    required this.label,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      percent: percent,
      radius: radius,
      lineWidth: lineWidth,
      animation: true,
      animateFromLastPercent: true,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
      center: Text(
        label,
        style: labelStyle ??
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
    );
  }
}
