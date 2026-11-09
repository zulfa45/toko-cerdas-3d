import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/level_config.dart';
import '../data/product_catalog.dart';
import '../game/game_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final displayCoins = state.coins > 0 ? state.coins : 12500;
    final coinsText = Product.formatRupiah(displayCoins, withSpace: true);

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Header Bar: Logo & Shop Name + Coins + Parent Gate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Store Name Badge with Voxel Logo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D2314),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFC68A4C), width: 2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 26,
                                height: 26,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Text('🏪', style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.shopName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFF1C40F),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right Badges: Coins & Parent Lock
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Coin Badge (Matching Warung Counter UI)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D2314),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFC68A4C), width: 2),
                              boxShadow: const [
                                BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF1C40F),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '\$',
                                      style: TextStyle(
                                        color: Color(0xFF7D6608),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  coinsText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Parent Gate Lock Button
                          IconButton(
                            onPressed: () => _showParentSecurityDialog(context, ref),
                            icon: const Icon(Icons.lock, color: Color(0xFFC68A4C), size: 20),
                            tooltip: 'Area Orang Tua',
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF3D2314),
                              side: const BorderSide(color: Color(0xFFC68A4C), width: 1.5),
                              elevation: 3,
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Center Banner: 3D Voxel Logo + Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 3D Voxel Logo
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFC68A4C), width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF8D4F27),
                              child: const Center(
                                child: Text('🏪', style: TextStyle(fontSize: 44)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),

                      // Title & Subtitle in Voxel Theme
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D2314),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFC68A4C), width: 1.5),
                            ),
                            child: const Text(
                              'TOKO CERDAS 3D',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFF1C40F),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Simulasi Warung Sembako & Belajar Berhitung Rupiah',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD7CCC8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Age Group Selector (Wooden Pill Tabs)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F120E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF8D4F27), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAgeOption(
                          label: '🧒 Umur 6–8 Tahun\n(Mode Bantuan Penuh)',
                          isSelected: state.ageGroup == '6-8',
                          onTap: () => ref.read(gameControllerProvider.notifier).setAgeGroup('6-8'),
                        ),
                        const SizedBox(width: 6),
                        _buildAgeOption(
                          label: '🧑 Umur 9–12 Tahun\n(Kasir Mandiri)',
                          isSelected: state.ageGroup == '9-12',
                          onTap: () => ref.read(gameControllerProvider.notifier).setAgeGroup('9-12'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 5-Day Level Selector Cards (Wooden Plank Cards)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: LevelConfig.allLevels.map((lvl) {
                      final isSelected = state.currentDay == lvl.day;
                      final stars = state.starsPerDay[lvl.day] ?? 0;

                      return GestureDetector(
                        onTap: () {
                          ref.read(gameControllerProvider.notifier).startDayBriefing(lvl.day);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 95,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF4E2A10) : const Color(0xFF2C1914),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFF1C40F) : const Color(0xFF8D4F27),
                              width: isSelected ? 2.5 : 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected ? const Color(0xFFF1C40F).withValues(alpha: 0.3) : Colors.black26,
                                blurRadius: isSelected ? 8 : 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Hari ${lvl.day}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  color: isSelected ? const Color(0xFFF1C40F) : Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (starIdx) {
                                  return Icon(
                                    Icons.star,
                                    size: 15,
                                    color: starIdx < stars ? const Color(0xFFF1C40F) : Colors.white24,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Big Play Button
                  SizedBox(
                    width: 310,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(gameControllerProvider.notifier).startDayBriefing(state.currentDay);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27AE60),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        elevation: 6,
                        shadowColor: const Color(0xFF27AE60).withValues(alpha: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.storefront, size: 26),
                          const SizedBox(width: 10),
                          Text(
                            'Buka Warung Hari ${state.currentDay} ▶',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC68A4C) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF2B1B17) : const Color(0xFFD7CCC8),
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
          backgroundColor: const Color(0xFF2B1B17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFC68A4C), width: 2),
          ),
          title: const Row(
            children: [
              Icon(Icons.lock, color: Color(0xFFF1C40F)),
              SizedBox(width: 8),
              Text(
                'Pintu Masuk Orang Tua',
                style: TextStyle(color: Color(0xFFF1C40F), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Untuk keamanan anak, silakan jawab soal hitungan sederhana berikut:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Text(
                'Berapa $num1 + $num2 = ?',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFF1C40F)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Jawaban',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF3D2314),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFC68A4C)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                foregroundColor: Colors.white,
              ),
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
