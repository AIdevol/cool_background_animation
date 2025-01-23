import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MatrixRainAnimation extends StatefulWidget {
  /// Color of the falling characters
  final Color textColor;

  /// Size of the characters
  final double fontSize;

  /// Base animation speed multiplier
  final double speed;

  /// Number of character columns per 100 logical pixels of width
  final double densityFactor;

  /// Whether each column should have a random speed variation
  final bool randomizeSpeed;

  /// Custom character set to use (defaults to katakana)
  final String? customCharacters;

  /// Number of characters in each column
  final int charactersPerColumn;

  /// Fade effect for trailing characters (0.0 to 1.0)
  final double fadeRatio;

  /// Background color (transparent by default)
  final Color backgroundColor;

  /// Animation update interval in milliseconds
  final int updateInterval;

  /// Whether to start the animation immediately
  final bool autoStart;

  /// Callback when animation starts
  final VoidCallback? onStart;

  /// Callback when animation stops
  final VoidCallback? onStop;

  const MatrixRainAnimation({
    Key? key,
    this.textColor = const Color(0xFF00FF00),
    this.fontSize = 14,
    this.speed = 1.0,
    this.densityFactor = 5.0,
    this.randomizeSpeed = true,
    this.customCharacters,
    this.charactersPerColumn = 20,
    this.fadeRatio = 0.1,
    this.backgroundColor = Colors.transparent,
    this.updateInterval = 50,
    this.autoStart = true,
    this.onStart,
    this.onStop,
  }) : super(key: key);

  @override
  State<MatrixRainAnimation> createState() => _MatrixRainAnimationState();
}

class _MatrixRainAnimationState extends State<MatrixRainAnimation> {
  late List<MatrixColumn> columns;
  Timer? timer;
  final Random random = Random();
  bool isRunning = false;

  static const defaultCharacters = 'ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ';

  @override
  void initState() {
    super.initState();
    columns = [];
    if (widget.autoStart) {
      Future.microtask(() => startAnimation());
    }
  }

  void initializeColumns() {
    final width = MediaQuery.of(context).size.width;
    final numberOfColumns = (width * widget.densityFactor / 100).floor();

    columns = List.generate(numberOfColumns, (index) {
      final xPosition = random.nextDouble() * width;
      return MatrixColumn(
        x: xPosition,
        speed: widget.speed * (widget.randomizeSpeed ? random.nextDouble() + 0.5 : 1),
        characters: generateRandomCharacters(),
        y: random.nextDouble() * -500,
      );
    });
  }

  List<String> generateRandomCharacters() {
    final characters = widget.customCharacters ?? defaultCharacters;
    return List.generate(
      widget.charactersPerColumn,
          (_) => characters[random.nextInt(characters.length)],
    );
  }

  void startAnimation() {
    if (isRunning) return;

    initializeColumns();
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: widget.updateInterval), (timer) {
      if (!mounted) return;

      setState(() {
        final height = MediaQuery.of(context).size.height;
        for (var column in columns) {
          column.y += column.speed;
          if (column.y > height) {
            column.y = random.nextDouble() * -500;
            column.characters = generateRandomCharacters();
          }
        }
      });
    });

    setState(() => isRunning = true);
    widget.onStart?.call();
  }

  void stopAnimation() {
    timer?.cancel();
    setState(() => isRunning = false);
    widget.onStop?.call();
  }

  void toggleAnimation() {
    if (isRunning) {
      stopAnimation();
    } else {
      startAnimation();
    }
  }

  @override
  void dispose() {
    stopAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: CustomPaint(
        painter: MatrixRainPainter(
          columns: columns,
          textColor: widget.textColor,
          fontSize: widget.fontSize,
          fadeRatio: widget.fadeRatio,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class MatrixColumn {
  double x;
  double y;
  double speed;
  List<String> characters;

  MatrixColumn({
    required this.x,
    required this.y,
    required this.speed,
    required this.characters,
  });
}

class MatrixRainPainter extends CustomPainter {
  final List<MatrixColumn> columns;
  final Color textColor;
  final double fontSize;
  final double fadeRatio;

  MatrixRainPainter({
    required this.columns,
    required this.textColor,
    required this.fontSize,
    required this.fadeRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var column in columns) {
      double currentY = column.y;
      double opacity = 1.0;

      for (var char in column.characters) {
        final textSpan = TextSpan(
          text: char,
          style: TextStyle(
            color: textColor.withOpacity(opacity),
            fontSize: fontSize,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(canvas, Offset(column.x, currentY));

        currentY += fontSize;
        opacity = opacity > fadeRatio ? opacity - fadeRatio : fadeRatio;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}