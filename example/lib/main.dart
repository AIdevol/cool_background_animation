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
        StarryBackground(
          numberOfStars: 200,
          starConfig: StarConfig(
            minSize: 1.0,
            maxSize: 4.0,
            starColor: Colors.amber,
            movementSpeed: 2.0,
            enableTwinkling: true,
          ),
          backgroundGradient: LinearGradient(
            colors: [Colors.red, Colors.blue.shade900],
          ),
          enableShootingStars: true,
          shootingStarInterval: Duration(seconds: 3),
        ));
  }
}
