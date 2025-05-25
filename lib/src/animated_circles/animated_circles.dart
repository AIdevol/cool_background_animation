import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedCircles extends StatefulWidget {
  @override
  _AnimatedCirclesState createState() => _AnimatedCirclesState();
}

class _AnimatedCirclesState extends State<AnimatedCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Adjustable parameters
  Color backgroundColor = Colors.indigo.shade900;
  Color circleColor = Colors.purple;
  double strokeWidth = 3.0;
  int circleCount = 8;
  double speedMultiplier = 1.0;
  bool useRainbowColors = true;
  bool useBlurEffect = true;
  bool usePulseEffect = true;

  // Child widget parameters
  bool showChildWidget = true;
  int selectedChildWidget = 0;
  List<String> childWidgetTypes = ['Card', 'Interactive Game', 'Profile'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSpeed(double value) {
    setState(() {
      speedMultiplier = value;
      _controller.duration =
          Duration(milliseconds: (6000 / speedMultiplier).round());
      if (_controller.isAnimating) {
        _controller.repeat();
      }
    });
  }

  void _updateCircleCount(double value) {
    setState(() {
      circleCount = value.round();
    });
  }

  void _updateStrokeWidth(double value) {
    setState(() {
      strokeWidth = value;
    });
  }

  void _updateSelectedChildWidget(int index) {
    setState(() {
      selectedChildWidget = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Beautiful Circles with Content'),
        backgroundColor: Colors.black54,
        elevation: 0,
        actions: [
          Switch(
            value: showChildWidget,
            onChanged: (value) {
              setState(() {
                showChildWidget = value;
              });
            },
            activeColor: Colors.greenAccent,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Background animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
                painter: CirclePainter(
                  _controller.value,
                  circleCount,
                  circleColor,
                  strokeWidth,
                  useRainbowColors,
                  useBlurEffect,
                  usePulseEffect,
                ),
              );
            },
          ),

          // Child widget
          if (showChildWidget)
            Center(
              child: _buildSelectedChildWidget(),
            ),

          // Controls at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildControlPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedChildWidget() {
    switch (selectedChildWidget) {
      case 0:
        return _buildCardWidget();
      case 1:
        return _buildInteractiveGame();
      case 2:
        return _buildProfileWidget();
      default:
        return _buildCardWidget();
    }
  }

  Widget _buildCardWidget() {
    return Hero(
      tag: 'card_widget',
      child: Container(
        width: 300,
        height: 350,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white.withOpacity(0.85),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: circleColor,
                child: Icon(Icons.person, size: 70, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Flutter Developer',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Show a dialog when button is pressed
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Card Action'),
                      content: Text('You clicked the action button!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: circleColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text('View Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveGame() {
    return TapGame(baseColor: circleColor);
  }

  Widget _buildProfileWidget() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: circleColor.withOpacity(0.2),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: circleColor,
              child: Text(
                'JD',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '@johndoe',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat('Posts', '124'),
              SizedBox(width: 30),
              _buildStat('Followers', '452'),
              SizedBox(width: 30),
              _buildStat('Following', '215'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(Icons.message, 'Message'),
              SizedBox(width: 20),
              _buildActionButton(Icons.person_add, 'Follow'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label action pressed'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: circleColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      color: Colors.black45,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Child widget selector
          if (showChildWidget)
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.widgets, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Widget Type:', style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < childWidgetTypes.length; i++)
                      _widgetTypeButton(i, childWidgetTypes[i]),
                  ],
                ),
                Divider(color: Colors.white24, height: 24),
              ],
            ),

          // Circle count slider
          Row(
            children: [
              Icon(Icons.circle_outlined, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text('Circles:', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  value: circleCount.toDouble(),
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: circleCount.toString(),
                  onChanged: _updateCircleCount,
                ),
              ),
              Text('$circleCount', style: TextStyle(color: Colors.white)),
            ],
          ),

          // Speed slider
          Row(
            children: [
              Icon(Icons.speed, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text('Speed:', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  value: speedMultiplier,
                  min: 0.1,
                  max: 3.0,
                  divisions: 29,
                  label: speedMultiplier.toStringAsFixed(1),
                  onChanged: _updateSpeed,
                ),
              ),
              Text('${speedMultiplier.toStringAsFixed(1)}x', style: TextStyle(color: Colors.white)),
            ],
          ),

          // Width slider
          Row(
            children: [
              Icon(Icons.line_weight, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text('Width:', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  value: strokeWidth,
                  min: 1.0,
                  max: 20.0,
                  divisions: 19,
                  label: strokeWidth.toStringAsFixed(1),
                  onChanged: _updateStrokeWidth,
                ),
              ),
              Text('${strokeWidth.toStringAsFixed(1)}', style: TextStyle(color: Colors.white)),
            ],
          ),

          // Effect toggles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Rainbow', style: TextStyle(color: Colors.white)),
                  Switch(
                    value: useRainbowColors,
                    onChanged: (value) {
                      setState(() {
                        useRainbowColors = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Blur', style: TextStyle(color: Colors.white)),
                  Switch(
                    value: useBlurEffect,
                    onChanged: (value) {
                      setState(() {
                        useBlurEffect = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pulse', style: TextStyle(color: Colors.white)),
                  Switch(
                    value: usePulseEffect,
                    onChanged: (value) {
                      setState(() {
                        usePulseEffect = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          // Color picker row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _colorOption(Colors.purple, 'Purple'),
              _colorOption(Colors.blue, 'Blue'),
              _colorOption(Colors.teal, 'Teal'),
              _colorOption(Colors.green, 'Green'),
              _colorOption(Colors.amber, 'Amber'),
              _colorOption(Colors.orange, 'Orange'),
              _colorOption(Colors.red, 'Red'),
            ],
          ),

          // Background color picker row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _bgColorOption(Colors.black, 'Black'),
              _bgColorOption(Colors.indigo.shade900, 'Indigo'),
              _bgColorOption(Colors.blue.shade900, 'Dark Blue'),
              _bgColorOption(Colors.purple.shade900, 'Dark Purple'),
              _bgColorOption(Colors.teal.shade900, 'Dark Teal'),
              _bgColorOption(Colors.green.shade900, 'Dark Green'),
              _bgColorOption(Colors.red.shade900, 'Dark Red'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _widgetTypeButton(int index, String label) {
    return ElevatedButton(
      onPressed: () => _updateSelectedChildWidget(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedChildWidget == index
            ? circleColor
            : Colors.grey.shade800,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _colorOption(Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          setState(() {
            circleColor = color;
          });
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: circleColor == color ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bgColorOption(Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          setState(() {
            backgroundColor = color;
          });
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color:
              backgroundColor == color ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// Interactive tapping game as one of the child widget options
class TapGame extends StatefulWidget {
  final Color baseColor;

  TapGame({required this.baseColor});

  @override
  _TapGameState createState() => _TapGameState();
}

class _TapGameState extends State<TapGame> with SingleTickerProviderStateMixin {
  int score = 0;
  List<Bubble> bubbles = [];
  late AnimationController _animController;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat();

    // Initialize with some bubbles
    for (int i = 0; i < 5; i++) {
      _addBubble();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addBubble() {
    final size = 30.0 + random.nextDouble() * 50;
    bubbles.add(
      Bubble(
        x: random.nextDouble() * 250,
        y: random.nextDouble() * 350,
        size: size,
        color: HSVColor.fromAHSV(
          0.7,
          random.nextDouble() * 360,
          0.8,
          0.9,
        ).toColor(),
        speedX: -2 + (random.nextDouble() * 4),
        speedY: -2 + (random.nextDouble() * 4),
      ),
    );
  }

  void _removeBubble(int index) {
    setState(() {
      bubbles.removeAt(index);
      score++;
      _addBubble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.baseColor.withOpacity(0.6),
          width: 3,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Score display
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Score: $score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Game area
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              // Update bubble positions
              for (var bubble in bubbles) {
                bubble.x += bubble.speedX;
                bubble.y += bubble.speedY;

                // Bounce off walls
                if (bubble.x <= 0 || bubble.x >= 300 - bubble.size) {
                  bubble.speedX *= -1;
                }
                if (bubble.y <= 0 || bubble.y >= 400 - bubble.size) {
                  bubble.speedY *= -1;
                }
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  for (int i = 0; i < bubbles.length; i++)
                    Positioned(
                      left: bubbles[i].x,
                      top: bubbles[i].y,
                      child: GestureDetector(
                        onTap: () => _removeBubble(i),
                        child: Container(
                          width: bubbles[i].size,
                          height: bubbles[i].size,
                          decoration: BoxDecoration(
                            color: bubbles[i].color.withOpacity(0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: bubbles[i].color.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '+1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: bubbles[i].size / 3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Instructions
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Tap the bubbles!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Bubble class for the game
class Bubble {
  double x;
  double y;
  double size;
  Color color;
  double speedX;
  double speedY;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speedX,
    required this.speedY,
  });
}

class CirclePainter extends CustomPainter {
  final double animationValue;
  final int circleCount;
  final Color baseColor;
  final double strokeWidth;
  final bool useRainbowColors;
  final bool useBlurEffect;
  final bool usePulseEffect;

  CirclePainter(
      this.animationValue,
      this.circleCount,
      this.baseColor,
      this.strokeWidth,
      this.useRainbowColors,
      this.useBlurEffect,
      this.usePulseEffect,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    for (int i = 0; i < circleCount; i++) {
      // Calculate base radius with animation
      final progress = i / circleCount;
      final baseRadius = progress * maxRadius;

      // Apply animation value for movement
      final animOffset = animationValue * (maxRadius / circleCount);
      double radius = (baseRadius + animOffset) % maxRadius;

      // Add pulsing effect if enabled
      if (usePulseEffect) {
        final pulseAmount = math.sin(animationValue * math.pi * 2 +
            (i / circleCount) * math.pi * 2) *
            5;
        radius += pulseAmount;
      }

      // Determine color based on settings
      Color circleColor;
      if (useRainbowColors) {
        // Create rainbow effect
        final hue = (progress * 360 + animationValue * 360) % 360;
        circleColor = HSVColor.fromAHSV(
          0.7 +
              (0.3 *
                  math.sin(
                      animationValue * math.pi * 2 + i)), // opacity variation
          hue, // hue
          0.8, // saturation
          0.9, // value (brightness)
        ).toColor();
      } else {
        // Use the base color with varying opacity
        final opacity = 0.4 + (0.6 * (1 - progress));
        circleColor = baseColor.withOpacity(opacity);
      }

      // Setup paint with or without blur
      final paint = Paint()
        ..color = circleColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      if (useBlurEffect) {
        paint.maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          (circleCount - i) / circleCount * 5,
        );
      }

      // Draw the circle
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.circleCount != circleCount ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.useRainbowColors != useRainbowColors ||
        oldDelegate.useBlurEffect != useBlurEffect ||
        oldDelegate.usePulseEffect != usePulseEffect;
  }
}