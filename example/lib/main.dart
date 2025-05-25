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
      home: const BalloonDemoPage(),
    );
  }
}

class BalloonDemoPage extends StatelessWidget {
  const BalloonDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BalloonBackgroundWidget(
        // Option 1: Solid background color
        backgroundColor: Colors.lightBlue[100],

        // Option 2: Gradient background (comment out backgroundColor if using this)
        // backgroundGradient: LinearGradient(
        //   colors: [Colors.blue[100]!, Colors.purple[100]!],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),

        balloonCount: 15,

        // Option A: Solid color balloons
        balloonColors: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
        ],

        // Option B: Gradient balloons (comment out balloonColors if using this)
        // balloonGradients: [
        //   LinearGradient(colors: [Colors.red, Colors.orange]),
        //   LinearGradient(colors: [Colors.blue, Colors.purple]),
        //   LinearGradient(colors: [Colors.green, Colors.yellow]),
        //   LinearGradient(colors: [Colors.pink, Colors.purple]),
        // ],

        balloonShape: BalloonShape.heart,
        minSize: 40,
        maxSize: 80,
        minSpeed: 0.8,
        maxSpeed: 2.0,
        opacity: 0.8,

        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Happy Birthday!",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}