// splashScreen.dart
import 'package:flutter/material.dart';
import 'package:liqd_sound_mov/views/home/dashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Más grande
    final logoBoxSize = size.width * 0.32;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF8A5B),
                  Color(0xFFFF5FA2),
                  Color(0xFF7A3DFF),
                ],
              ),
            ),
          ),

          // Soft circles (decor)
          Positioned(
            top: -size.width * 0.15,
            right: -size.width * 0.10,
            child: _SoftCircle(diameter: size.width * 0.55, opacity: 0.16),
          ),
          Positioned(
            bottom: -size.width * 0.20,
            left: -size.width * 0.18,
            child: _SoftCircle(diameter: size.width * 0.55, opacity: 0.14),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: logoBoxSize,
                      width: logoBoxSize,
                      padding: EdgeInsets.all(logoBoxSize * 0.18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo_inverted.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'LiqdSound',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your Music, Your Way',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 4),

                // Bottom indicators + version
                Column(
                  children: const [
                    _LoadingDotsIndicator(),
                    SizedBox(height: 14),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double diameter;
  final double opacity;

  const _SoftCircle({required this.diameter, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

/// 3 puntos con animación tipo "loading" (fade + scale)
class _LoadingDotsIndicator extends StatefulWidget {
  const _LoadingDotsIndicator();

  @override
  State<_LoadingDotsIndicator> createState() => _LoadingDotsIndicatorState();
}

class _LoadingDotsIndicatorState extends State<_LoadingDotsIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const int _count = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value; // 0..1
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_count, (i) {
            // fase por punto: 0..1
            final phase = (t + (i / _count)) % 1.0;

            // curva: pico en el centro
            final dist = (phase - 0.5).abs() * 2; // 0 (center) .. 1 (edges)
            final scale = 0.85 + (1 - dist) * 0.35; // 0.85..1.20
            final alpha = 0.35 + (1 - dist) * 0.60; // 0.35..0.95

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: alpha),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}