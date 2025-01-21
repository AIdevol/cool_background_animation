import 'package:flutter/material.dart';

import 'bubble_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Star Falling Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        BubbleBackground(
        numberOfBubbles: 30,
        bubbleColors: [Colors.purple, Colors.pink, Colors.deepPurple],
        config: BubbleConfig(
        minRadius: 15,
        maxRadius: 50,
        minSpeed: 0.5,
        maxSpeed: 2.5,
        minOpacity: 0.3,
        maxOpacity: 0.7,
        enableGradient: true,
        gradientColors: [Colors.blue, Colors.lightBlue],
        enablePulsing: true,
        pulsingDuration: Duration(seconds: 3),
    enableWobble: true,
    wobbleIntensity: 3.0,
    ),
    backgroundDecoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.black, Colors.blue.shade900],
    ),
    ),
    ));
  }
}
