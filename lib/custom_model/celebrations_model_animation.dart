import 'package:flutter/material.dart';
import 'dart:math' as math;

class Particle {
  final Color color;
  final double size;
  final double angle;
  final double velocity;
  final double rotationAngle;
  final double lifetime;
  final double startTime;

  Particle({
    required this.color,
    required this.size,
    required this.angle,
    required this.velocity,
    this.rotationAngle = 0.0,
    this.lifetime = 1.0,
    this.startTime = 0.0,
  });
}

class StarPainter extends CustomPainter {
  final Color color;
  final double rotation;

  StarPainter({
    required this.color,
    this.rotation = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    for (var i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + 4 * math.pi * i / 5;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) =>
      color != oldDelegate.color || rotation != oldDelegate.rotation;
}

class HeartPainter extends CustomPainter {
  final Color color;
  final double rotation;

  HeartPainter({
    required this.color,
    this.rotation = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    path.moveTo(size.width / 2, size.height / 5);

    path.cubicTo(
        size.width / 8, 0,
        -size.width / 4, size.height / 2,
        size.width / 2, size.height
    );

    path.cubicTo(
        size.width * 1.25, size.height / 2,
        size.width * 7 / 8, 0,
        size.width / 2, size.height / 5
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HeartPainter oldDelegate) =>
      color != oldDelegate.color || rotation != oldDelegate.rotation;
}
