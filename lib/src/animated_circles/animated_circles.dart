import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedCircles extends StatefulWidget {
  @override
  _AnimatedCirclesState createState() => _AnimatedCirclesState();
}

class _AnimatedCirclesState extends State<AnimatedCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Adjustable parameters
  Color backgroundColor = Colors.indigo.shade900;
  Color circleColor = Colors.purple;
  double strokeWidth = 3.0;
  int circleCount = 8;
  double speedMultiplier = 1.0;
  bool useRainbowColors = true;
  bool useBlurEffect = true;
  bool usePulseEffect = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSpeed(double value) {
    setState(() {
      speedMultiplier = value;
      _controller.duration =
          Duration(milliseconds: (6000 / speedMultiplier).round());
      if (_controller.isAnimating) {
        _controller.repeat();
      }
    });
  }

  void _updateCircleCount(double value) {
    setState(() {
      circleCount = value.round();
    });
  }

  void _updateStrokeWidth(double value) {
    setState(() {
      strokeWidth = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Beautiful Circles'),
        backgroundColor: Colors.black54,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.width),
                    painter: CirclePainter(
                      _controller.value,
                      circleCount,
                      circleColor,
                      strokeWidth,
                      useRainbowColors,
                      useBlurEffect,
                      usePulseEffect,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            color: Colors.black45,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circle count slider
                Row(
                  children: [
                    Icon(Icons.circle_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Circles:'),
                    Expanded(
                      child: Slider(
                        value: circleCount.toDouble(),
                        min: 1,
                        max: 20,
                        divisions: 19,
                        label: circleCount.toString(),
                        onChanged: _updateCircleCount,
                      ),
                    ),
                    Text('$circleCount'),
                  ],
                ),

                // Speed slider
                Row(
                  children: [
                    Icon(Icons.speed, size: 18),
                    SizedBox(width: 8),
                    Text('Speed:'),
                    Expanded(
                      child: Slider(
                        value: speedMultiplier,
                        min: 0.1,
                        max: 3.0,
                        divisions: 29,
                        label: speedMultiplier.toStringAsFixed(1),
                        onChanged: _updateSpeed,
                      ),
                    ),
                    Text('${speedMultiplier.toStringAsFixed(1)}x'),
                  ],
                ),

                // Width slider
                Row(
                  children: [
                    Icon(Icons.line_weight, size: 18),
                    SizedBox(width: 8),
                    Text('Width:'),
                    Expanded(
                      child: Slider(
                        value: strokeWidth,
                        min: 1.0,
                        max: 20.0,
                        divisions: 19,
                        label: strokeWidth.toStringAsFixed(1),
                        onChanged: _updateStrokeWidth,
                      ),
                    ),
                    Text('${strokeWidth.toStringAsFixed(1)}'),
                  ],
                ),

                // Effect toggles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Rainbow'),
                        Switch(
                          value: useRainbowColors,
                          onChanged: (value) {
                            setState(() {
                              useRainbowColors = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Blur'),
                        Switch(
                          value: useBlurEffect,
                          onChanged: (value) {
                            setState(() {
                              useBlurEffect = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Pulse'),
                        Switch(
                          value: usePulseEffect,
                          onChanged: (value) {
                            setState(() {
                              usePulseEffect = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                // Color picker row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorOption(Colors.purple, 'Purple'),
                    _colorOption(Colors.blue, 'Blue'),
                    _colorOption(Colors.teal, 'Teal'),
                    _colorOption(Colors.green, 'Green'),
                    _colorOption(Colors.amber, 'Amber'),
                    _colorOption(Colors.orange, 'Orange'),
                    _colorOption(Colors.red, 'Red'),
                  ],
                ),

                // Background color picker row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bgColorOption(Colors.black, 'Black'),
                    _bgColorOption(Colors.indigo.shade900, 'Indigo'),
                    _bgColorOption(Colors.blue.shade900, 'Dark Blue'),
                    _bgColorOption(Colors.purple.shade900, 'Dark Purple'),
                    _bgColorOption(Colors.teal.shade900, 'Dark Teal'),
                    _bgColorOption(Colors.green.shade900, 'Dark Green'),
                    _bgColorOption(Colors.red.shade900, 'Dark Red'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorOption(Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          setState(() {
            circleColor = color;
          });
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: circleColor == color ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bgColorOption(Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          setState(() {
            backgroundColor = color;
          });
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  backgroundColor == color ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double animationValue;
  final int circleCount;
  final Color baseColor;
  final double strokeWidth;
  final bool useRainbowColors;
  final bool useBlurEffect;
  final bool usePulseEffect;

  CirclePainter(
    this.animationValue,
    this.circleCount,
    this.baseColor,
    this.strokeWidth,
    this.useRainbowColors,
    this.useBlurEffect,
    this.usePulseEffect,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < circleCount; i++) {
      // Calculate base radius with animation
      final progress = i / circleCount;
      final baseRadius = progress * maxRadius;

      // Apply animation value for movement
      final animOffset = animationValue * (maxRadius / circleCount);
      double radius = (baseRadius + animOffset) % maxRadius;

      // Add pulsing effect if enabled
      if (usePulseEffect) {
        final pulseAmount = math.sin(animationValue * math.pi * 2 +
                (i / circleCount) * math.pi * 2) *
            5;
        radius += pulseAmount;
      }

      // Determine color based on settings
      Color circleColor;
      if (useRainbowColors) {
        // Create rainbow effect
        final hue = (progress * 360 + animationValue * 360) % 360;
        circleColor = HSVColor.fromAHSV(
          0.7 +
              (0.3 *
                  math.sin(
                      animationValue * math.pi * 2 + i)), // opacity variation
          hue, // hue
          0.8, // saturation
          0.9, // value (brightness)
        ).toColor();
      } else {
        // Use the base color with varying opacity
        final opacity = 0.4 + (0.6 * (1 - progress));
        circleColor = baseColor.withOpacity(opacity);
      }

      // Setup paint with or without blur
      final paint = Paint()
        ..color = circleColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      if (useBlurEffect) {
        paint.maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          (circleCount - i) / circleCount * 5,
        );
      }

      // Draw the circle
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.circleCount != circleCount ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.useRainbowColors != useRainbowColors ||
        oldDelegate.useBlurEffect != useBlurEffect ||
        oldDelegate.usePulseEffect != usePulseEffect;
  }
}
