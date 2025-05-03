import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A customizable widget that displays an animated radial burst effect.
///
/// This widget creates rays emanating from a center point with customizable
/// colors, speeds, and other properties.
class RadialBurst extends StatefulWidget {
  /// The size of the radial burst effect.
  /// If null, it will expand to fill its parent.
  final Size? size;

  /// The colors used for the rays. These colors will be randomly selected
  /// for each ray unless [uniformRayColor] is set.
  final List<Color> rayColors;

  /// The number of rays to draw.
  final int numberOfRays;

  /// The maximum length of rays as a percentage of the maximum possible radius.
  /// A value of 1.0 means rays can extend to the corners of the container.
  final double rayLengthFactor;

  /// The animation duration for a complete cycle.
  final Duration animationDuration;

  /// Whether the animation should repeat automatically.
  final bool autoRepeat;

  /// Whether the animation should reverse direction after completing a cycle.
  final bool autoReverse;

  /// Initial direction of the animation. True for clockwise, false for counter-clockwise.
  final bool clockwise;

  /// The opacity of the center glow.
  final double centerGlowOpacity;

  /// The radius of the center glow as a percentage of the maximum possible radius.
  final double centerGlowRadiusFactor;

  /// The colors for the center glow gradient.
  final List<Color> centerGlowColors;

  /// The stops for the center glow gradient.
  final List<double> centerGlowStops;

  /// Whether all rays should have the same color. If true, the first color
  /// in [rayColors] will be used for all rays.
  final bool uniformRayColor;

  /// The minimum width of a ray.
  final double minRayWidth;

  /// The maximum width of a ray.
  final double maxRayWidth;

  /// Random seed for consistent random generations between rebuilds.
  final int randomSeed;

  /// Whether to vary the length of rays. If false, all rays will have the same length.
  final bool varyRayLengths;

  /// Whether the burst should rotate. If false, rays will only pulse/animate in place.
  final bool rotate;

  /// The background color of the widget.
  final Color? backgroundColor;

  /// Creates a RadialBurst widget.
  const RadialBurst({
    Key? key,
    this.size,
    this.rayColors = const [
      Color(0xFFF06292), // Pink 300
      Color(0xFFEC407A), // Pink 400
      Colors.black,
      Colors.white,
      Color(0xFFF48FB1), // Pink 200
      Color(0xDD000000), // Black87
      Color(0xB3FFFFFF), // White70
    ],
    this.numberOfRays = 120,
    this.rayLengthFactor = 1.0,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.autoRepeat = true,
    this.autoReverse = false,
    this.clockwise = true,
    this.centerGlowOpacity = 0.8,
    this.centerGlowRadiusFactor = 0.4,
    this.centerGlowColors = const [
      Color(0xCCF06292), // Pink 300 with opacity
      Color(0x80F48FB1), // Pink 200 with opacity
      Color(0x00FFFFFF), // Transparent white
    ],
    this.centerGlowStops = const [0.0, 0.2, 1.0],
    this.uniformRayColor = false,
    this.minRayWidth = 2.0,
    this.maxRayWidth = 7.0,
    this.randomSeed = 42,
    this.varyRayLengths = true,
    this.rotate = true,
    this.backgroundColor,
  })  : assert(numberOfRays > 0, 'Number of rays must be greater than 0'),
        assert(rayLengthFactor > 0 && rayLengthFactor <= 1.0,
        'Ray length factor must be between 0 and 1.0'),
        assert(centerGlowOpacity >= 0 && centerGlowOpacity <= 1.0,
        'Center glow opacity must be between 0 and 1.0'),
        assert(centerGlowRadiusFactor >= 0 && centerGlowRadiusFactor <= 1.0,
        'Center glow radius factor must be between 0 and 1.0'),
        assert(minRayWidth > 0, 'Minimum ray width must be greater than 0'),
        assert(maxRayWidth >= minRayWidth,
        'Maximum ray width must be greater than or equal to minimum ray width'),
        assert(
        centerGlowColors.length >= 2, 'At least 2 glow colors are required'),
        assert(centerGlowStops.length == centerGlowColors.length,
        'The number of stops must match the number of colors'),
  // assert(rayColors.isNotEmpty, 'Ray colors list cannot be empty'),
        super(key: key);

  @override
  RadialBurstState createState() => RadialBurstState();
}

