import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/level_config.dart';
import '../game/game_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFD7EDF7),
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A085).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -40,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: const Color(0xFFF39C12).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top App Bar: Shop Name, Coin count, and Parent Gate
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Store Name Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Text('🏪', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                state.shopName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A085),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Coins & Parent Button
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9E6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFF1C40F), width: 1.5),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Text('🪙', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${state.coins} Koin',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFFD35400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Parent Gate Button
                            IconButton(
                              onPressed: () => _showParentSecurityDialog(context, ref),
                              icon: const Icon(Icons.lock, color: Color(0xFF7F8C8D)),
                              tooltip: 'Area Orang Tua',
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Big Title & Logo
                    const Text(
                      'TOKO CERDAS 3D',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF16A085),
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                        ],
                      ),
                    ),
                    const Text(
                      'Simulasi Toko Sembako & Belajar Matematika Uang Rupiah',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5D6D7E),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Age Group Selector (PRD Bab 3 & 8)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAgeOption(
                            label: '🧒 Umur 6–8 Tahun\n(Mode Ketuk & Jalan)',
                            isSelected: state.ageGroup == '6-8',
                            onTap: () => ref.read(gameControllerProvider.notifier).setAgeGroup('6-8'),
                          ),
                          const SizedBox(width: 8),
                          _buildAgeOption(
                            label: '🧑 Umur 9–12 Tahun\n(Mode Jalan Bebas)',
                            isSelected: state.ageGroup == '9-12',
                            onTap: () => ref.read(gameControllerProvider.notifier).setAgeGroup('9-12'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5-Day Level Selector Cards
                    const Text(
                      'Pilih Hari Berjualan:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: LevelConfig.allLevels.map((lvl) {
                        final isSelected = state.currentDay == lvl.day;
                        final stars = state.starsPerDay[lvl.day] ?? 0;

                        return GestureDetector(
                          onTap: () {
                            ref.read(gameControllerProvider.notifier).startDayBriefing(lvl.day);
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF16A085) : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF16A085) : const Color(0xFFD5D8DC),
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Hari ${lvl.day}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (starIdx) {
                                    return Icon(
                                      Icons.star,
                                      size: 15,
                                      color: starIdx < stars ? const Color(0xFFF1C40F) : Colors.grey.shade300,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // Big Play Button
                    SizedBox(
                      width: 320,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(gameControllerProvider.notifier).startDayBriefing(state.currentDay);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF39C12),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          elevation: 6,
                          shadowColor: const Color(0xFFD35400).withValues(alpha: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_arrow_rounded, size: 36),
                            const SizedBox(width: 8),
                            Text(
                              'Mulai Hari ${state.currentDay} ▶',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF16A085) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF7F8C8D),
          ),
        ),
      ),
    );
  }

  void _showParentSecurityDialog(BuildContext context, WidgetRef ref) {
    int num1 = 4;
    int num2 = 3;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.lock, color: Color(0xFF16A085)),
              SizedBox(width: 8),
              Text('Pintu Masuk Orang Tua'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Untuk keamanan anak, silakan jawab soal hitungan sederhana berikut:'),
              const SizedBox(height: 12),
              Text(
                'Berapa $num1 + $num2 = ?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Jawaban',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim() == '${num1 + num2}') {
                  Navigator.pop(ctx);
                  ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.parentDashboard);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jawaban belum tepat.')),
                  );
                }
              },
              child: const Text('Buka'),
            ),
          ],
        );
      },
    );
  }
}
