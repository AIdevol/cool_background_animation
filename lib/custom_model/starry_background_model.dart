import 'dart:math';
import 'dart:ui';

class ShootingStar {
  final double startX;
  final double startY;
  final double angle;
  final double speed;
  double currentDistance = 0;

  ShootingStar({
    required this.startX,
    required this.startY,
    required this.angle,
    required this.speed,
  });

  Offset getCurrentPosition() {
    return Offset(
      startX + cos(angle) * currentDistance,
      startY + sin(angle) * currentDistance,
    );
  }
}