/// The state for the RadialBurst widget.
class RadialBurstState extends State<RadialBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    if (widget.autoRepeat) {
      if (widget.autoReverse) {
        _controller.repeat(reverse: true);
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void didUpdateWidget(RadialBurst oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation duration if it changed
    if (widget.animationDuration != oldWidget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }

    // Handle changes to autoRepeat and autoReverse
    if (widget.autoRepeat != oldWidget.autoRepeat ||
        widget.autoReverse != oldWidget.autoReverse) {
      if (widget.autoRepeat) {
        if (widget.autoReverse) {
          _controller.repeat(reverse: true);
        } else {
          _controller.repeat();
        }
      } else if (!_isPaused) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Start or resume the animation
  void start() {
    _isPaused = false;
    if (widget.autoRepeat) {
      if (widget.autoReverse) {
        _controller.repeat(reverse: true);
      } else {
        _controller.repeat();
      }
    } else {
      _controller.forward();
    }
  }

  /// Pause the animation
  void pause() {
    _isPaused = true;
    _controller.stop();
  }

  /// Reset the animation to the beginning
  void reset() {
    _controller.reset();
    if (!_isPaused && widget.autoRepeat) {
      start();
    }
  }

  /// Animate to a specific position (0.0 to 1.0)
  void animateTo(double value, {Duration? duration, Curve curve = Curves.linear}) {
    assert(value >= 0.0 && value <= 1.0, 'Value must be between 0.0 and 1.0');
    _controller.animateTo(value, duration: duration, curve: curve);
  }

  /// Get the current animation value (0.0 to 1.0)
  double get value => _controller.value;

  /// Set the animation speed (duration in milliseconds)
  set speed(Duration duration) {
    _controller.duration = duration;
    if (!_isPaused && widget.autoRepeat) {
      _controller.stop();
      start();
    }
  }

  /// Reverse the animation direction
  void reverse() {
    if (_controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.reverse) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      width: widget.size?.width,
      height: widget.size?.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: RadialBurstPainter(
              animationValue: widget.clockwise ? _controller.value : 1 - _controller.value,
              rayColors: widget.rayColors,
              numberOfRays: widget.numberOfRays,
              rayLengthFactor: widget.rayLengthFactor,
              centerGlowOpacity: widget.centerGlowOpacity,
              centerGlowRadiusFactor: widget.centerGlowRadiusFactor,
              centerGlowColors: widget.centerGlowColors,
              centerGlowStops: widget.centerGlowStops,
              uniformRayColor: widget.uniformRayColor,
              minRayWidth: widget.minRayWidth,
              maxRayWidth: widget.maxRayWidth,
              randomSeed: widget.randomSeed,
              varyRayLengths: widget.varyRayLengths,
              rotate: widget.rotate,
            ),
            size: widget.size ?? MediaQuery.of(context).size,
          );
        },
      ),
    );
  }
}

/// The custom painter that draws the radial burst effect.
class RadialBurstPainter extends CustomPainter {
  final double animationValue;
  final List<Color> rayColors;
  final int numberOfRays;
  final double rayLengthFactor;
  final double centerGlowOpacity;
  final double centerGlowRadiusFactor;
  final List<Color> centerGlowColors;
  final List<double> centerGlowStops;
  final bool uniformRayColor;
  final double minRayWidth;
  final double maxRayWidth;
  final int randomSeed;
  final bool varyRayLengths;
  final bool rotate;

  RadialBurstPainter({
    required this.animationValue,
    required this.rayColors,
    required this.numberOfRays,
    required this.rayLengthFactor,
    required this.centerGlowOpacity,
    required this.centerGlowRadiusFactor,
    required this.centerGlowColors,
    required this.centerGlowStops,
    required this.uniformRayColor,
    required this.minRayWidth,
    required this.maxRayWidth,
    required this.randomSeed,
    required this.varyRayLengths,
    required this.rotate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height) / 2;
    final actualMaxRadius = maxRadius * rayLengthFactor;

    // Create a deterministic random generator for consistent results
    final random = math.Random(randomSeed);

    // Draw rays
    for (int i = 0; i < numberOfRays; i++) {
      final angle = 2 * math.pi * i / numberOfRays;

      // Calculate the rotated angle if rotation is enabled
      final rotatedAngle = rotate
          ? angle + animationValue * math.pi * 2
          : angle;

      // Randomize ray properties for more organic look or use uniform properties
      final rayLength = varyRayLengths
          ? actualMaxRadius * (0.5 + random.nextDouble() * 0.5)
          : actualMaxRadius;

      final rayWidth = minRayWidth + random.nextDouble() * (maxRayWidth - minRayWidth);

      // Select a color from our palette
      final Color rayColor = uniformRayColor
          ? rayColors.first
          : rayColors[random.nextInt(rayColors.length)];

      // Calculate ray endpoints
      final startPoint = center;

      // Apply a pulse effect if not rotating (animate the ray length)
      final pulseEffect = rotate ? 1.0 : 0.7 + 0.3 * math.sin(animationValue * math.pi * 2);

      final endPoint = Offset(
        center.dx + math.cos(rotatedAngle) * rayLength * pulseEffect,
        center.dy + math.sin(rotatedAngle) * rayLength * pulseEffect,
      );

      // Create a gradient paint
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            rayColor,
            rayColor.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: rayLength))
        ..strokeWidth = rayWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Draw the ray
      canvas.drawLine(startPoint, endPoint, paint);
    }

    // Add central glow if radius factor is greater than 0
    if (centerGlowRadiusFactor > 0) {
      final actualGlowColors = centerGlowColors.map((color) {
        if (color.opacity == 1.0) {
          return color.withOpacity(centerGlowOpacity);
        }
        return Color.fromRGBO(
          color.red,
          color.green,
          color.blue,
          color.opacity * centerGlowOpacity,
        );
      }).toList();

      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: actualGlowColors,
          stops: centerGlowStops,
        ).createShader(Rect.fromCircle(
          center: center,
          radius: maxRadius * centerGlowRadiusFactor,
        ));

      canvas.drawCircle(
        center,
        maxRadius * centerGlowRadiusFactor,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RadialBurstPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.centerGlowOpacity != centerGlowOpacity ||
        oldDelegate.rayLengthFactor != rayLengthFactor;
  }
}