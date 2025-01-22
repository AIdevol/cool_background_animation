import 'dart:math' as math;
import 'dart:ui'as ui;
import 'package:flutter/material.dart';
import '../../custom_model/celebrations_model_animation.dart';
import '../../custom_model/enums/enum.dart';

class CelebrationAnimation extends StatefulWidget {
  final Widget? child;
  final int particleCount;
  final Duration duration;
  final bool loop;
  final List<Color>? colors;
  final double minSize;
  final double maxSize;
  final ParticleType particleType;
  final Widget Function(Color color, double size)? particleBuilder;
  final AnimationType animationType;
  final Curve curve;
  final double spread;
  final double gravity;
  final double initialVelocity;
  final bool fadeOut;
  final VoidCallback? onAnimationComplete;
  final BackgroundType backgroundType;
  final Color? backgroundColor;
  final List<Color>? backgroundGradientColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final Duration? backgroundAnimationDuration;
  final bool rotateParticles;
  final double rotationSpeed;
  final bool blurParticles;
  final double blurRadius;
  final bool enableGlow;
  final Color? glowColor;
  final double glowIntensity;
  final bool enableTrails;
  final int trailLength;
  final bool enablePhysics;
  final double airResistance;
  final double turbulence;

  const CelebrationAnimation({
    super.key,
    this.child,
    this.particleCount = 50,
    this.duration = const Duration(seconds: 2),
    this.loop = true,
    this.colors,
    this.minSize = 5,
    this.maxSize = 15,
    this.particleType = ParticleType.circle,
    this.particleBuilder,
    this.animationType = AnimationType.explosion,
    this.curve = Curves.easeOut,
    this.spread = 1.0,
    this.gravity = 9.8,
    this.initialVelocity = 100,
    this.fadeOut = true,
    this.onAnimationComplete,
    this.backgroundType = BackgroundType.solid,
    this.backgroundColor = Colors.transparent,
    this.backgroundGradientColors,
    this.gradientBegin = Alignment.topCenter,
    this.gradientEnd = Alignment.bottomCenter,
    this.backgroundAnimationDuration = const Duration(seconds: 3),
    this.rotateParticles = false,
    this.rotationSpeed = 2.0,
    this.blurParticles = false,
    this.blurRadius = 2.0,
    this.enableGlow = false,
    this.glowColor,
    this.glowIntensity = 0.5,
    this.enableTrails = false,
    this.trailLength = 5,
    this.enablePhysics = false,
    this.airResistance = 0.02,
    this.turbulence = 0.1,
  });

  @override
  State<CelebrationAnimation> createState() => _CelebrationAnimationState();
}

