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
        InfiniteSpiralMotionAnimation(
          size: 300,
          colors: [Colors.blue, Colors.purple, Colors.pink],
          colorBlendMode: ColorBlendMode.rainbow,
          enableParticles: true,
          enable3DEffect: true,
          enableShimmer: true,
          enableGradientBorder: true,
          enablePulsingBorder: true,
          enableShadow: true,
          rotationX: 0.2,
          rotationY: 0.1,
          direction: AnimationDirection.all,
        ));
  }
}
