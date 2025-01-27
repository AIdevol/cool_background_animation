import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackgroundSymbols extends StatefulWidget {
  final Color symbolColor;
  final double symbolSize;
  final String customSymbols;
  final Duration spawnInterval;
  final int initialSymbolCount;
  final double minAnimationDuration;
  final double maxAnimationDuration;
  final double opacity;
  final bool randomColors;
  final List<Color>? colorPalette;
  final double rotationSpeed;
  final Curve animationCurve;
  final double minSize;
  final double maxSize;
  final bool randomSizes;
  final bool enableGlow;
  final double glowRadius;
  final FontWeight fontWeight;
  final String fontFamily;

  const AnimatedBackgroundSymbols({
    Key? key,
    this.symbolColor = const Color(0xFF2ECC71),
    this.symbolSize = 24.0,
    this.customSymbols = '!@#\$%^&*()_+',
    this.spawnInterval = const Duration(milliseconds: 200),
    this.initialSymbolCount = 20,
    this.minAnimationDuration = 5.0,
    this.maxAnimationDuration = 10.0,
    this.opacity = 0.7,
    this.randomColors = false,
    this.colorPalette,
    this.rotationSpeed = 1.0,
    this.animationCurve = Curves.linear,
    this.minSize = 16.0,
    this.maxSize = 32.0,
    this.randomSizes = false,
    this.enableGlow = false,
    this.glowRadius = 5.0,
    this.fontWeight = FontWeight.normal,
    required this.fontFamily,
  }) : super(key: key);

  @override
  State<AnimatedBackgroundSymbols> createState() => _AnimatedBackgroundSymbolsState();
}

class _AnimatedBackgroundSymbolsState extends State<AnimatedBackgroundSymbols> {
  final List<SymbolData> symbols = [];
  final Random random = Random();
  Timer? symbolTimer;
  double? screenWidth;
  double? screenHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          screenWidth = MediaQuery.of(context).size.width;
          screenHeight = MediaQuery.of(context).size.height;
          for (int i = 0; i < widget.initialSymbolCount; i++) {
            _addSymbol();
          }
        });

        symbolTimer = Timer.periodic(widget.spawnInterval, (timer) {
          if (mounted) {
            setState(() {
              _addSymbol();
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    symbolTimer?.cancel();
    super.dispose();
  }

  Color _getRandomColor() {
    if (widget.colorPalette != null && widget.colorPalette!.isNotEmpty) {
      return widget.colorPalette![random.nextInt(widget.colorPalette!.length)];
    }
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  double _getRandomSize() {
    if (widget.randomSizes) {
      return widget.minSize + random.nextDouble() * (widget.maxSize - widget.minSize);
    }
    return widget.symbolSize;
  }

  void _addSymbol() {
    if (screenWidth == null || screenHeight == null) return;

    final symbol = widget.customSymbols[random.nextInt(widget.customSymbols.length)];
    final xPosition = random.nextDouble() * screenWidth!;
    final duration = (widget.minAnimationDuration * 1000 +
        random.nextDouble() * (widget.maxAnimationDuration - widget.minAnimationDuration) * 1000)
        .toInt();

    final newSymbol = SymbolData(
      symbol: symbol,
      x: xPosition,
      duration: duration,
      color: widget.randomColors ? _getRandomColor() : widget.symbolColor,
      size: _getRandomSize(),
      key: UniqueKey(),
    );

    symbols.add(newSymbol);

    Future.delayed(Duration(milliseconds: duration), () {
      if (mounted) {
        setState(() {
          symbols.remove(newSymbol);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        screenWidth = constraints.maxWidth;
        screenHeight = constraints.maxHeight;

        return Stack(
          children: symbols.map((symbolData) {
            return AnimatedSymbol(
              data: symbolData,
              rotationSpeed: widget.rotationSpeed,
              animationCurve: widget.animationCurve,
              opacity: widget.opacity,
              enableGlow: widget.enableGlow,
              glowRadius: widget.glowRadius,
              fontWeight: widget.fontWeight,
              fontFamily: widget.fontFamily,
              screenHeight: screenHeight!,
            );
          }).toList(),
        );
      },
    );
  }
}

class SymbolData {
  final String symbol;
  final double x;
  final int duration;
  final Color color;
  final double size;
  final Key key;

  SymbolData({
    required this.symbol,
    required this.x,
    required this.duration,
    required this.color,
    required this.size,
    required this.key,
  });
}

class AnimatedSymbol extends StatefulWidget {
  final SymbolData data;
  final double rotationSpeed;
  final Curve animationCurve;
  final double opacity;
  final bool enableGlow;
  final double glowRadius;
  final FontWeight fontWeight;
  final String? fontFamily;
  final double screenHeight;

  const AnimatedSymbol({
    Key? key,
    required this.data,
    required this.rotationSpeed,
    required this.animationCurve,
    required this.opacity,
    required this.enableGlow,
    required this.glowRadius,
    required this.fontWeight,
    required this.screenHeight,
    this.fontFamily,
  }) : super(key: key);

  @override
  State<AnimatedSymbol> createState() => _AnimatedSymbolState();
}

class _AnimatedSymbolState extends State<AnimatedSymbol>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.data.duration),
      vsync: this,
    );

    _positionAnimation = Tween<double>(
      begin: widget.screenHeight,
      end: -100.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi * widget.rotationSpeed,
    ).animate(_controller);

    _opacityAnimation = Tween<double>(
      begin: widget.opacity,
      end: 0.0,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget symbolWidget = Text(
      widget.data.symbol,
      style: TextStyle(
        color: widget.data.color,
        fontSize: widget.data.size,
        fontWeight: widget.fontWeight,
        fontFamily: widget.fontFamily,
      ),
    );

    if (widget.enableGlow) {
      symbolWidget = Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.data.color.withOpacity(0.5),
              blurRadius: widget.glowRadius,
              spreadRadius: widget.glowRadius / 2,
            ),
          ],
        ),
        child: symbolWidget,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.data.x,
          top: _positionAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: symbolWidget,
            ),
          ),
        );
      },
    );
  }
}
