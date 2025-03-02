import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../custom_model/enums/enum.dart';

class InfiniteSpiralMotionAnimation extends StatefulWidget {
  final double size;
  final List<Color> colors;
  final Duration rotationDuration;
  final Duration motionDuration;
  final int numberOfRings;
  final double minScale;
  final double maxScale;
  final double startOpacity;
  final double endOpacity;
  final Curve motionCurve;
  final Curve rotationCurve;
  final bool reverseMotion;
  final bool reverseRotation;
  final double ringSpacing;
  final double depthEffect;
  // Animation direction control
  final AnimationDirection direction;
  // Enhanced forward/backward motion
  final double forwardSpeed;
  final double tunnelDepth;
  final double perspectiveEffect;
  // Enhanced visual effects
  final double glowIntensity;
  final double spiralIntensity;
  final double waveAmplitude;
  final Duration waveDuration;
  // Customization parameters
  final double rotationSpeed;
  final double pulseIntensity;
  final bool enableBlur;
  final double blurRadius;
  final bool enableColorShift;
  final double colorShiftSpeed;
  final bool enableDistortion;
  final double distortionIntensity;
  // New parameters
  final ColorBlendMode colorBlendMode;
  final double rainbowSpeed;
  final double bounceHeight;
  final double zigzagAmplitude;
  final double zigzagFrequency;
  final bool enableParticles;
  final int particleCount;
  final double particleSize;
  final double particleSpeed;
  final bool enable3DEffect;
  final double rotationX;
  final double rotationY;
  final bool enableShimmer;
  final double shimmerSpeed;
  final double shimmerWidth;
  final bool enableGradientBorder;
  final double borderWidth;
  final bool enableShadow;
  final double shadowIntensity;
  final bool enablePulsingBorder;
  final double pulsingBorderWidth;
  final Duration pulsingBorderDuration;

  const InfiniteSpiralMotionAnimation({
    Key? key,
    this.size = 300.0,
    this.colors = const [Colors.red, Color(0xFF8B0000)],
    this.rotationDuration = const Duration(seconds: 10),
    this.motionDuration = const Duration(seconds: 4),
    this.numberOfRings = 12,
    this.minScale = 0.5,
    this.maxScale = 1.0,
    this.startOpacity = 0.3,
    this.endOpacity = 1.0,
    this.motionCurve = Curves.easeInOut,
    this.rotationCurve = Curves.linear,
    this.reverseMotion = true,
    this.reverseRotation = false,
    this.ringSpacing = 1.0,
    this.depthEffect = 1.0,
    this.direction = AnimationDirection.all,
    this.forwardSpeed = 1.0,
    this.tunnelDepth = 3.0,
    this.perspectiveEffect = 0.5,
    this.glowIntensity = 0.5,
    this.spiralIntensity = 1.0,
    this.waveAmplitude = 10.0,
    this.waveDuration = const Duration(seconds: 2),
    this.rotationSpeed = 1.0,
    this.pulseIntensity = 0.1,
    this.enableBlur = false,
    this.blurRadius = 2.0,
    this.enableColorShift = false,
    this.colorShiftSpeed = 1.0,
    this.enableDistortion = false,
    this.distortionIntensity = 0.2,
    // New parameters
    this.colorBlendMode = ColorBlendMode.normal,
    this.rainbowSpeed = 1.0,
    this.bounceHeight = 20.0,
    this.zigzagAmplitude = 15.0,
    this.zigzagFrequency = 2.0,
    this.enableParticles = false,
    this.particleCount = 50,
    this.particleSize = 2.0,
    this.particleSpeed = 1.0,
    this.enable3DEffect = false,
    this.rotationX = 0.0,
    this.rotationY = 0.0,
    this.enableShimmer = false,
    this.shimmerSpeed = 1.0,
    this.shimmerWidth = 30.0,
    this.enableGradientBorder = false,
    this.borderWidth = 2.0,
    this.enableShadow = false,
    this.shadowIntensity = 0.3,
    this.enablePulsingBorder = false,
    this.pulsingBorderWidth = 2.0,
    this.pulsingBorderDuration = const Duration(seconds: 2),
  })  : assert(colors.length >= 1),
        assert(minScale < maxScale),
        assert(startOpacity >= 0 && startOpacity <= 1),
        assert(endOpacity >= 0 && endOpacity <= 1),
        super(key: key);

  @override
  State<InfiniteSpiralMotionAnimation> createState() =>
      _InfiniteSpiralMotionAnimationState();
}

