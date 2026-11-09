import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_controller.dart';

class DayBriefingScreen extends ConsumerWidget {
  const DayBriefingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final level = state.levelConfig;

    return Scaffold(
      backgroundColor: const Color(0xFF2B1B17),
      body: SafeArea(
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
                Color(0xFF1B0F0B),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 560),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D2314),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFC68A4C), width: 2.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Day Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC68A4C),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        'HARI ${level.day}',
                        style: const TextStyle(
                          color: Color(0xFF2B1B17),
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      level.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFF1C40F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),

                    // Customer Target & Target Skill Info Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B1B17),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF8D4F27), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people_alt, color: Color(0xFFF1C40F), size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Target Hari Ini: Melayani ${level.customerCount} Pembeli',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 14, color: Colors.white24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.school, color: Color(0xFFE67E22), size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Kemampuan yang Dilatih:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFC68A4C),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      level.skillTrained,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Math Tip Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E140F),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFC68A4C), width: 1),
                      ),
                      child: Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              level.mathTip,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF1C40F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: OutlinedButton(
                            onPressed: () {
                              ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.home);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFC68A4C),
                              side: const BorderSide(color: Color(0xFFC68A4C), width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Menu Utama', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 6,
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(gameControllerProvider.notifier).launchInStoreGameplay();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF27AE60),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              elevation: 4,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.storefront, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'Masuk ke Warung ▶',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
