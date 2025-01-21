import 'dart:math';
import 'package:flutter/material.dart';

class BubbleBackground extends StatefulWidget {
  final int numberOfBubbles;
  final List<Color> bubbleColors;
  final BubbleConfig config;
  final Widget? child;
  final BoxDecoration? backgroundDecoration;

  const BubbleBackground({
    Key? key,
    this.numberOfBubbles = 20,
    this.bubbleColors = const [Colors.blue],
    this.config = const BubbleConfig(),
    this.child,
    this.backgroundDecoration,
  }) : super(key: key);

  @override
  State<BubbleBackground> createState() => _BubbleBackgroundState();
}

class _BubbleBackgroundState extends State<BubbleBackground>
    with SingleTickerProviderStateMixin {
  List<Bubble> bubbles = [];
  late AnimationController _controller;
  Size? _size;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.enablePulsing
          ? widget.config.pulsingDuration
          : const Duration(seconds: 1),
    )..repeat();

    _controller.addListener(_updateBubbles);
  }

  void _initializeBubblesIfNeeded(Size size) {
    if (_size != size || bubbles.isEmpty) {
      _size = size;
      _initializeBubbles(size);
    }
  }

  void _initializeBubbles(Size size) {
    bubbles = List.generate(
      widget.numberOfBubbles,
          (_) => Bubble.random(size.width, size.height, widget.config, widget.bubbleColors),
    );
  }

  void _updateBubbles() {
    if (_size == null) return;

    setState(() {
      _time += 0.016; // Approximate for 60 FPS

      for (var bubble in bubbles) {
        bubble.move(widget.config, _time);
      }

      bubbles.removeWhere((bubble) => bubble.isOffScreen());

      while (bubbles.length < widget.numberOfBubbles) {
        bubbles.add(Bubble.random(_size!.width, _size!.height, widget.config, widget.bubbleColors));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initializeBubblesIfNeeded(size);

        return Container(
          decoration: widget.backgroundDecoration,
          child: Stack(
            children: [
              CustomPaint(
                size: size,
                painter: BubblePainter(
                  bubbles: bubbles,
                  config: widget.config,
                  animationValue: _controller.value,
                ),
              ),
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final BubbleConfig config;
  final double animationValue;

  BubblePainter({
    required this.bubbles,
    required this.config,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      double currentRadius = bubble.radius;

      if (config.enablePulsing) {
        double pulseScale = 1.0 + (sin(animationValue * 2 * pi) * 0.2);
        currentRadius *= pulseScale;
      }

      if (config.enableGradient) {
        final gradient = RadialGradient(
          colors: config.gradientColors,
          stops: const [0.0, 1.0],
        );

        final paint = Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(
              center: Offset(bubble.x, bubble.y),
              radius: currentRadius,
            ),
          )
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(bubble.x, bubble.y),
          currentRadius,
          paint,
        );
      } else {
        final paint = Paint()
          ..color = bubble.color.withOpacity(bubble.opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(bubble.x, bubble.y),
          currentRadius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => true;
}


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
