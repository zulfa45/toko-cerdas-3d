import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_controller.dart';

class DaySummaryScreen extends ConsumerWidget {
  const DaySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final day = state.currentDay;
    final level = state.levelConfig;
    final stars = state.starsPerDay[day] ?? 3;
    final isLastDay = day >= 5;

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
                constraints: const BoxConstraints(maxWidth: 580),
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D2314),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFFC68A4C), width: 2.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Celebration Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF27AE60),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Text(
                        '🎉 HARI SELESAI!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Hebat! Hari $day Berhasil Diselesaikan!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFF1C40F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),

                    // 3 Big Gold Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        final isEarned = i < stars;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.star_rounded,
                            size: 54,
                            color: isEarned ? const Color(0xFFF1C40F) : Colors.white24,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Statistics Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B1B17),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF8D4F27), width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Pembeli Terlayani', style: TextStyle(fontSize: 12, color: Color(0xFFC68A4C))),
                              const SizedBox(height: 4),
                              Text(
                                '${level.customerCount}/${level.customerCount} Orang',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 40, color: const Color(0xFF8D4F27)),
                          Column(
                            children: [
                              const Text('Koin Hari Ini', style: TextStyle(fontSize: 12, color: Color(0xFFC68A4C))),
                              const SizedBox(height: 4),
                              Text(
                                '+${level.customerCount * 15} 🪙',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF1C40F)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Math review tip
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
                          const Text('⭐', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              level.mathTip,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF1C40F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.restockPhase);
                            },
                            icon: const Icon(Icons.inventory_2_outlined),
                            label: const Text('Isi Stok Rak', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFC68A4C),
                              side: const BorderSide(color: Color(0xFFC68A4C), width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (isLastDay) {
                                ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.home);
                              } else {
                                ref.read(gameControllerProvider.notifier).startDayBriefing(day + 1);
                              }
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
                            child: Text(
                              isLastDay ? 'Selesai & Ke Menu ▶' : 'Hari Berikutnya ▶',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