class _InfiniteSpiralMotionAnimationState
    extends State<InfiniteSpiralMotionAnimation> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _motionController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _colorShiftController;
  late AnimationController _bounceController;
  late AnimationController _zigzagController;
  late AnimationController _shimmerController;
  late AnimationController _pulsingBorderController;
  late Animation<double> _motionAnimation;

  final math.Random _random = math.Random();
  List<Particle> _particles = [];

  bool get _enableForward =>
      widget.direction == AnimationDirection.forward ||
      widget.direction == AnimationDirection.all;
  bool get _enableSpiral =>
      widget.direction == AnimationDirection.spiral ||
      widget.direction == AnimationDirection.all;
  bool get _enableWave =>
      widget.direction == AnimationDirection.wave ||
      widget.direction == AnimationDirection.all;
  bool get _enablePulse =>
      widget.direction == AnimationDirection.pulse ||
      widget.direction == AnimationDirection.all;
  bool get _enableBounce =>
      widget.direction == AnimationDirection.bounce ||
      widget.direction == AnimationDirection.all;
  bool get _enableZigzag =>
      widget.direction == AnimationDirection.zigzag ||
      widget.direction == AnimationDirection.all;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: widget.rotationDuration ~/ widget.rotationSpeed.toInt(),
    )..repeat(reverse: widget.reverseRotation);

    _motionController = AnimationController(
      vsync: this,
      duration: widget.motionDuration,
    )..repeat(reverse: widget.reverseMotion);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );

    _colorShiftController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (5 / widget.colorShiftSpeed).round()),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _zigzagController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: (2 / widget.shimmerSpeed).round()),
    );

    _pulsingBorderController = AnimationController(
      vsync: this,
      duration: widget.pulsingBorderDuration,
    );

    if (_enablePulse) {
      _pulseController.repeat(reverse: true);
    }

    if (_enableWave) {
      _waveController.repeat();
    }

    if (widget.enableColorShift) {
      _colorShiftController.repeat();
    }

    if (_enableBounce) {
      _bounceController.repeat(reverse: true);
    }

    if (_enableZigzag) {
      _zigzagController.repeat();
    }

    if (widget.enableShimmer) {
      _shimmerController.repeat();
    }

    if (widget.enablePulsingBorder) {
      _pulsingBorderController.repeat(reverse: true);
    }

    _motionAnimation = CurvedAnimation(
      parent: _motionController,
      curve: widget.motionCurve,
    );

    if (widget.enableParticles) {
      _initializeParticles();
    }
  }

  void _initializeParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        position: Offset(
          _random.nextDouble() * widget.size,
          _random.nextDouble() * widget.size,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * widget.particleSpeed,
          (_random.nextDouble() - 0.5) * widget.particleSpeed,
        ),
        color: widget.colors[_random.nextInt(widget.colors.length)],
      );
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _motionController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _colorShiftController.dispose();
    _bounceController.dispose();
    _zigzagController.dispose();
    _shimmerController.dispose();
    _pulsingBorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.size,
        height: widget.size,
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _rotationController,
            _motionAnimation,
            if (_enablePulse) _pulseController,
            if (_enableWave) _waveController,
            if (widget.enableColorShift) _colorShiftController,
            if (_enableBounce) _bounceController,
            if (_enableZigzag) _zigzagController,
            if (widget.enableShimmer) _shimmerController,
            if (widget.enablePulsingBorder) _pulsingBorderController,
          ]),
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(widget.enable3DEffect ? widget.rotationX : 0.0)
                ..rotateY(widget.enable3DEffect ? widget.rotationY : 0.0),
              alignment: Alignment.center,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _EnhancedSpiralPainter(
                  rotationProgress: _rotationController.value,
                  motionProgress: _motionAnimation.value,
                  pulseProgress: _enablePulse ? _pulseController.value : 0,
                  waveProgress: _enableWave ? _waveController.value : 0,
                  colorShiftProgress:
                      widget.enableColorShift ? _colorShiftController.value : 0,
                  bounceProgress: _enableBounce ? _bounceController.value : 0,
                  zigzagProgress: _enableZigzag ? _zigzagController.value : 0,
                  shimmerProgress:
                      widget.enableShimmer ? _shimmerController.value : 0,
                  pulsingBorderProgress: widget.enablePulsingBorder
                      ? _pulsingBorderController.value
                      : 0,
                  colors: widget.colors,
                  numberOfRings: widget.numberOfRings,
                  minScale: widget.minScale,
                  maxScale: widget.maxScale,
                  startOpacity: widget.startOpacity,
                  endOpacity: widget.endOpacity,
                  ringSpacing: widget.ringSpacing,
                  depthEffect: widget.depthEffect,
                  enableForward: _enableForward,
                  forwardSpeed: widget.forwardSpeed,
                  tunnelDepth: widget.tunnelDepth,
                  perspectiveEffect: widget.perspectiveEffect,
                  glowIntensity: widget.glowIntensity,
                  enableSpiral: _enableSpiral,
                  spiralIntensity: widget.spiralIntensity,
                  enableWave: _enableWave,
                  waveAmplitude: widget.waveAmplitude,
                  pulseIntensity: widget.pulseIntensity,
                  enableBlur: widget.enableBlur,
                  blurRadius: widget.blurRadius,
                  enableDistortion: widget.enableDistortion,
                  distortionIntensity: widget.distortionIntensity,
                  colorBlendMode: widget.colorBlendMode,
                  rainbowSpeed: widget.rainbowSpeed,
                  bounceHeight: widget.bounceHeight,
                  zigzagAmplitude: widget.zigzagAmplitude,
                  zigzagFrequency: widget.zigzagFrequency,
                  enableParticles: widget.enableParticles,
                  particles: _particles,
                  particleSize: widget.particleSize,
                  enableGradientBorder: widget.enableGradientBorder,
                  borderWidth: widget.borderWidth,
                  enableShadow: widget.enableShadow,
                  shadowIntensity: widget.shadowIntensity,
                  enablePulsingBorder: widget.enablePulsingBorder,
                  pulsingBorderWidth: widget.pulsingBorderWidth,
                  shimmerWidth: widget.shimmerWidth,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
  });

  void update(Size size) {
    position += velocity;
    if (position.dx < 0 || position.dx > size.width)
      velocity = Offset(-velocity.dx, velocity.dy);
    if (position.dy < 0 || position.dy > size.height)
      velocity = Offset(velocity.dx, -velocity.dy);
  }
}

