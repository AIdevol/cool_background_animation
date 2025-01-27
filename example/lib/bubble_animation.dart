import 'package:flutter/material.dart';
import 'dart:math' as math;

enum BalloonShape {
  oval,
  round,
  heart,
  star
}

class MultipleBalloons extends StatefulWidget {
  final int balloonCount;
  final List<Color>? colors;
  final double minSize;
  final double maxSize;
  final double minSpeed;
  final double maxSpeed;
  final double maxStartDelay;
  final double minSwayAmount;
  final double maxSwayAmount;
  final Duration animationDuration;
  final bool enableRespawn;
  final bool showStrings;
  final double stringLength;
  final Color stringColor;
  final double stringWidth;
  final BoxConstraints? areaConstraints;
  final Curve swayingCurve;
  final BalloonShape balloonShape;
  final double? opacity;

  const MultipleBalloons({
    Key? key,
    this.balloonCount = 20,
    this.colors,
    this.minSize = 40,
    this.maxSize = 70,
    this.minSpeed = 0.5,
    this.maxSpeed = 2.0,
    this.maxStartDelay = 2.0,
    this.minSwayAmount = 20,
    this.maxSwayAmount = 100,
    this.animationDuration = const Duration(seconds: 5),
    this.enableRespawn = true,
    this.showStrings = true,
    this.stringLength = 1.6,
    this.stringColor = Colors.grey,
    this.stringWidth = 1.0,
    this.areaConstraints,
    this.swayingCurve = Curves.easeInOut,
    this.balloonShape = BalloonShape.oval,
    this.opacity,
  }) : super(key: key);

  @override
  State<MultipleBalloons> createState() => _MultipleBalloonsState();
}

class BalloonConfig {
  final Color color;
  final double size;
  final double speed;
  double startDelay;
  final double startX;
  final double swayAmount;

  BalloonConfig({
    required this.color,
    required this.size,
    required this.speed,
    required this.startDelay,
    required this.startX,
    required this.swayAmount,
  });
}

class _MultipleBalloonsState extends State<MultipleBalloons> {
  final List<BalloonConfig> balloons = [];
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeBalloons();
  }

  void _initializeBalloons() {
    final defaultColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];

    final activeColors = widget.colors ?? defaultColors;
    balloons.clear();

    for (int i = 0; i < widget.balloonCount; i++) {
      balloons.add(
        BalloonConfig(
          color: activeColors[random.nextInt(activeColors.length)],
          size: random.nextDouble() * (widget.maxSize - widget.minSize) + widget.minSize,
          speed: random.nextDouble() * (widget.maxSpeed - widget.minSpeed) + widget.minSpeed,
          startDelay: random.nextDouble() * widget.maxStartDelay,
          startX: random.nextDouble() * (widget.areaConstraints?.maxWidth ?? 300),
          swayAmount: random.nextDouble() * (widget.maxSwayAmount - widget.minSwayAmount) + widget.minSwayAmount,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(MultipleBalloons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.balloonCount != oldWidget.balloonCount) {
      _initializeBalloons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveConstraints = widget.areaConstraints ?? constraints;
        return SizedBox(
          width: effectiveConstraints.maxWidth,
          height: effectiveConstraints.maxHeight,
          child: Stack(
            children: balloons.map((config) {
              return FallingBalloon(
                color: config.color,
                size: config.size,
                speed: config.speed,
                startDelay: config.startDelay,
                startX: config.startX,
                swayAmount: config.swayAmount,
                animationDuration: widget.animationDuration,
                showString: widget.showStrings,
                stringLength: widget.stringLength,
                stringColor: widget.stringColor,
                stringWidth: widget.stringWidth,
                swayingCurve: widget.swayingCurve,
                balloonShape: widget.balloonShape,
                opacity: widget.opacity,
                constraints: effectiveConstraints,
                onComplete: widget.enableRespawn ? () {
                  setState(() {
                    config.startDelay = 0;
                  });
                } : null,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class FallingBalloon extends StatefulWidget {
  final Color color;
  final double size;
  final double speed;
  final double startDelay;
  final double startX;
  final double swayAmount;
  final Duration animationDuration;
  final bool showString;
  final double stringLength;
  final Color stringColor;
  final double stringWidth;
  final Curve swayingCurve;
  final BalloonShape balloonShape;
  final double? opacity;
  final BoxConstraints constraints;
  final VoidCallback? onComplete;

  const FallingBalloon({
    Key? key,
    required this.color,
    required this.size,
    required this.speed,
    required this.startDelay,
    required this.startX,
    required this.swayAmount,
    required this.animationDuration,
    required this.showString,
    required this.stringLength,
    required this.stringColor,
    required this.stringWidth,
    required this.swayingCurve,
    required this.balloonShape,
    required this.constraints,
    this.opacity,
    this.onComplete,
  }) : super(key: key);

  @override
  State<FallingBalloon> createState() => _FallingBalloonState();
}

class _FallingBalloonState extends State<FallingBalloon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _positionY;
  Animation<double>? _positionX;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (widget.animationDuration.inMilliseconds / widget.speed).round()),
      vsync: this,
    );

    Future.delayed(Duration(milliseconds: (widget.startDelay * 1000).round()), () {
      if (mounted) {
        _initializeAnimations();
      }
    });
  }

  void _initializeAnimations() {
    _positionY = Tween<double>(
      begin: -widget.size,
      end: widget.constraints.maxHeight,
    ).animate(_controller);

    _positionX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.startX,
          end: widget.startX + widget.swayAmount,
        ).chain(CurveTween(curve: widget.swayingCurve)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.startX + widget.swayAmount,
          end: widget.startX - widget.swayAmount,
        ).chain(CurveTween(curve: widget.swayingCurve)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: widget.startX - widget.swayAmount,
          end: widget.startX,
        ).chain(CurveTween(curve: widget.swayingCurve)),
        weight: 1.0,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
        _controller.reset();
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_positionX == null || _positionY == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionX!.value,
          top: _positionY!.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size * 1.2),
            painter: BalloonPainter(
              color: widget.color,
              withString: widget.showString,
              stringLength: widget.stringLength,
              stringColor: widget.stringColor,
              stringWidth: widget.stringWidth,
              shape: widget.balloonShape,
              opacity: widget.opacity,
            ),
          ),
        );
      },
    );
  }
}

