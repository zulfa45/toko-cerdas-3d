import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_controller.dart';

class ShoppingListWidget extends ConsumerWidget {
  const ShoppingListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final order = state.currentOrder;

    if (order == null) return const SizedBox.shrink();

    final isComplete = state.isBasketComplete;

    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      margin: const EdgeInsets.only(top: 60, left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isComplete ? const Color(0xFF27AE60) : const Color(0xFF16A085),
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Customer Name & Order Progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isComplete ? const Color(0xFF27AE60) : const Color(0xFF16A085),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Pesanan ${order.customerName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${state.currentOrderIndex + 1}/${state.todayOrders.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of Items
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: order.items.map((item) {
                final collected = state.basket[item.productId] ?? 0;
                final isDone = collected >= item.quantity;
                final product = item.product;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isDone ? const Color(0xFF27AE60) : const Color(0xFFBDC3C7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product?.iconEmoji ?? '📦',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${product?.name ?? item.productId} (${product?.unitLabel ?? ''})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDone ? const Color(0xFF7F8C8D) : const Color(0xFF2C3E50),
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDone
                              ? const Color(0xFF27AE60).withValues(alpha: 0.15)
                              : const Color(0xFFF39C12).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$collected/${item.quantity}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isDone ? const Color(0xFF27AE60) : const Color(0xFFD35400),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          if (isComplete)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              color: const Color(0xFFE8F8F5),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.thumb_up, color: Color(0xFF27AE60), size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Lengkap! Ayo ke Meja Kasir',
                    style: TextStyle(
                      color: Color(0xFF27AE60),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
