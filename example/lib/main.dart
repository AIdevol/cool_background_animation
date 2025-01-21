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
        body: RainbowBackground(
      config: const RainbowConfig(
        position: RainbowPosition.bottom,
        orientation: RainbowOrientation.down,
        positionOffset: 0.15,
      ),
    ));
  }
}
