import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_controller.dart';
import 'shopping_list_widget.dart';

class HudOverlay extends ConsumerWidget {
  final VoidCallback onGoToCashier;
  final Function(String shelfId) onGoToShelf;
  final Function(String mode) onToggleMode;
  final VoidCallback onOpenCashierPanel;

  const HudOverlay({
    super.key,
    required this.onGoToCashier,
    required this.onGoToShelf,
    required this.onToggleMode,
    required this.onOpenCashierPanel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final order = state.currentOrder;
    final isBasketComplete = state.isBasketComplete;

    return SafeArea(
      child: Stack(
        children: [
          // Left: Shopping List Widget
          const Positioned(
            left: 0,
            top: 0,
            child: ShoppingListWidget(),
          ),

          // Main Column for Top and Bottom Bars
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top HUD Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Home Button
                    IconButton(
                      onPressed: () {
                        ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.home);
                      },
                      icon: const Icon(Icons.home, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF16A085),
                        elevation: 4,
                      ),
                      tooltip: 'Menu Utama',
                    ),
                    const SizedBox(width: 8),

                    // Shop Name & Day Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A085),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🏪 ${state.shopName} — Hari ${state.currentDay}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Live FPS Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: state.measuredFps >= 30
                            ? const Color(0xFF27AE60)
                            : const Color(0xFFE67E22),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.speed, color: Colors.white, size: 15),
                          const SizedBox(width: 4),
                          Text(
                            '${state.measuredFps} FPS',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Mode Selector Toggle
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
                            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
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
                              size: 15,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              state.navigationMode == 'TAP_AND_WALK' ? 'Mode Ketuk' : 'Mode Bebas',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Active Customer Speech Bubble if in store
              if (order != null && state.customerState == 'ARRIVED')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF16A085), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFF39C12),
                            radius: 18,
                            child: const Text('😊', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  order.customerName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF16A085)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Halo! Saya ingin membeli ${order.items.map((it) => '${it.product?.name ?? it.productId} (${it.quantity})').join(', ')} ya.',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF2C3E50), fontWeight: FontWeight.w600),
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

              // Bottom Bar: Shelf Shortcuts & Cashier Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: Row(
                  children: [
                    // Shelf Jump Shortcuts
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

                    // Cashier Button
                    ElevatedButton.icon(
                      onPressed: () {
                        if (isBasketComplete) {
                          onOpenCashierPanel();
                        } else {
                          onGoToCashier();
                        }
                      },
                      icon: Icon(
                        isBasketComplete ? Icons.calculate : Icons.point_of_sale,
                        size: 22,
                      ),
                      label: Text(
                        isBasketComplete ? 'Buka Kasir ▶' : 'Ke Kasir',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBasketComplete ? const Color(0xFF27AE60) : const Color(0xFFF39C12),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: isBasketComplete ? 6 : 3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}