class _EnhancedSpiralPainter extends CustomPainter {
  final double rotationProgress;
  final double motionProgress;
  final double pulseProgress;
  final double waveProgress;
  final double colorShiftProgress;
  final double bounceProgress;
  final double zigzagProgress;
  final double shimmerProgress;
  final double pulsingBorderProgress;
  final List<Color> colors;
  final int numberOfRings;
  final double minScale;
  final double maxScale;
  final double startOpacity;
  final double endOpacity;
  final double ringSpacing;
  final double depthEffect;
  final bool enableForward;
  final double forwardSpeed;
  final double tunnelDepth;
  final double perspectiveEffect;
  final double glowIntensity;
  final bool enableSpiral;
  final double spiralIntensity;
  final bool enableWave;
  final double waveAmplitude;
  final double pulseIntensity;
  final bool enableBlur;
  final double blurRadius;
  final bool enableDistortion;
  final double distortionIntensity;
  final ColorBlendMode colorBlendMode;
  final double rainbowSpeed;
  final double bounceHeight;
  final double zigzagAmplitude;
  final double zigzagFrequency;
  final bool enableParticles;
  final List<Particle> particles;
  final double particleSize;
  final bool enableGradientBorder;
  final double borderWidth;
  final bool enableShadow;
  final double shadowIntensity;
  final bool enablePulsingBorder;
  final double pulsingBorderWidth;
  final double shimmerWidth;

  _EnhancedSpiralPainter({
    required this.rotationProgress,
    required this.motionProgress,
    required this.pulseProgress,
    required this.waveProgress,
    required this.colorShiftProgress,
    required this.bounceProgress,
    required this.zigzagProgress,
    required this.shimmerProgress,
    required this.pulsingBorderProgress,
    required this.colors,
    required this.numberOfRings,
    required this.minScale,
    required this.maxScale,
    required this.startOpacity,
    required this.endOpacity,
    required this.ringSpacing,
    required this.depthEffect,
    required this.enableForward,
    required this.forwardSpeed,
    required this.tunnelDepth,
    required this.perspectiveEffect,
    required this.glowIntensity,
    required this.enableSpiral,
    required this.spiralIntensity,
    required this.enableWave,
    required this.waveAmplitude,
    required this.pulseIntensity,
    required this.enableBlur,
    required this.blurRadius,
    required this.enableDistortion,
    required this.distortionIntensity,
    required this.colorBlendMode,
    required this.rainbowSpeed,
    required this.bounceHeight,
    required this.zigzagAmplitude,
    required this.zigzagFrequency,
    required this.enableParticles,
    required this.particles,
    required this.particleSize,
    required this.enableGradientBorder,
    required this.borderWidth,
    required this.enableShadow,
    required this.shadowIntensity,
    required this.enablePulsingBorder,
    required this.pulsingBorderWidth,
    required this.shimmerWidth,
  });

