import 'package:flutter/material.dart';

enum RainbowPosition { top, bottom }

enum RainbowOrientation { up, down }

class RainbowConfig {
  /// The colors of the rainbow
  final List<Color> colors;

  /// The thickness of each arc
  final double arcThickness;

  /// Background color behind the rainbow
  final Color backgroundColor;

  /// Enable or disable gradient transitions
  final bool useGradient;

  /// The spacing between rainbow arcs
  final double arcSpacing;

  /// Rainbow height ratio (0.0 to 1.0)
  final double heightRatio;

  /// Position offset from anchor (0.0 to 1.0)
  final double positionOffset;

  /// Glow intensity (0.0 to 1.0)
  final double glowIntensity;

  /// Animation duration in milliseconds
  final int animationDuration;

  /// Enable shimmer effect
  final bool enableShimmer;

  /// Rainbow position (top or bottom)
  final RainbowPosition position;

  /// Rainbow orientation (up or down)
  final RainbowOrientation orientation;

  const RainbowConfig({
    this.colors = const [
      Color(0xFFFF1744), // Vibrant Red
      Color(0xFFFF9100), // Bright Orange
      Color(0xFFFFEA00), // Sunny Yellow
      Color(0xFF00E676), // Spring Green
      Color(0xFF00B0FF), // Sky Blue
      Color(0xFF651FFF), // Rich Indigo
      Color(0xFFAA00FF), // Vivid Purple
    ],
    this.arcThickness = 25.0,
    this.backgroundColor = Colors.black,
    this.useGradient = true,
    this.arcSpacing = 8.0,
    this.heightRatio = 0.6,
    this.positionOffset = 0.15,
    this.glowIntensity = 0.5,
    this.animationDuration = 3000,
    this.enableShimmer = true,
    this.position = RainbowPosition.bottom,
    this.orientation = RainbowOrientation.up,
  })  : assert(positionOffset >= 0 && positionOffset <= 1),
        assert(heightRatio > 0 && heightRatio <= 1),
        assert(glowIntensity >= 0 && glowIntensity <= 1);
}
