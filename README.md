# 🌈 Cool Background Animation 🌌

**Cool Background Animation** is a Flutter package designed to add stunning, customizable animated background effects to your apps. Perfect for enhancing visual appeal with minimal effort, this package ensures your projects stand out with eye-catching animations.

---

## ✨ Features
- 🚀 **Easy Integration**: Quickly integrate into any Flutter project.
- 🎨 **Customizable**: Adjust animation properties like speed, colors, and patterns.
- ⚡ **Optimized Performance**: Lightweight and highly efficient for smooth animations.

---

## 🛠️ Getting Started
Add the package to your project by including it in your `pubspec.yaml` file:

```yaml
dependencies:
  cool_background_animation: ^0.0.3
```

Run the following command to fetch the package:
```bash
flutter pub get
```

---
## 📚 Example Usage
Here's how you can use **Cool Background Animation** in your Flutter app:

```dart
import 'package:cool_background_animation/cool_background_animation.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarFallingBackground(
        speed: 2.0,
        colors: [Colors.blue, Colors.purple],
        patterns: Patterns.starfall,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RainbowBackground(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MatrixRainAnimation(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CelebrationAnimation(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BubbleBackground(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultipleBalloons(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  AnimatedBackgroundSymbols(
        symbolColor: Colors.green,
        symbolSize: 34.0,
        customSymbols: '!@#\$%^&*()_+',
        spawnInterval: Duration(milliseconds: 200),
    initialSymbolCount: 20,
    fontFamily: 'YourFontFamily',

    ));
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

```

---

## 🧩 Feedback and Contributions
We'd love to hear your thoughts! If you encounter any issues, have feature requests, or would like to contribute, please visit our [GitHub Repository](https://github.com/your-repo-link).

---

## 📄 License
This package is distributed under the MIT License. See the [LICENSE](https://github.com/your-repo-link/LICENSE) file for details.

Happy Animating! 🚀✨
