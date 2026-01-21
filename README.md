# 🌈 Cool Background Animation 🌌

![Cool Background Animation Demo](https://raw.githubusercontent.com/AIdevol/cool_background_animation/main/example/assets/Untitleddesign-ezgif.com-video-to-gif-converter.gif)

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
  cool_background_animation: 1.2.0
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientMeshBackground(
        config: GradientMeshConfig(
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
            Color(0xFFF093FB),
            Color(0xFF4FACFE),
          ],
          animationSpeed: 1.0,
          enableBlur: true,
          enablePulsing: true,
        ),
        child: Center(
          child: Text(
            'Beautiful Gradient Mesh',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
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
