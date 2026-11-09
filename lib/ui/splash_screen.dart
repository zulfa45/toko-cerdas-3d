import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Auto transition to HomeScreen after 2.5 seconds
    _timer = Timer(const Duration(milliseconds: 2500), _proceedToHome);
  }

  void _proceedToHome() {
    if (!mounted) return;
    _timer?.cancel();
    ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.home);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B1B17),
      body: GestureDetector(
        onTap: _proceedToHome,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF3E2723),
                Color(0xFF2B1B17),
                Color(0xFF1B0000),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative background sunlight glow
              Center(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFC68A4C).withValues(alpha: 0.15),
                  ),
                ),
              ),

              // Main Centered Content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated 3D Voxel Warung Logo
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFC68A4C), width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Color(0xFFF1C40F),
                              blurRadius: 12,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF8D4F27),
                              child: const Center(
                                child: Text('🏪', style: TextStyle(fontSize: 60)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Game Title in Voxel / Pixel Style
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D2314),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFC68A4C), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🪙', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 10),
                          Text(
                            'TOKO CERDAS 3D',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF1C40F),
                              letterSpacing: 2,
                              shadows: [
                                Shadow(color: Colors.black87, blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('🪙', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    const Text(
                      'Simulasi Warung Sembako Voxel & Belajar Berhitung',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE0C39E),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Warm Loading Bar
                    Container(
                      width: 200,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFC68A4C), width: 1.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF1C40F)),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Memuat Warung... Ketuk layar untuk mulai',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Brand Note
              const Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Toko Cerdas 3D — Flutter First-Person Sembako',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
