import 'package:flutter/material.dart';

/// Configuration model for the RainbowBackground widget.
class RainbowConfig {
  /// The colors of the rainbow. Default is VIBGYOR.
  final List<Color> colors;

  /// The thickness of each arc (band) in the rainbow.
  final double arcThickness;

  /// Background color behind the rainbow.
  final Color backgroundColor;

  /// Enable or disable gradient transitions between arcs.
  final bool useGradient;

  /// Creates a RainbowConfig instance.
  const RainbowConfig({
    this.colors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ],
    this.arcThickness = 20.0,
    this.backgroundColor = Colors.black,
    this.useGradient = false,
  });
}
