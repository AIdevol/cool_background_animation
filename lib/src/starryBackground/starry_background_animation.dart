import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../custom_model/starry_background_model.dart';

class StarConfig {
  final double minSize;
  final double maxSize;
  final double minOpacity;
  final double maxOpacity;
  final Color starColor;
  final Duration minTwinkleDuration;
  final Duration maxTwinkleDuration;
  final bool enableMovement;
  final double movementSpeed;
  final bool enableTwinkling;

  const StarConfig({
    this.minSize = 1.0,
    this.maxSize = 3.0,
    this.minOpacity = 0.3,
    this.maxOpacity = 0.8,
    this.starColor = Colors.white,
    this.minTwinkleDuration = const Duration(milliseconds: 1000),
    this.maxTwinkleDuration = const Duration(milliseconds: 3000),
    this.enableMovement = true,
    this.movementSpeed = 1.0,
    this.enableTwinkling = true,
  });
}

class Star {
  double x;
  double y;
  final double size;
  final double baseOpacity;
  final double speed;
  final double angle;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.baseOpacity,
    required this.speed,
    required this.angle,
  });

  void move(Size size, double delta) {
    x += cos(angle) * speed * delta;
    y += sin(angle) * speed * delta;

    // Wrap around screen
    if (x < 0) x = size.width;
    if (x > size.width) x = 0;
    if (y < 0) y = size.height;
    if (y > size.height) y = 0;
  }
}

class StarryBackground extends StatefulWidget {
  final int numberOfStars;
  final StarConfig starConfig;
  final Gradient backgroundGradient;
  final bool enableShootingStars;
  final int numberOfShootingStars;
  final Duration shootingStarInterval;

  const StarryBackground({
    Key? key,
    this.numberOfStars = 100,
    this.starConfig = const StarConfig(),
    this.backgroundGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0B1026), Color(0xFF182052)],
    ),
    this.enableShootingStars = true,
    this.numberOfShootingStars = 2,
    this.shootingStarInterval = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  StarryBackgroundState createState() => StarryBackgroundState();
}

class StarryBackgroundState extends State<StarryBackground>
    with TickerProviderStateMixin {
  late List<Star> stars;
  late List<AnimationController> twinkleControllers;
  late List<Animation<double>> twinkleAnimations;
  final Random random = Random();
  late AnimationController _moveController;
  List<ShootingStar> shootingStars = [];

  @override
  void initState() {
    super.initState();
    _initializeStars();
    _initializeAnimations();
    _initializeMovement();
    if (widget.enableShootingStars) {
      _initializeShootingStars();
    }
  }

  void _initializeStars() {
    stars = List.generate(
      widget.numberOfStars,
          (index) => Star(
        x: random.nextDouble() * 100,
        y: random.nextDouble() * 100,
        size: _randomRange(widget.starConfig.minSize, widget.starConfig.maxSize),
        baseOpacity: _randomRange(
          widget.starConfig.minOpacity,
          widget.starConfig.maxOpacity,
        ),
        speed: _randomRange(0.5, 2.0) * widget.starConfig.movementSpeed,
        angle: random.nextDouble() * 2 * pi,
      ),
    );
  }

  void _initializeMovement() {
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _moveController.addListener(() {
      if (widget.starConfig.enableMovement) {
        setState(() {
          for (var star in stars) {
            star.move(context.size ?? const Size(100, 100), 0.016); // 60 FPS
          }
        });
      }
    });
  }

  void _initializeAnimations() {
    if (widget.starConfig.enableTwinkling) {
      twinkleControllers = List.generate(
        widget.numberOfStars,
            (index) => AnimationController(
          duration: Duration(
            milliseconds: random.nextInt(
              widget.starConfig.maxTwinkleDuration.inMilliseconds -
                  widget.starConfig.minTwinkleDuration.inMilliseconds,
            ) + widget.starConfig.minTwinkleDuration.inMilliseconds,
          ),
          vsync: this,
        ),
      );

      twinkleAnimations = twinkleControllers.map((controller) {
        return Tween<double>(begin: 0.3, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        );
      }).toList();

      for (var controller in twinkleControllers) {
        Future.delayed(
          Duration(milliseconds: random.nextInt(2000)),
              () => controller.repeat(reverse: true),
        );
      }
    }
  }

  void _initializeShootingStars() {
    Timer.periodic(widget.shootingStarInterval, (timer) {
      if (mounted) {
        _addShootingStar();
      } else {
        timer.cancel();
      }
    });
  }

  void _addShootingStar() {
    setState(() {
      final star = ShootingStar(
        startX: random.nextDouble() * (context.size?.width ?? 100),
        startY: random.nextDouble() * (context.size?.height ?? 100),
        angle: -pi / 4 + (random.nextDouble() - 0.5) * pi / 2,
        speed: _randomRange(100, 200),
      );
      shootingStars.add(star);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            shootingStars.remove(star);
          });
        }
      });
    });
  }

  double _randomRange(double min, double max) {
    return min + random.nextDouble() * (max - min);
  }

  @override
  void dispose() {
    _moveController.dispose();
    if (widget.starConfig.enableTwinkling) {
      for (var controller in twinkleControllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: widget.backgroundGradient),
      child: CustomPaint(
        painter: StarPainter(
          stars: stars,
          starConfig: widget.starConfig,
          animations: widget.starConfig.enableTwinkling ? twinkleAnimations : null,
          shootingStars: shootingStars,
        ),
        size: Size.infinite,
      ),
    );
  }
}


class StarPainter extends CustomPainter {
  final List<Star> stars;
  final StarConfig starConfig;
  final List<Animation<double>>? animations;
  final List<ShootingStar> shootingStars;

  StarPainter({
    required this.stars,
    required this.starConfig,
    this.animations,
    required this.shootingStars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = starConfig.starColor;

    // Draw regular stars
    for (var i = 0; i < stars.length; i++) {
      final star = stars[i];
      final opacity = animations != null
          ? star.baseOpacity * animations![i].value
          : star.baseOpacity;

      paint.color = starConfig.starColor.withOpacity(opacity);
      canvas.drawCircle(
        Offset(star.x, star.y),
        star.size,
        paint,
      );
    }

    // Draw shooting stars
    if (shootingStars.isNotEmpty) {
      final shootingStarPaint = Paint()
        ..color = starConfig.starColor
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (var shootingStar in shootingStars) {
        final pos = shootingStar.getCurrentPosition();
        final trail = Path()
          ..moveTo(pos.dx, pos.dy)
          ..lineTo(
            pos.dx - cos(shootingStar.angle) * 20,
            pos.dy - sin(shootingStar.angle) * 20,
          );

        canvas.drawPath(trail, shootingStarPaint);
        shootingStar.currentDistance += shootingStar.speed * 0.016;
      }
    }
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => true;
}

