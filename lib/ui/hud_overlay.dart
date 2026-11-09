import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_controller.dart';

class HudOverlay extends ConsumerWidget {
  final VoidCallback onGoToCashier;
  final Function(String shelfId) onGoToShelf;
  final Function(String mode) onToggleMode;

  const HudOverlay({
    super.key,
    required this.onGoToCashier,
    required this.onGoToShelf,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top HUD bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Shop Title Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A085),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🏪 Toko Cerdas 3D',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Live FPS Badge (PRD Week 1 Gate metric: target 30 fps, RAM 4GB)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: state.measuredFps >= 30
                        ? const Color(0xFF27AE60)
                        : const Color(0xFFE67E22),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.speed, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${state.measuredFps} FPS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Mode Selector Toggle (Ketuk & Jalan vs Jalan Bebas)
                GestureDetector(
                  onTap: () {
                    final nextMode = state.navigationMode == 'TAP_AND_WALK'
                        ? 'FREE_WALK'
                        : 'TAP_AND_WALK';
                    ref.read(gameControllerProvider.notifier).setNavigationMode(nextMode);
                    onToggleMode(nextMode);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: state.navigationMode == 'TAP_AND_WALK'
                          ? const Color(0xFF2980B9)
                          : const Color(0xFF8E44AD),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.navigationMode == 'TAP_AND_WALK'
                              ? Icons.touch_app
                              : Icons.sports_esports,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.navigationMode == 'TAP_AND_WALK'
                              ? 'Mode Ketuk'
                              : 'Mode Bebas',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Customer Speech Bubble if arrived at cashier (PRD Bab 9)
          if (state.customerState == 'ARRIVED')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 380),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF16A085), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFF39C12),
                        radius: 20,
                        child: const Text('🧕', style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.customerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF16A085),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.customerSpeech,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const Spacer(),

          // Bottom Bar: Shelf Jump Pills + Cashier Return Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Row(
              children: [
                // Shelf Shortcut Pills
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildShelfPill(
                          id: 'rak_sembako',
                          label: '🌾 Sembako',
                          color: const Color(0xFF16A085),
                          isActive: state.activeShelf == 'rak_sembako',
                        ),
                        const SizedBox(width: 6),
                        _buildShelfPill(
                          id: 'rak_makanan',
                          label: '🍜 Makanan',
                          color: const Color(0xFFE67E22),
                          isActive: state.activeShelf == 'rak_makanan',
                        ),
                        const SizedBox(width: 6),
                        _buildShelfPill(
                          id: 'rak_minuman',
                          label: '🥛 Minuman',
                          color: const Color(0xFF3498DB),
                          isActive: state.activeShelf == 'rak_minuman',
                        ),
                        const SizedBox(width: 6),
                        _buildShelfPill(
                          id: 'rak_bumbu',
                          label: '🧂 Bumbu',
                          color: const Color(0xFF9B59B6),
                          isActive: state.activeShelf == 'rak_bumbu',
                        ),
                        const SizedBox(width: 6),
                        _buildShelfPill(
                          id: 'rak_rumah',
                          label: '🧼 Rumah',
                          color: const Color(0xFFE91E63),
                          isActive: state.activeShelf == 'rak_rumah',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Button "Ke Meja Kasir" (PRD Bab 8: Tombol Kasir selalu tersedia di kanan bawah)
                ElevatedButton.icon(
                  onPressed: onGoToCashier,
                  icon: const Icon(Icons.point_of_sale, size: 22),
                  label: const Text(
                    'Ke Kasir',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF39C12),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelfPill({
    required String id,
    required String label,
    required Color color,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onGoToShelf(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? color : color.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: isActive ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
