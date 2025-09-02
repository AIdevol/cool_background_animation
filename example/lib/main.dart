import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'bubble_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Animation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SpiralBackgroundDemo(),
    );
  }
}

class SpiralBackgroundDemo extends StatelessWidget {
  const SpiralBackgroundDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        numberOfStars: 150,
        starConfig: StarConfig(
          // starColor: Colors.white,
          // enableTwinkling: true,
          enableMovement: true,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Under the Stars',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Make a wish upon a shooting star...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
