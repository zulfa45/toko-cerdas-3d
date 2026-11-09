import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/level_config.dart';
import '../game/game_controller.dart';

class CashierPanelModal extends ConsumerWidget {
  final VoidCallback onCustomerHappy;
  final VoidCallback onCustomerLeave;
  final Function(String sfx) onPlaySfx;

  const CashierPanelModal({
    super.key,
    required this.onCustomerHappy,
    required this.onCustomerLeave,
    required this.onPlaySfx,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final order = state.currentOrder;

    if (!state.isCashierOpen || order == null) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Container(
        width: 720,
        height: 480,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF9F5),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF16A085), width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Bar
            _buildCashierHeader(context, ref, state, order),

            // Content Area based on Step
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStepContent(context, ref, state, order),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashierHeader(
    BuildContext context,
    WidgetRef ref,
    GameState state,
    CustomerOrder order,
  ) {
    String stepTitle = 'Langkah 1: Hitung Total Belanja';
    if (state.cashierStep == CashierStep.calculateChange) {
      stepTitle = 'Langkah 2: Susun Uang Kembalian';
    } else if (state.cashierStep == CashierStep.successFeedback) {
      stepTitle = 'Transaksi Berhasil!';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF16A085),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.point_of_sale, color: Colors.white, size: 26),
          const SizedBox(width: 10),
          Text(
            'Meja Kasir — $stepTitle',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Pembeli: ${order.customerName}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              ref.read(gameControllerProvider.notifier).closeCashierPanel();
            },
            icon: const Icon(Icons.close, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    WidgetRef ref,
    GameState state,
    CustomerOrder order,
  ) {
    switch (state.cashierStep) {
      case CashierStep.calculateTotal:
        return _buildCalculateTotalStep(context, ref, state, order);
      case CashierStep.calculateChange:
        return _buildCalculateChangeStep(context, ref, state, order);
      case CashierStep.successFeedback:
        return _buildSuccessFeedbackStep(context, ref, state, order);
    }
  }

  // --- STEP 1: CALCULATE TOTAL ---
  Widget _buildCalculateTotalStep(
    BuildContext context,
    WidgetRef ref,
    GameState state,
    CustomerOrder order,
  ) {
    final useChoice = state.levelConfig.useMultipleChoiceForTotal;
    final total = order.totalAmount;

    // Generate 3 choices for Day 1-2
    final choices = [total, total + 2000, total - 1000];
    choices.sort();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: Order Item Breakdown Table
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2D9CC), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Barang Belanjaan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const Divider(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: order.items.length,
                      itemBuilder: (ctx, i) {
                        final it = order.items[i];
                        final prod = it.product;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text(prod?.iconEmoji ?? '📦', style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${prod?.name ?? it.productId} (${prod?.unitLabel ?? ''})',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                '${it.quantity} × ${prod?.formattedPrice ?? ''}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Rp${it.subtotal.toString()}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.feedbackHint != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDEBD0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Color(0xFFE67E22), size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              state.feedbackHint!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD35400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Right: Total Input (Multiple Choice or Keypad)
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2D9CC), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'Berapa Total Harganya?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (useChoice) ...[
                    // Multiple Choice Buttons (Day 1-2)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: choices.map((choice) {
                          final isSelected = state.selectedTotalChoice == choice;
                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(gameControllerProvider.notifier).selectTotalChoice(choice);
                                onPlaySfx('item_click');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? const Color(0xFF16A085)
                                    : const Color(0xFFF5EEF8),
                                foregroundColor: isSelected ? Colors.white : const Color(0xFF2C3E50),
                                elevation: isSelected ? 4 : 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: isSelected ? const Color(0xFF16A085) : const Color(0xFFD5D8DC),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Rp${choice.toString()}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ] else ...[
                    // Keypad Input (Day 3-5)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBDC3C7)),
                      ),
                      child: Text(
                        state.enteredTotalKeypad.isEmpty ? 'Rp 0' : 'Rp ${state.enteredTotalKeypad}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF16A085)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: _buildKeypadGrid(ref),
                    ),
                  ],

                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final success = ref.read(gameControllerProvider.notifier).submitTotalAnswer();
                        if (success) {
                          onPlaySfx('kaching');
                        } else {
                          onPlaySfx('retry');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF39C12),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Konfirmasi Total ▶',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadGrid(WidgetRef ref) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '000', '0', 'DEL'];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.1,
        crossAxisSpacing: 6,
        mainAxisSpacing: 4,
      ),
      itemCount: keys.length,
      itemBuilder: (ctx, i) {
        final key = keys[i];
        final isDel = key == 'DEL';
        return ElevatedButton(
          onPressed: () {
            ref.read(gameControllerProvider.notifier).appendKeypad(key);
            onPlaySfx('item_click');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDel ? const Color(0xFFE74C3C) : const Color(0xFFEBF5FB),
            foregroundColor: isDel ? Colors.white : const Color(0xFF2C3E50),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
          ),
          child: Text(
            key,
            style: TextStyle(
              fontSize: key == '000' ? 12 : 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  // --- STEP 2: CALCULATE CHANGE ---
  Widget _buildCalculateChangeStep(
    BuildContext context,
    WidgetRef ref,
    GameState state,
    CustomerOrder order,
  ) {
    final total = order.totalAmount;
    final payment = order.paymentBill;
    final expectedChange = order.expectedChange;
    final currentGiven = state.totalChangeGiven;
    final remaining = expectedChange - currentGiven;

    final rupiahBills = [50000, 20000, 10000, 5000, 2000, 1000];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Left: Payment & Handed Cash Info
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2D9CC), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Uang Pembayaran Pembeli:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),

                  // Customer Bill Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2980B9),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('💵 Uang Pembeli', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        Text('Rp${payment.toString()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Belanja:', style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 13)),
                      Text('Rp${total.toString()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const Divider(height: 12),

                  // Change status
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: remaining == 0
                          ? const Color(0xFFE8F8F5)
                          : const Color(0xFFFEF9E7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: remaining == 0 ? const Color(0xFF27AE60) : const Color(0xFFF39C12),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sudah kamu berikan:', style: TextStyle(fontSize: 12)),
                            Text('Rp${currentGiven.toString()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              remaining >= 0 ? 'Kurang:' : 'Kelebihan:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: remaining == 0 ? const Color(0xFF27AE60) : const Color(0xFFD35400),
                              ),
                            ),
                            Text(
                              'Rp${remaining.abs().toString()}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: remaining == 0 ? const Color(0xFF27AE60) : const Color(0xFFD35400),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (state.feedbackHint != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      state.feedbackHint!,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
                    ),
                  ],

                  const Spacer(),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.read(gameControllerProvider.notifier).removeLastChangeBill();
                          onPlaySfx('item_click');
                        },
                        icon: const Icon(Icons.undo, size: 16),
                        label: const Text('Hapus Lembar', style: TextStyle(fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBDC3C7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(gameControllerProvider.notifier).clearChangeBills();
                          onPlaySfx('item_click');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE74C3C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        child: const Text('Reset', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Right: Rupiah Cash Shelf
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2D9CC), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'Pilih Pecahan Uang Rupiah:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: rupiahBills.length,
                      itemBuilder: (ctx, i) {
                        final bill = rupiahBills[i];
                        final color = _getBillColor(bill);
                        return ElevatedButton(
                          onPressed: () {
                            ref.read(gameControllerProvider.notifier).addChangeBill(bill);
                            onPlaySfx('coin');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                          ),
                          child: Text(
                            'Rp${bill.toString()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final success = ref.read(gameControllerProvider.notifier).submitChangeAnswer();
                        if (success) {
                          onPlaySfx('success');
                          onCustomerHappy();
                        } else {
                          onPlaySfx('retry');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27AE60),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Serahkan Kembalian ▶',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBillColor(int amount) {
    switch (amount) {
      case 50000:
        return const Color(0xFF2980B9); // Blue
      case 20000:
        return const Color(0xFF27AE60); // Green
      case 10000:
        return const Color(0xFF8E44AD); // Purple
      case 5000:
        return const Color(0xFFE67E22); // Orange/Yellowish
      case 2000:
      case 1000:
      default:
        return const Color(0xFF7F8C8D); // Grayish
    }
  }

  // --- STEP 3: SUCCESS FEEDBACK ---
  Widget _buildSuccessFeedbackStep(
    BuildContext context,
    WidgetRef ref,
    GameState state,
    CustomerOrder order,
  ) {
    final isLastCustomer = state.currentOrderIndex >= state.todayOrders.length - 1;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F8F5),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('😊', style: TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${order.customerName}: "Terima kasih, kembaliannya pas!"',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF16A085),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9E7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1C40F)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '+15 Koin Ditambahkan!',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD35400),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 260,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                onCustomerLeave();
                ref.read(gameControllerProvider.notifier).completeCurrentTransaction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A085),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              child: Text(
                isLastCustomer ? 'Selesai Hari Ini 🎉' : 'Pembeli Berikutnya ▶',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
