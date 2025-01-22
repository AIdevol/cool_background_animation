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
  cool_background_animation: ^0.0.1
```

Run the following command to fetch the package:
```bash
flutter pub get
```

---

## 🎥 Demo
### 🌟 Sample Animation
Below are previews showcasing the potential of **Cool Background Animation** in action:

#### 1️⃣ **Light Theme Animation**
![Light Theme Animation]([https://example.com/path-to-light-theme-demo.gif](https://github.com/AIdevol/cool_background_animation/blob/main/example/assets/animations/starfalling.gif))

#### 2️⃣ **Dark Theme Animation**
![Dark Theme Animation](https://example.com/path-to-dark-theme-demo.gif)

#### 📹 **Full Video Demo**
Prefer to watch the animation in its full glory? Check it out here:  
[Watch Full Demo](https://example.com/path-to-your-mov-file)

---

## 🎛️ Customization Options
The package offers several properties to tweak animations to your liking:

| **Property**      | **Description**              | **Default Value**       |
|-------------------|------------------------------|-------------------------|
| `speed`           | Controls the animation speed | `1.0`                   |
| `colors`          | Array of colors for animation| `[Colors.green]`        |
| `patterns`        | Predefined animation patterns| `Patterns.default`      |

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
```

---

## 🧩 Feedback and Contributions
We'd love to hear your thoughts! If you encounter any issues, have feature requests, or would like to contribute, please visit our [GitHub Repository](https://github.com/your-repo-link).

---

## 📄 License
This package is distributed under the MIT License. See the [LICENSE](https://github.com/your-repo-link/LICENSE) file for details.

Happy Animating! 🚀✨
