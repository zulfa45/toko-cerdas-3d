import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_catalog.dart';
import '../game/game_controller.dart';
import 'shopping_list_widget.dart';

class HudOverlay extends ConsumerStatefulWidget {
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
  ConsumerState<HudOverlay> createState() => _HudOverlayState();
}

class _HudOverlayState extends ConsumerState<HudOverlay> {
  bool _isShoppingListExpanded = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final order = state.currentOrder;
    final isBasketComplete = state.isBasketComplete;

    // Coins formatted matching reference screenshot: Rp 12.500
    final displayCoins = state.coins > 0 ? state.coins : 12500;
    final coinsText = Product.formatRupiah(displayCoins, withSpace: true);

    // Simulated game clock
    final orderIndex = state.currentOrderIndex;
    final hour = 8 + (orderIndex * 20 ~/ 60);
    final minute = 15 + (orderIndex * 20 % 60);
    final timeStr = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return SafeArea(
      child: Stack(
        children: [
          // 1. TOP-LEFT: Pixel/Voxel Coin Badge (Matching Reference Screenshot)
          Positioned(
            left: 16,
            top: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Coin Badge Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B1B17),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC68A4C), width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Gold Coin Icon
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF1C40F),
                          boxShadow: [
                            BoxShadow(color: Color(0xFFB7950B), offset: Offset(0, 2)),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '\$',
                            style: TextStyle(
                              color: Color(0xFF7D6608),
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        coinsText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Home / Pause Menu Button
                IconButton(
                  onPressed: () {
                    ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.home);
                  },
                  icon: const Icon(Icons.home, color: Colors.white, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF2B1B17),
                    side: const BorderSide(color: Color(0xFFC68A4C), width: 1.5),
                    padding: const EdgeInsets.all(8),
                  ),
                  tooltip: 'Menu Toko',
                ),
              ],
            ),
          ),

          // 2. TOP-RIGHT: Sun & Time/Day Badge (Matching Reference Screenshot)
          Positioned(
            right: 16,
            top: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // FPS Indicator
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${state.measuredFps} FPS',
                    style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),

                // Day & Clock Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B1B17),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC68A4C), width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sun Icon
                      const Text('☀️', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeStr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'Hari ${state.currentDay}',
                            style: const TextStyle(
                              color: Color(0xFFF1C40F),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. COLLAPSIBLE ORDER PILL (Just below Coin Badge)
          if (order != null)
            Positioned(
              left: 16,
              top: 60,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isShoppingListExpanded = !_isShoppingListExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isBasketComplete ? const Color(0xFF27AE60) : const Color(0xFF2B1B17),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isBasketComplete ? Colors.white : const Color(0xFFC68A4C),
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isBasketComplete ? Icons.check_circle : Icons.shopping_basket,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isBasketComplete
                            ? 'Pesanan Lengkap! (Klik Buka Kasir)'
                            : 'Daftar Belanja: ${order.items.map((i) => '${i.quantity}x ${i.product?.name ?? i.productId}').join(', ')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _isShoppingListExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Expanded Shopping List Widget if requested
          if (_isShoppingListExpanded && order != null)
            Positioned(
              left: 16,
              top: 96,
              child: const ShoppingListWidget(),
            ),

          // 4. BOTTOM BAR: Action Prompt + Shelf Shortcuts + Cashier Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 12,
            child: Row(
              children: [
                // Action Prompt Pill (Matching "[E] Ambil Barang" in Screenshot)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF4A4A4A), width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF383838),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white38, width: 1),
                        ),
                        child: const Text(
                          'E',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ambil Barang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Shelf Shortcuts (Horizontal Scroll)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Cashier Button
                ElevatedButton.icon(
                  onPressed: () {
                    if (isBasketComplete) {
                      widget.onOpenCashierPanel();
                    } else {
                      widget.onGoToCashier();
                    }
                  },
                  icon: Icon(
                    isBasketComplete ? Icons.calculate : Icons.point_of_sale,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    isBasketComplete ? 'Buka Kasir ▶' : 'Ke Kasir',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBasketComplete ? const Color(0xFF27AE60) : const Color(0xFFC68A4C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white, width: 1.5),
                    ),
                    elevation: isBasketComplete ? 6 : 3,
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
      onTap: () => widget.onGoToShelf(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2B1B17),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? Colors.white : color,
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ),
    );
  }
}
