import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _WelcomeBackgroundPainter(color),
      ),
    );
  }
}

class _WelcomeBackgroundPainter extends CustomPainter {
  const _WelcomeBackgroundPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Top-right large circle
    paint.color = color.withValues(alpha: 0.08);

    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.03),
      size.width * 0.30,
      paint,
    );

    // Top-left small circle
    paint.color = color.withValues(alpha: 0.06);

    canvas.drawCircle(
      Offset(size.width * 0.02, size.height * 0.20),
      size.width * 0.15,
      paint,
    );

    // First bottom wave
    final firstWave = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.66,
        size.width * 0.50,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.78,
        size.width,
        size.height * 0.72,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    paint.color = color.withValues(alpha: 0.05);
    canvas.drawPath(firstWave, paint);

    // Second bottom wave
    final secondWave = Path()
      ..moveTo(0, size.height * 0.77)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.70,
        size.width * 0.55,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.84,
        size.width,
        size.height * 0.77,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    paint.color = color.withValues(alpha: 0.07);
    canvas.drawPath(secondWave, paint);
  }

  @override
  bool shouldRepaint(covariant _WelcomeBackgroundPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}