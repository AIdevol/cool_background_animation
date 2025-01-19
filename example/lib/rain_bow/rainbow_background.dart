import 'package:flutter/material.dart';

import '../custom_model/rainbow_config.dart';

class RainbowBackground extends StatelessWidget {
  const RainbowBackground({
    super.key,
    this.child,
    this.config = const RainbowConfig(),
  });

  /// Optional child widget to overlay on the rainbow background.
  final Widget? child;

  /// Configuration for customizing the rainbow appearance.
  final RainbowConfig config;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Draw the background color.
        Container(color: config.backgroundColor),
        CustomPaint(
          painter: RainbowPainter(config),
          child: child ?? Container(),
        ),
      ],
    );
  }
}

class RainbowPainter extends CustomPainter {
  RainbowPainter(this.config);

  final RainbowConfig config;

  @override
  void paint(Canvas canvas, Size size) {
    final double arcWidth = config.arcThickness;
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < config.colors.length; i++) {
      final color = config.colors[i];

      // If gradient is enabled, create a gradient.
      if (config.useGradient && i < config.colors.length - 1) {
        paint.shader = LinearGradient(
          colors: [color, config.colors[i + 1]],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      } else {
        paint.color = color;
        paint.shader = null;
      }

      // Draw each arc.
      canvas.drawArc(
        Rect.fromLTWH(
          -arcWidth * (i + 1),
          size.height / 2 - arcWidth * (i + 1),
          size.width + arcWidth * 2 * (i + 1),
          size.height + arcWidth * 2 * (i + 1),
        ),
        0,
        3.14, // Semi-circle
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