class BalloonPainter extends CustomPainter {
  final Color color;
  final bool withString;
  final double stringLength;
  final Color stringColor;
  final double stringWidth;
  final BalloonShape shape;
  final double? opacity;

  BalloonPainter({
    required this.color,
    required this.withString,
    required this.stringLength,
    required this.stringColor,
    required this.stringWidth,
    required this.shape,
    this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint balloonPaint = Paint()
      ..color = opacity != null ? color.withOpacity(opacity!) : color
      ..style = PaintingStyle.fill;

    final Paint stringPaint = Paint()
      ..color = stringColor
      ..strokeWidth = stringWidth
      ..style = PaintingStyle.stroke;

    final balloonPath = Path();

    switch (shape) {
    case BalloonShape.oval:
    balloonPath.addOval(Rect.fromLTWH(0, 0, size.width, size.width * 1.2));
    break;
    case BalloonShape.round:
    balloonPath.addOval(Rect.fromLTWH(0, 0, size.width, size.width));
    break;
    case BalloonShape.heart:
    _drawHeart(balloonPath, size);
    break;
    case BalloonShape.star:
    _drawStar(balloonPath, size);
    break;
    }

    canvas.drawPath(balloonPath, balloonPaint);

    if (withString) {
      final stringPath = Path()
        ..moveTo(size.width / 2, size.width * 1.2)
        ..lineTo(size.width / 2, size.width * stringLength);
      canvas.drawPath(stringPath, stringPaint);
    }
  }

  void _drawHeart(Path path, Size size) {
    final double width = size.width;
    final double height = size.width * 1.2;

    path.moveTo(width / 2, height * 0.3);
    path.cubicTo(
      width * 0.2, height * 0.1,
      -width * 0.25, height * 0.5,
      width / 2, height * 0.8,
    );
    path.cubicTo(
      width * 1.25, height * 0.5,
      width * 0.8, height * 0.1,
      width / 2, height * 0.3,
    );
  }

  void _drawStar(Path path, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.width / 2;
    final double radius = size.width / 2;

    for (int i = 0; i < 5; i++) {
      double angle = -math.pi / 2 + 2 * math.pi * i / 5;
      if (i == 0) {
        path.moveTo(
          centerX + radius * math.cos(angle),
          centerY + radius * math.sin(angle),
        );
      } else {
        path.lineTo(
          centerX + radius * math.cos(angle),
          centerY + radius * math.sin(angle),
        );
      }
      angle += math.pi / 5;
      path.lineTo(
        centerX + radius * 0.4 * math.cos(angle),
        centerY + radius * 0.4 * math.sin(angle),
      );
    }
    path.close();
  }

  @override
  bool shouldRepaint(BalloonPainter oldDelegate) =>
      color != oldDelegate.color ||
          withString != oldDelegate.withString ||
          stringLength != oldDelegate.stringLength ||
          stringColor != oldDelegate.stringColor ||
          stringWidth != oldDelegate.stringWidth ||
          shape != oldDelegate.shape ||
          opacity != oldDelegate.opacity;
}