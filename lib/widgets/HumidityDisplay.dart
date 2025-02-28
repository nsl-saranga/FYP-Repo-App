import 'package:flutter/material.dart';

class HumidityDrop extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double currentValue;

  const HumidityDrop({
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 130), // Width and height of the humidity drop
      painter: HumidityDropPainter(
        minValue: minValue,
        maxValue: maxValue,
        currentValue: currentValue,
      ),
    );
  }
}

class HumidityDropPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double currentValue;

  HumidityDropPainter({
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dropPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Paint outlinePaint = Paint()
      ..color = Colors.blue.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double normalizedValue =
        ((currentValue - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    // Draw the outline of the drop
    final Path dropPath = Path();
    final double centerX = size.width / 2;
    final double dropHeight = size.height;
    final double dropWidth = size.width;

    // Create a drop shape with an even more circular bottom
    dropPath.moveTo(centerX, 0);
    dropPath.quadraticBezierTo(0, dropHeight * 0.98, centerX, dropHeight);
    dropPath.quadraticBezierTo(dropWidth, dropHeight * 0.98, centerX, 0);
    dropPath.close();

    // Draw the outline of the drop
    canvas.drawPath(dropPath, outlinePaint);

    // Draw the filled portion of the drop
    final Rect fillRect = Rect.fromLTRB(
        0, dropHeight * (1.0 - normalizedValue), size.width, dropHeight);
    canvas.clipPath(dropPath);
    canvas.drawRect(fillRect, dropPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint when values change
  }
}
