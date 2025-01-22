import 'package:flutter/widgets.dart';

class StarData {
  late final AnimationController controller;
  late final double size;
  late final Offset initialPosition;

  StarData(
      {required this.controller,
      required this.size,
      required this.initialPosition});
}
