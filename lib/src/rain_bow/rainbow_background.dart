import 'dart:math' as Math;
import 'package:flutter/material.dart';
import '../../custom_model/rainbow_config.dart';

class RainbowBackground extends StatefulWidget {
  const RainbowBackground({
    super.key,
    this.child,
    this.config = const RainbowConfig(),
  });

  final Widget? child;
  final RainbowConfig config;

  @override
  State<RainbowBackground> createState() => _RainbowBackgroundState();
}

class _RainbowBackgroundState extends State<RainbowBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.config.animationDuration),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: widget.config.backgroundColor),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: RainbowPainter(
                config: widget.config,
                shimmerValue: _shimmerAnimation.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class RainbowPainter extends CustomPainter {
  final RainbowConfig config;
  final double shimmerValue;

  RainbowPainter({
    required this.config,
    required this.shimmerValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.arcThickness
      ..strokeCap = StrokeCap.round;

    final double maxRadius = size.width * config.heightRatio;
    
    // Calculate rainbow position based on configuration
    final double rainbowY = config.position == RainbowPosition.bottom
        ? size.height * (1 - config.positionOffset)
        : size.height * config.positionOffset;

    // Add shadow for glow effect
    paint.maskFilter = MaskFilter.blur(
      BlurStyle.outer,
      config.glowIntensity * 10,
    );

    // Calculate start angle and sweep based on orientation
    final double startAngle = _getStartAngle();
    final double sweepAngle = Math.pi;

    for (int i = 0; i < config.colors.length; i++) {
      final color = config.colors[i];
      final nextColor = i < config.colors.length - 1 
          ? config.colors[i + 1] 
          : config.colors[0];

      final double radius = maxRadius - (i * (config.arcThickness + config.arcSpacing));
      
      // Apply shimmer effect
      final double opacity = config.enableShimmer 
          ? (Math.sin(_normalizeIndex(i) * Math.pi + shimmerValue * Math.pi * 2) + 1) / 2
          : 1.0;

      if (config.useGradient) {
        paint.shader = SweepGradient(
          colors: [
            color.withOpacity(opacity),
            nextColor.withOpacity(opacity),
            color.withOpacity(opacity),
          ],
          stops: const [0.0, 0.5, 1.0],
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          transform: GradientRotation(shimmerValue * Math.pi / 8),
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width / 2, rainbowY),
            radius: radius,
          ),
        );
      } else {
        paint.color = color.withOpacity(opacity);
        paint.shader = null;
      }

      // Draw the arc with dynamic angles
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, rainbowY),
          radius: radius,
        ),
        startAngle + (Math.sin(shimmerValue * Math.pi) * 0.05),
        sweepAngle + 0.2,
        false,
        paint,
      );
    }
  }

  double _getStartAngle() {
    if (config.position == RainbowPosition.bottom) {
      return config.orientation == RainbowOrientation.up ? 0 : Math.pi;
    } else {
      return config.orientation == RainbowOrientation.down ? 0 : Math.pi;
    }
  }

  double _normalizeIndex(int index) {
    return index / (config.colors.length - 1);
  }

  @override
  bool shouldRepaint(covariant RainbowPainter oldDelegate) {
    return oldDelegate.shimmerValue != shimmerValue;
  }
}

