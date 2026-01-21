import 'package:flutter/material.dart';
import 'package:cool_background_animation/cool_background_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool Background Animation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GradientMeshDemo(),
    );
  }
}

class GradientMeshDemo extends StatefulWidget {
  const GradientMeshDemo({Key? key}) : super(key: key);

  @override
  State<GradientMeshDemo> createState() => _GradientMeshDemoState();
}

class _GradientMeshDemoState extends State<GradientMeshDemo> {
  double _animationSpeed = 1.0;
  bool _enableBlur = true;
  bool _enablePulsing = true;
  int _colorSchemeIndex = 0;

  final List<List<Color>> _colorSchemes = [
    [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
      Color(0xFFF093FB),
      Color(0xFF4FACFE),
    ],
    [
      Color(0xFFF093FB),
      Color(0xFFF5576C),
      Color(0xFF4FACFE),
      Color(0xFF00F2FE),
    ],
    [
      Color(0xFF43E97B),
      Color(0xFF38F9D7),
      Color(0xFF667EEA),
      Color(0xFF764BA2),
    ],
    [
      Color(0xFFFA709A),
      Color(0xFFFEE140),
      Color(0xFF30CFD0),
      Color(0xFF330867),
    ],
    [
      Color(0xFFA8EDEA),
      Color(0xFFFED6E3),
      Color(0xFFD299C2),
      Color(0xFFFEF9D7),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientMeshBackground(
        config: GradientMeshConfig(
          colors: _colorSchemes[_colorSchemeIndex],
          animationSpeed: _animationSpeed,
          enableBlur: _enableBlur,
          enablePulsing: _enablePulsing,
          gridSize: 8,
          waveAmplitude: 50.0,
          blurIntensity: 0.3,
          pulseIntensity: 0.2,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Gradient Mesh Background',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(2, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Beautiful animated gradient mesh effect',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content Card
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 64,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Customize Your Animation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Animation Speed
                        _buildControlSection(
                          'Animation Speed',
                          Slider(
                            value: _animationSpeed,
                            min: 0.5,
                            max: 3.0,
                            divisions: 10,
                            label: _animationSpeed.toStringAsFixed(1),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.3),
                            onChanged: (value) {
                              setState(() {
                                _animationSpeed = value;
                              });
                            },
                          ),
                        ),

                        SizedBox(height: 16),

                        // Toggle Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildToggleButton(
                              'Blur',
                              _enableBlur,
                              Icons.blur_on,
                              () {
                                setState(() {
                                  _enableBlur = !_enableBlur;
                                });
                              },
                            ),
                            _buildToggleButton(
                              'Pulse',
                              _enablePulsing,
                              Icons.radio_button_checked,
                              () {
                                setState(() {
                                  _enablePulsing = !_enablePulsing;
                                });
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Color Scheme Selector
                        Text(
                          'Color Schemes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            _colorSchemes.length,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _colorSchemeIndex = index;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _colorSchemeIndex == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.3),
                                    width: _colorSchemeIndex == index ? 3 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Row(
                                    children: _colorSchemes[index]
                                        .map((color) => Expanded(
                                              child: Container(color: color),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Smooth • Fluid • Beautiful',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlSection(String title, Widget control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        control,
      ],
    );
  }

  Widget _buildToggleButton(
    String label,
    bool isEnabled,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isEnabled
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? Colors.white : Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
