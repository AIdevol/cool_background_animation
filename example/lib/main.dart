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
            AnimatedBackgroundSymbols(
            symbolColor: Colors.green,
            symbolSize: 34.0,
            customSymbols: '!@#\$%^&*()_+',
            spawnInterval: Duration(milliseconds: 200),
            initialSymbolCount: 20,
            fontFamily: 'YourFontFamily',

        ));
  }
}
