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
        MultipleBalloons(
          balloonCount: 30,
          colors: [Colors.red, Colors.blue, Colors.green],
          minSize: 30,
          maxSize: 60,
          minSpeed: 0.8,
          maxSpeed: 1.5,
          balloonShape: BalloonShape.round,
          stringColor: Colors.black,
          stringLength: 2.0,
          opacity: 0.8,
          swayingCurve: Curves.easeInOutBack,
          enableRespawn: true,
          // areaConstraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
        ));
  }
}