class _CelebrationAnimationState extends State<CelebrationAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _backgroundController;
  late final List<Particle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _backgroundController = AnimationController(
      vsync: this,
      duration: widget.backgroundAnimationDuration!,
    );

    if (widget.loop) {
      _controller.repeat();
      if (widget.backgroundType == BackgroundType.animated) {
        _backgroundController.repeat(reverse: true);
      }
    } else {
      _controller.forward().then((_) => widget.onAnimationComplete?.call());
    }

    _particles = List.generate(
      widget.particleCount,
          (index) => _createParticle(index),
    );
  }


  Particle _createParticle(int index) {
    final angle = widget.animationType == AnimationType.firework
        ? _random.nextDouble() * 2 * math.pi
        : 2 * math.pi * index / widget.particleCount;

    return Particle(
      color: _getRandomColor(),
      size: _random.nextDouble() * (widget.maxSize - widget.minSize) + widget.minSize,
      angle: angle,
      velocity: widget.initialVelocity * (0.8 + _random.nextDouble() * 0.4),
      rotationAngle: _random.nextDouble() * 2 * math.pi,
      lifetime: 0.8 + _random.nextDouble() * 0.4,
      startTime: widget.animationType == AnimationType.rain
          ? _random.nextDouble()
          : 0.0,
    );
  }

  Color _getRandomColor() {
    final colors = widget.colors ?? [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  Widget _buildBackground() {
    switch (widget.backgroundType) {
      case BackgroundType.solid:
        return Container(color: widget.backgroundColor);

      case BackgroundType.gradient:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.gradientBegin,
              end: widget.gradientEnd,
              colors: widget.backgroundGradientColors ??
                  [Colors.blue.withOpacity(0.3), Colors.purple.withOpacity(0.3)],
            ),
          ),
        );

      case BackgroundType.animated:
        return AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: widget.gradientBegin,
                  end: widget.gradientEnd,
                  colors: List.generate(
                    widget.backgroundGradientColors?.length ?? 2,
                        (index) {
                      final colors = widget.backgroundGradientColors ??
                          [Colors.blue.withOpacity(0.3), Colors.purple.withOpacity(0.3)];
                      final nextIndex = (index + 1) % colors.length;
                      return Color.lerp(
                        colors[index],
                        colors[nextIndex],
                        _backgroundController.value,
                      )!;
                    },
                  ),
                ),
              ),
            );
          },
        );
    }
  }

  Widget _buildParticle(Particle particle, [double scale = 1.0]) {
    final size = particle.size * scale;

    switch (widget.particleType) {
      case ParticleType.circle:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: particle.color,
            shape: BoxShape.circle,
          ),
        );

      case ParticleType.square:
        return Container(
          width: size,
          height: size,
          color: particle.color,
        );

      case ParticleType.star:
        return CustomPaint(
          size: Size(size, size),
          painter: StarPainter(
            color: particle.color,
            rotation: widget.rotateParticles ? particle.rotationAngle : 0,
          ),
        );

      case ParticleType.heart:
        return CustomPaint(
          size: Size(size, size),
          painter: HeartPainter(
            color: particle.color,
            rotation: widget.rotateParticles ? particle.rotationAngle : 0,
          ),
        );

      case ParticleType.custom:
        return widget.particleBuilder?.call(particle.color, size) ??
            Container(width: size, height: size);
    }
  }

  Offset _getParticlePosition(Particle particle, double progress) {
    if (widget.enablePhysics) {
      return _getPhysicsBasedPosition(particle, progress);
    }

    switch (widget.animationType) {
      case AnimationType.explosion:
        final radius = widget.spread * particle.velocity * progress;
        final dx = radius * math.cos(particle.angle);
        final dy = radius * math.sin(particle.angle) +
            (0.5 * widget.gravity * progress * progress);
        return Offset(dx, dy);

      case AnimationType.fountain:
        final t = progress * widget.duration.inMilliseconds / 1000;
        final dx = particle.velocity * math.cos(particle.angle) * t * widget.spread;
        final dy = particle.velocity * math.sin(particle.angle) * t -
            0.5 * widget.gravity * t * t;
        return Offset(dx, dy);

      case AnimationType.spiral:
        final angle = particle.angle + (progress * 4 * math.pi);
        final radius = widget.spread * particle.velocity * progress;
        return Offset(
          radius * math.cos(angle),
          radius * math.sin(angle),
        );

      case AnimationType.rain:
        final adjustedProgress = (progress + particle.startTime) % 1.0;
        return Offset(
          particle.velocity * math.cos(particle.angle) * adjustedProgress * widget.spread,
          particle.velocity * adjustedProgress * 2,
        );

      case AnimationType.wave:
        final angle = particle.angle + (progress * 2 * math.pi);
        return Offset(
          widget.spread * progress * 100,
          math.sin(angle) * 50,
        );

      case AnimationType.firework:
        if (progress < 0.3) {
          return Offset(0, -widget.spread * progress * 200);
        } else {
          final explosionProgress = (progress - 0.3) / 0.7;
          final radius = widget.spread * particle.velocity * explosionProgress;
          return Offset(
            radius * math.cos(particle.angle),
            -widget.spread * 60 + radius * math.sin(particle.angle),
          );
        }

      case AnimationType.custom:
        return Offset.zero;
    }
  }

  Offset _getPhysicsBasedPosition(Particle particle, double progress) {
    final t = progress * widget.duration.inMilliseconds / 1000;
    final velocity = particle.velocity;

    // Apply air resistance
    final vx = velocity * math.cos(particle.angle) * math.exp(-widget.airResistance * t);
    final vy = velocity * math.sin(particle.angle) * math.exp(-widget.airResistance * t) +
        widget.gravity * t;

    // Add turbulence
    final turbX = math.sin(t * 10 + particle.startTime * 20) * widget.turbulence * 50;
    final turbY = math.cos(t * 15 + particle.startTime * 20) * widget.turbulence * 50;

    final x = vx * t * widget.spread + turbX;
    final y = (vy * t - 0.5 * widget.gravity * t * t) * widget.spread + turbY;

    return Offset(x, y);
  }

  Widget _buildParticleWithEffects(Widget particle, double progress) {
    Widget result = particle;

    if (widget.rotateParticles) {
      result = Transform.rotate(
        angle: progress * widget.rotationSpeed * 2 * math.pi,
        child: result,
      );
    }if (widget.blurParticles) {
      result = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: widget.blurRadius * (1 - progress),
          sigmaY: widget.blurRadius * (1 - progress),
        ),
        child: result,
      );
    }

    if (widget.enableGlow) {
      result = Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (widget.glowColor ?? Colors.white)
                  .withOpacity(widget.glowIntensity * (1 - progress)),
              blurRadius: 10 * (1 - progress),
              spreadRadius: 2 * (1 - progress),
            ),
          ],
        ),
        child: result,
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildBackground(),
        widget.child!,
        if (widget.enableTrails)
          ...List.generate(
            widget.particleCount * widget.trailLength,
                (index) {
              final particleIndex = index ~/ widget.trailLength;
              final trailIndex = index % widget.trailLength;
              return _buildParticleTrail(particleIndex, trailIndex);
            },
          )
        else
          ...List.generate(
            widget.particleCount,
                (index) => _buildParticleWidget(index),
          ),
      ],
    );
  }

  Widget _buildParticleTrail(int particleIndex, int trailIndex) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: widget.curve),
      builder: (context, child) {
        final progress = _controller.value;
        final particle = _particles[particleIndex];

        final trailProgress = (progress - (trailIndex * 0.1)).clamp(0.0, 1.0);
        if (trailProgress <= 0) return const SizedBox();

        final position = _getParticlePosition(particle, trailProgress);
        final scale = 1.0 - (trailIndex / widget.trailLength) * 0.5;
        final opacity = (1 - (trailIndex / widget.trailLength)) *
            (widget.fadeOut ? (1 - trailProgress) : 1.0);

        return Positioned(
          left: MediaQuery.of(context).size.width / 2 + position.dx,
          top: MediaQuery.of(context).size.height / 2 + position.dy,
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(-particle.size / 2, -particle.size / 2),
              child: _buildParticleWithEffects(
                _buildParticle(particle, scale),
                trailProgress,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticleWidget(int index) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: widget.curve),
      builder: (context, child) {
        final progress = _controller.value;
        final particle = _particles[index];
        final position = _getParticlePosition(particle, progress);

        return Positioned(
          left: MediaQuery.of(context).size.width / 2 + position.dx,
          top: MediaQuery.of(context).size.height / 2 + position.dy,
          child: Transform.translate(
            offset: Offset(-particle.size / 2, -particle.size / 2),
            child: widget.fadeOut
                ? Opacity(
              opacity: 1 - progress,
              child: _buildParticleWithEffects(
                _buildParticle(particle),
                progress,
              ),
            )
                : _buildParticleWithEffects(_buildParticle(particle), progress),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundController.dispose();
    super.dispose();
  }
}

