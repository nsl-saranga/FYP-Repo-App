// import 'package:flutter/material.dart';
//
// class HoneycombPainter extends CustomPainter {
//   final Animation<double> animation;
//   final Color baseColor;
//
//   HoneycombPainter(this.animation, this.baseColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = baseColor.withOpacity(0.1)
//       ..style = PaintingStyle.fill;
//
//     final strokePaint = Paint()
//       ..color = baseColor.withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     final sideLength = 40.0;
//     final height = sideLength * math.sqrt(3);
//     final width = sideLength * 2;
//
//     final cols = (size.width / width).ceil() + 1;
//     final rows = (size.height / height).ceil() + 1;
//
//     final offsetX = animation.value * width;
//
//     for (int row = 0; row < rows; row++) {
//       for (int col = 0; col < cols; col++) {
//         final offsetY = (row % 2 == 0) ? 0.0 : height / 2;
//         final x = col * width - offsetX;
//         final y = row * height * 0.75;
//
//         if (x > size.width + width || y > size.height + height) continue;
//
//         final center = Offset(x + width / 2, y + height / 2);
//         _drawHexagon(canvas, center, sideLength, paint, strokePaint);
//       }
//     }
//   }
//
//   void _drawHexagon(Canvas canvas, Offset center, double sideLength,
//       Paint fillPaint, Paint strokePaint) {
//     final path = Path();
//     for (int i = 0; i < 6; i++) {
//       final angle = 2.0 * math.pi / 6 * i;
//       final x = center.dx + sideLength * math.cos(angle);
//       final y = center.dy + sideLength * math.sin(angle);
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//     path.close();
//     canvas.drawPath(path, fillPaint);
//     canvas.drawPath(path, strokePaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant HoneycombPainter oldDelegate) {
//     return animation != oldDelegate.animation || baseColor != oldDelegate.baseColor;
//   }
// }