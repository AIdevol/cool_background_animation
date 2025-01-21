# Cool Background Animation

Cool Background Animation is a Flutter package that provides stunning and customizable animated background effects for your apps. This package is perfect for adding visually appealing animations to your projects with minimal effort.

## Features
- Easy to integrate with any Flutter project.
- Supports customizable animation properties such as speed, colors, and patterns.
- Lightweight and optimized for performance.

## Getting Started
To use this package, add it as a dependency in your `pubspec.yaml` file:
```yaml
dependencies:
  cool_background_animation: ^0.0.1
```

## Demo
Below is a demo of the animations you can create with this package:

### Sample Animation
![Cool Background Animation Demo](https://example.com/path-to-your-gif-or-mov-preview.gif)

> 💡 **Tip:** You can host your `.mov` file on a cloud service or convert it to `.gif` to embed it directly in your `README.md` file.

If you prefer to view the `.mov` format directly, you can check out the video here:  
[View Animation Demo](https://example.com/path-to-your-mov-file)

## Usage
To use the animation in your project, import the package and implement it as follows:
```dart
import 'package:cool_background_animation/cool_background_animation.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CoolBackgroundAnimation(
        // Customize your animation properties here
      ),
    );
  }
}
```

## Customization Options
| Property         | Description                   | Default Value       |
|------------------|-------------------------------|---------------------|
| `speed`          | Animation speed               | `1.0`               |
| `colors`         | Array of colors for animation | `[Colors.green]`    |
| `patterns`       | Predefined animation patterns | `Patterns.default`  |

---