  Color _getRainbowColor(double progress) {
    final hue = (progress * 360 * rainbowSpeed) % 360;
    return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    // Draw shadow if enabled
    if (enableShadow) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(shadowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(center, maxRadius, shadowPaint);
    }

    for (int i = 0; i < numberOfRings; i++) {
      final progress = i / numberOfRings;
      double zProgress = progress;

      if (enableForward) {
        zProgress = (progress + rotationProgress * forwardSpeed) % 1.0;
      }

      // Calculate perspective and scale
      double perspectiveScale =
          enableForward ? 1 / (1 + (zProgress * tunnelDepth)) : 1.0;

      final motionScale = minScale + (maxScale - minScale) * motionProgress;
      final pulseScale = pulseProgress * pulseIntensity;
      double combinedScale = motionScale * (1 + pulseScale) * perspectiveScale;

      // Add bounce effect
      if (bounceProgress > 0) {
        final bounceOffset = math.sin(bounceProgress * math.pi) * bounceHeight;
        combinedScale *= (1 + bounceOffset / maxRadius);
      }

      // Calculate radius with various effects
      double radius = maxRadius * (1 - progress * ringSpacing) * combinedScale;

      // Add wave effect
      if (enableWave) {
        final wave =
            math.sin(progress * math.pi * 2 + waveProgress * math.pi * 2);
        radius += wave * waveAmplitude;
      }

      // Add zigzag effect
      if (zigzagProgress > 0) {
        final zigzag = math.sin(progress * math.pi * zigzagFrequency +
            zigzagProgress * math.pi * 2);
        radius += zigzag * zigzagAmplitude;
      }

      // Add distortion
      if (enableDistortion) {
        final distortion =
            math.sin(progress * math.pi * 4 + rotationProgress * math.pi * 2);
        radius += distortion * distortionIntensity * maxRadius;
      }

      // Calculate rotation with spiral effect
      double rotation = rotationProgress * 2 * math.pi;
      if (enableSpiral) {
        rotation += progress * math.pi * 2 * spiralIntensity;
      }

      // Calculate color based on blend mode
      final depthProgress = math.pow(1 - progress, depthEffect).toDouble();
      final opacity =
          startOpacity + (endOpacity - startOpacity) * depthProgress;

      Color ringColor;
      switch (colorBlendMode) {
        case ColorBlendMode.rainbow:
          ringColor = _getRainbowColor(progress + colorShiftProgress);
          break;
        case ColorBlendMode.pulse:
          final pulseColor = colors[i % colors.length];
          final pulseAmount = (math.sin(pulseProgress * math.pi * 2) + 1) / 2;
          ringColor =
              Color.lerp(pulseColor.withOpacity(0.5), pulseColor, pulseAmount)!;
          break;
        case ColorBlendMode.random:
          ringColor = colors[math.Random().nextInt(colors.length)];
          break;
        case ColorBlendMode.gradient:
          final colorIndex = i % colors.length;
          final nextColorIndex = (i + 1) % colors.length;
          ringColor =
              Color.lerp(colors[colorIndex], colors[nextColorIndex], progress)!;
          break;
        default:
          final colorIndex = i % colors.length;
          ringColor = colors[colorIndex];
      }

      // Apply shimmer effect
      if (shimmerProgress > 0) {
        final shimmerPosition = (shimmerProgress + progress) % 1.0;
        final shimmerDistance = (shimmerPosition - progress).abs();
        if (shimmerDistance < shimmerWidth / maxRadius) {
          final shimmerAmount =
              1 - (shimmerDistance / (shimmerWidth / maxRadius));
          ringColor = Color.lerp(ringColor, Colors.white, shimmerAmount * 0.5)!;
        }
      }

      final paint = Paint()
        ..color = ringColor.withOpacity(opacity * (0.5 + motionProgress * 0.5));

      if (enableBlur) {
        paint.maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          blurRadius * (1 - progress),
        );
      }

      if (glowIntensity > 0) {
        paint.maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          glowIntensity * 5 * (1 - progress),
        );
      }

      final path = Path();
      path.addOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2,
          height: radius * 2,
        ),
      );

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.translate(-center.dx, -center.dy);
      canvas.drawPath(path, paint);
      canvas.restore();

      // Draw gradient border
      if (enableGradientBorder && i == 0) {
        final borderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth
          ..shader = SweepGradient(
            colors: colors,
            // transform: GradientRotateTransform(rotation),
          ).createShader(Rect.fromCircle(center: center, radius: radius));
        canvas.drawCircle(center, radius, borderPaint);
      }

      // Draw pulsing border
      if (enablePulsingBorder && i == 0) {
        final borderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = pulsingBorderWidth * (1 + pulsingBorderProgress * 0.5)
          ..color = colors.first.withOpacity(1 - pulsingBorderProgress);
        canvas.drawCircle(center, radius, borderPaint);
      }
    }

    // Draw particles
    if (enableParticles) {
      final particlePaint = Paint()..style = PaintingStyle.fill;
      for (final particle in particles) {
        particle.update(size);
        particlePaint.color = particle.color;
        canvas.drawCircle(particle.position, particleSize, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EnhancedSpiralPainter oldDelegate) => true;
}
