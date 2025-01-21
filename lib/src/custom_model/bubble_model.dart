import 'dart:math';

import 'package:flutter/material.dart';

class BubbleConfig {
  final double minRadius;
  final double maxRadius;
  final double minSpeed;
  final double maxSpeed;
  final double minOpacity;
  final double maxOpacity;
  final bool enableGradient;
  final List<Color> gradientColors;
  final bool enablePulsing;
  final Duration pulsingDuration;
  final bool enableWobble;
  final double wobbleIntensity;

  const BubbleConfig({
    this.minRadius = 10,
    this.maxRadius = 40,
    this.minSpeed = 1,
    this.maxSpeed = 3,
    this.minOpacity = 0.2,
    this.maxOpacity = 0.8,
    this.enableGradient = false,
    this.gradientColors = const [Colors.blue, Colors.lightBlue],
    this.enablePulsing = false,
    this.pulsingDuration = const Duration(seconds: 2),
    this.enableWobble = false,
    this.wobbleIntensity = 5.0,
  });
}

class Bubble {
  double x;
  double y;
  double radius;
  double speed;
  double opacity;
  Color color;
  double wobbleOffset = 0;
  double wobbleSpeed;
  double pulseScale = 1.0;

  Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.color,
    required this.wobbleSpeed,
  });

  factory Bubble.random(double maxWidth, double maxHeight, BubbleConfig config, List<Color> colors) {
    final random = Random();
    return Bubble(
      x: random.nextDouble() * maxWidth,
      y: maxHeight + (random.nextDouble() * 40 + config.maxRadius),
      radius: random.nextDouble() * (config.maxRadius - config.minRadius) + config.minRadius,
      speed: random.nextDouble() * (config.maxSpeed - config.minSpeed) + config.minSpeed,
      opacity: random.nextDouble() * (config.maxOpacity - config.minOpacity) + config.minOpacity,
      wobbleSpeed: random.nextDouble() * 2 * pi,
      color: colors[random.nextInt(colors.length)],
    );
  }

  void move(BubbleConfig config, double time) {
    y -= speed;

    if (config.enableWobble) {
      wobbleOffset = sin(time + wobbleSpeed) * config.wobbleIntensity;
      x += wobbleOffset;
    }
  }

  bool isOffScreen() => y < -radius;
}
