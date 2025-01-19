import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../custom_model/star_model.dart';

class StarFallingBackground extends StatefulWidget {
  final int numberOfStars;
  final Color starColor;
  final double minStarSize;
  final double maxStarSize;
  final Duration animationDuration;
  final Color backgroundColor;

  const StarFallingBackground({
    Key? key,
    this.numberOfStars = 50,
    this.starColor = Colors.white,
    this.minStarSize = 2.0,
    this.maxStarSize = 4.0,
    this.animationDuration = const Duration(seconds: 10),
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  @override
  State<StarFallingBackground> createState() => _StarFallingBackgroundState();
}

class _StarFallingBackgroundState extends State<StarFallingBackground>
    with TickerProviderStateMixin {
  late List<StarData> stars;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeStars();
  }

  void _initializeStars() {
    stars = List.generate(
      widget.numberOfStars,
      (index) => StarData(
        controller: AnimationController(
          vsync: this,
          duration: Duration(
            milliseconds: widget.animationDuration.inMilliseconds +
                random.nextInt(5000), // Add some randomness to duration
          ),
        ),
        size: widget.minStarSize +
            random.nextDouble() * (widget.maxStarSize - widget.minStarSize),
        initialPosition: Offset(
          random.nextDouble() * 400,
          random.nextDouble() * -100,
        ),
      ),
    );

    // Start the animations
    for (var star in stars) {
      star.controller.repeat();
    }
  }

  @override
  void dispose() {
    for (var star in stars) {
      star.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Stack(
        children: stars.map((star) {
          return AnimatedBuilder(
            animation: star.controller,
            builder: (context, child) {
              return Positioned(
                left: star.initialPosition.dx,
                top: star.initialPosition.dy +
                    MediaQuery.of(context).size.height * star.controller.value,
                child: Opacity(
                  opacity: _calculateStarOpacity(star.controller.value),
                  child: _buildStar(star.size),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.starColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.starColor.withOpacity(0.5),
            blurRadius: size,
            spreadRadius: size / 2,
          ),
        ],
      ),
    );
  }

  double _calculateStarOpacity(double animationValue) {
    // Fade out as the star falls
    if (animationValue < 0.2) {
      return animationValue * 5;
    } else if (animationValue > 0.8) {
      return (1 - animationValue) * 5;
    }
    return 1.0;
  }
}
