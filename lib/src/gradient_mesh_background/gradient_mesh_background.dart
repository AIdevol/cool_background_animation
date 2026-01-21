import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Configuration for the Gradient Mesh Background
class GradientMeshConfig {
  final List<Color> colors;
  final double animationSpeed;
  final int gridSize;
  final double waveAmplitude;
  final double waveFrequency;
  final bool enableBlur;
  final double blurIntensity;
  final bool enablePulsing;
  final double pulseIntensity;
  final BlendMode blendMode;

  const GradientMeshConfig({
    this.colors = const [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
      Color(0xFFF093FB),
      Color(0xFF4FACFE),
    ],
    this.animationSpeed = 1.0,
    this.gridSize = 8,
    this.waveAmplitude = 50.0,
    this.waveFrequency = 0.5,
    this.enableBlur = true,
    this.blurIntensity = 0.3,
    this.enablePulsing = true,
    this.pulseIntensity = 0.2,
    this.blendMode = BlendMode.screen,
  });
}

/// A beautiful animated gradient mesh background with fluid motion
class GradientMeshBackground extends StatefulWidget {
  final GradientMeshConfig config;
  final Widget? child;
  final BoxDecoration? backgroundDecoration;

  const GradientMeshBackground({
    super.key,
    this.config = const GradientMeshConfig(),
    this.child,
    this.backgroundDecoration,
  });

  @override
  State<GradientMeshBackground> createState() => _GradientMeshBackgroundState();
}

class _GradientMeshBackgroundState extends State<GradientMeshBackground>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late AnimationController _colorShiftController;
  late Animation<double> _waveAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _colorShiftAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (3000 / widget.config.animationSpeed).round(),
      ),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _colorShiftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _waveController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _colorShiftAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _colorShiftController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _colorShiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.backgroundDecoration,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([
              _waveController,
              _pulseController,
              _colorShiftController,
            ]),
            builder: (context, child) {
              return CustomPaint(
                painter: GradientMeshPainter(
                  config: widget.config,
                  waveProgress: _waveAnimation.value,
                  pulseProgress: _pulseAnimation.value,
                  colorShiftProgress: _colorShiftAnimation.value,
                ),
                size: Size.infinite,
              );
            },
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class GradientMeshPainter extends CustomPainter {
  final GradientMeshConfig config;
  final double waveProgress;
  final double pulseProgress;
  final double colorShiftProgress;

  GradientMeshPainter({
    required this.config,
    required this.waveProgress,
    required this.pulseProgress,
    required this.colorShiftProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridWidth = size.width / config.gridSize;
    final gridHeight = size.height / config.gridSize;

    // Create a list of control points with animated positions
    final List<List<Offset>> controlPoints = [];
    final List<List<Color>> gridColors = [];

    for (int i = 0; i <= config.gridSize; i++) {
      final List<Offset> row = [];
      final List<Color> colorRow = [];
      for (int j = 0; j <= config.gridSize; j++) {
        // Calculate wave offset
        final waveX = math.sin(
              waveProgress + (i * config.waveFrequency) + (j * 0.3),
            ) *
            config.waveAmplitude;
        final waveY = math.cos(
              waveProgress * 1.3 + (j * config.waveFrequency) + (i * 0.2),
            ) *
            config.waveAmplitude;

        // Add pulse effect
        final pulseOffset = config.enablePulsing
            ? (math.sin(pulseProgress * 2 * math.pi) * config.pulseIntensity * 20)
            : 0.0;

        final x = (j * gridWidth) + waveX * 0.3 + pulseOffset;
        final y = (i * gridHeight) + waveY * 0.3 + pulseOffset;

        row.add(Offset(x, y));

        // Calculate color based on position and color shift
        final normalizedX = j / config.gridSize;
        final normalizedY = i / config.gridSize;
        final distance = math.sqrt(
          math.pow(normalizedX - 0.5, 2) + math.pow(normalizedY - 0.5, 2),
        );

        final colorIndex = ((normalizedX + normalizedY + colorShiftProgress) *
                config.colors.length) %
            config.colors.length;
        final nextColorIndex = ((colorIndex + 1) % config.colors.length).toInt();
        final currentColorIndex = colorIndex.toInt();

        final t = colorIndex - currentColorIndex;
        final color = Color.lerp(
          config.colors[currentColorIndex],
          config.colors[nextColorIndex],
          t,
        )!;

        // Apply distance-based opacity for smooth blending
        final opacity = 1.0 - (distance * 0.5);
        colorRow.add(color.withOpacity(opacity.clamp(0.3, 1.0)));
      }
      controlPoints.add(row);
      gridColors.add(colorRow);
    }

    // Draw gradient mesh using triangles
    for (int i = 0; i < config.gridSize; i++) {
      for (int j = 0; j < config.gridSize; j++) {
        final topLeft = controlPoints[i][j];
        final topRight = controlPoints[i][j + 1];
        final bottomLeft = controlPoints[i + 1][j];
        final bottomRight = controlPoints[i + 1][j + 1];

        final topLeftColor = gridColors[i][j];
        final topRightColor = gridColors[i][j + 1];
        final bottomLeftColor = gridColors[i + 1][j];
        final bottomRightColor = gridColors[i + 1][j + 1];

        // Draw two triangles to form a quad
        _drawGradientTriangle(
          canvas,
          topLeft,
          topRight,
          bottomLeft,
          topLeftColor,
          topRightColor,
          bottomLeftColor,
        );

        _drawGradientTriangle(
          canvas,
          topRight,
          bottomRight,
          bottomLeft,
          topRightColor,
          bottomRightColor,
          bottomLeftColor,
        );
      }
    }

    // Apply blur effect if enabled
    if (config.enableBlur) {
      final blurPaint = Paint()
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          config.blurIntensity * 10,
        );
      // Draw a subtle overlay for additional blur effect
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        blurPaint,
      );
    }
  }

  void _drawGradientTriangle(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Offset p3,
    Color c1,
    Color c2,
    Color c3,
  ) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    // Create gradient shader
    final rect = Rect.fromPoints(
      Offset(
        math.min(math.min(p1.dx, p2.dx), p3.dx),
        math.min(math.min(p1.dy, p2.dy), p3.dy),
      ),
      Offset(
        math.max(math.max(p1.dx, p2.dx), p3.dx),
        math.max(math.max(p1.dy, p2.dy), p3.dy),
      ),
    );

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [c1, c2, c3],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GradientMeshPainter oldDelegate) {
    return oldDelegate.waveProgress != waveProgress ||
        oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.colorShiftProgress != colorShiftProgress;
  }
}
