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
    final currentDay = state.currentDay;
    final displayCoins = state.coins > 0 ? state.coins : 12500;
    final coinsText = Product.formatRupiah(displayCoins, withSpace: true);

    return Scaffold(
      backgroundColor: const Color(0xFF1E100B),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF381F15),
                Color(0xFF24140D),
                Color(0xFF150A06),
              ],
            ),
          ),
          child: Column(
            children: [
              // 1. TOP STATUS BAR (Coin, Audio, Parent Lock)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Shopkeeper Identity Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E1911),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFC68A4C), width: 1.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Text('🏪', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.shopName,
                            style: const TextStyle(
                              color: Color(0xFFF1C40F),
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right Badges (Coins, Sound, Parent Gate)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Coin Wallet Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E1911),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFC68A4C), width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
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
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                coinsText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Audio Toggle Button
                        IconButton(
                          onPressed: () {
                            ref.read(gameControllerProvider.notifier).toggleAudio();
                          },
                          icon: Icon(
                            state.isAudioEnabled ? Icons.volume_up : Icons.volume_off,
                            color: state.isAudioEnabled ? const Color(0xFFF1C40F) : Colors.white38,
                            size: 18,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF2E1911),
                            side: const BorderSide(color: Color(0xFFC68A4C), width: 1.2),
                            padding: const EdgeInsets.all(6),
                          ),
                          tooltip: 'Musik & Suara',
                        ),
                        const SizedBox(width: 6),

                        // Parent Lock Button
                        IconButton(
                          onPressed: () => _showParentSecurityDialog(context, ref),
                          icon: const Icon(Icons.lock, color: Color(0xFFC68A4C), size: 18),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF2E1911),
                            side: const BorderSide(color: Color(0xFFC68A4C), width: 1.2),
                            padding: const EdgeInsets.all(6),
                          ),
                          tooltip: 'Area Orang Tua',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. MAIN SCROLLABLE BODY
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: Column(
                    children: [
                      // HERO BANNER: 3D Voxel Warung Showcase
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 680),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E1911),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFC68A4C), width: 2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            // 3D Voxel Logo Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFF1C40F), width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4)),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(child: Text('🏪', style: TextStyle(fontSize: 40))),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Title & Description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('🏪', style: TextStyle(fontSize: 20)),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'TOKO CERDAS 3D',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFFF1C40F),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Simulasi Toko Sembako Voxel First-Person untuk Anak!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Ambil barang di rak, hitung total belanja, dan berikan uang kembalian pas.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFD7CCC8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // AGE GROUP TOGGLE CARDS
                      Container(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildAgeCard(
                                title: '🧒 Toko Pemula',
                                subtitle: 'Umur 6–8 Tahun • Pesanan 1–2 barang, angka ribuan bulat',
                                isSelected: state.ageGroup == '6-8',
                                onTap: () => ref.read(gameControllerProvider.notifier).setAgeGroup('6-8'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildAgeCard(
                                title: '🧑 Kasir Mahir',
                                subtitle: 'Umur 9–12 Tahun • Pesanan banyak, perkalian, kembalian pecahan',
                                isSelected: state.ageGroup == '9-12',
                                onTap: () => ref.read(gameControllerProvider.notifier).setAgeGroup('9-12'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 5-DAY STAGE MAP
                      Container(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text('🗺️', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 6),
                                Text(
                                  'Pilih Hari Berjualan (Hari 1 — 5):',
                                  style: TextStyle(
                                    color: Color(0xFFF1C40F),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Stage Cards
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: LevelConfig.allLevels.map((lvl) {
                                  final isSelected = currentDay == lvl.day;
                                  final stars = state.starsPerDay[lvl.day] ?? 0;

                                  return GestureDetector(
                                    onTap: () {
                                      ref.read(gameControllerProvider.notifier).startDayBriefing(lvl.day);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 120,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF4A2818) : const Color(0xFF26140D),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFFF1C40F) : const Color(0xFF8D4F27),
                                          width: isSelected ? 2.5 : 1.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isSelected ? const Color(0xFFF1C40F).withValues(alpha: 0.3) : Colors.black38,
                                            blurRadius: isSelected ? 8 : 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFFF1C40F) : const Color(0xFF3E2723),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'HARI ${lvl.day}',
                                              style: TextStyle(
                                                color: isSelected ? const Color(0xFF2B1B17) : Colors.white70,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            lvl.title.split('—').last.trim(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: List.generate(3, (starIdx) {
                                              return Icon(
                                                Icons.star_rounded,
                                                size: 16,
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // BIG ACTION CTA BUTTON
                      Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(gameControllerProvider.notifier).startDayBriefing(currentDay);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF27AE60),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Colors.white, width: 2),
                            ),
                            elevation: 8,
                            shadowColor: const Color(0xFF27AE60).withValues(alpha: 0.6),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.storefront, size: 26),
                                const SizedBox(width: 8),
                                Text(
                                  'BUKA TOKO HARI $currentDay ▶',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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

  Widget _buildAgeCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A2818) : const Color(0xFF26140D),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFFF1C40F) : const Color(0xFF8D4F27),
            width: isSelected ? 2 : 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? const Color(0xFFF1C40F) : Colors.white38,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFF1C40F) : Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFFD7CCC8),
                fontSize: 10,
                height: 1.15,
              ),
            ),
          ],
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
