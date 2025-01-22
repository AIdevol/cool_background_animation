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
        CelebrationAnimation(
          child: const Text('🎉'),
          particleCount: 100,
          colors: [Colors.blue, Colors.red, Colors.green, Colors.yellow],
          particleType: ParticleType.star,
          animationType: AnimationType.firework,
          backgroundType: BackgroundType.animated,
          backgroundGradientColors: [
            Colors.purple.withOpacity(0.3),
            Colors.blue.withOpacity(0.3),
            Colors.pink.withOpacity(0.3),
          ],
          rotateParticles: true,
          enableGlow: true,
          enableTrails: true,
          enablePhysics: true,
        ));
  }
}
