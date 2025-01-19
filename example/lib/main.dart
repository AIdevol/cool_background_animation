import 'package:example/custom_model/rainbow_config.dart';
import 'package:example/rain_bow/rainbow_background.dart';
import 'package:flutter/material.dart';
import 'falling_star_background/fallingStar.dart';

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
      body: RainbowBackground(config: RainbowConfig(
        colors: [Colors.red],

      ),
      )/*const StarFallingBackground(
        numberOfStars: 100,
        starColor: Colors.green,
        minStarSize: 2.0,
        maxStarSize: 5.0,
        animationDuration: Duration(seconds: 10),
        backgroundColor: Colors.black,
      ),*/
    );
  }
}
