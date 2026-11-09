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
      backgroundColor: const Color(0xFFD7EDF7),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 620,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFF1C40F), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 24,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🎉 HARI SELESAI!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'Hebat! Hari $day Berhasil Diselesaikan!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),

                // 3 Big Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final isEarned = i < stars;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.star_rounded,
                        size: 52,
                        color: isEarned ? const Color(0xFFF1C40F) : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // Statistics Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF9F5),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2D9CC)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Pembeli Terlayani', style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D))),
                          const SizedBox(height: 4),
                          Text(
                            '${level.customerCount}/${level.customerCount} Orang',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF16A085)),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 40, color: const Color(0xFFE2D9CC)),
                      Column(
                        children: [
                          const Text('Koin Hari Ini', style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D))),
                          const SizedBox(height: 4),
                          Text(
                            '+${level.customerCount * 15} 🪙',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD35400)),
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
                    color: const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(14),
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
                            color: Color(0xFF16A085),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                          backgroundColor: const Color(0xFFF39C12),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    );
  }
}
