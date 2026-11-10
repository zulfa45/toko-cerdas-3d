import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/level_config.dart';
import '../data/product_catalog.dart';
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

    final size = MediaQuery.of(context).size;
    // Adapt dynamically to any landscape screen height (320px - 480px)
    final modalWidth = min(740.0, size.width * 0.95);
    final modalHeight = min(480.0, max(300.0, size.height * 0.94));

    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Container(
        width: modalWidth,
        height: modalHeight,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF381F15),
          borderRadius: BorderRadius.circular(22),
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
          children: [
            // Top Bar
            _buildCashierHeader(context, ref, state, order),

            // Content Area based on Step
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF24140D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(bottom: BorderSide(color: Color(0xFF8D4F27), width: 1.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.point_of_sale, color: Color(0xFFF1C40F), size: 22),
          const SizedBox(width: 8),
          Text(
            'Meja Kasir — $stepTitle',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF4A2818),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC68A4C), width: 1),
            ),
            child: Text(
              'Pembeli: ${order.customerName}',
              style: const TextStyle(
                color: Color(0xFFF1C40F),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              ref.read(gameControllerProvider.notifier).closeCashierPanel();
            },
            icon: const Icon(Icons.close, color: Colors.white70, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Tutup Kasir',
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

    final choices = [total, total + 2000, max(1000, total - 1000)];
    choices.sort();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: Order Item Breakdown Table
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF24140D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8D4F27), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Barang Belanjaan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFFF1C40F),
                    ),
                  ),
                  const Divider(height: 10, color: Colors.white24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: order.items.length,
                      itemBuilder: (ctx, i) {
                        final it = order.items[i];
                        final prod = it.product;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(prod?.iconEmoji ?? '📦', style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${prod?.name ?? it.productId} (${prod?.unitLabel ?? ''})',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${it.quantity} × ${prod?.formattedPrice ?? ''}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFFD7CCC8)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                Product.formatRupiah(it.subtotal),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF1C40F)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.feedbackHint != null) ...[
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A2818),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE67E22)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Color(0xFFF1C40F), size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              state.feedbackHint!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF1C40F),
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
          const SizedBox(width: 10),

          // Right: Total Input (Multiple Choice or Keypad)
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF24140D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8D4F27), width: 1.2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Berapa Total Harganya?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  if (useChoice) ...[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: choices.map((choice) {
                          final isSelected = state.selectedTotalChoice == choice;
                          return SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(gameControllerProvider.notifier).selectTotalChoice(choice);
                                onPlaySfx('item_click');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected ? const Color(0xFF27AE60) : const Color(0xFF381F15),
                                foregroundColor: isSelected ? Colors.white : const Color(0xFFF1C40F),
                                elevation: isSelected ? 4 : 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected ? Colors.white : const Color(0xFFC68A4C),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                Product.formatRupiah(choice, withSpace: true),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E100B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFC68A4C)),
                      ),
                      child: Text(
                        state.enteredTotalKeypad.isEmpty ? 'Rp 0' : 'Rp ${state.enteredTotalKeypad}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF1C40F)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: _buildKeypadGrid(ref),
                    ),
                  ],

                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
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
                        backgroundColor: const Color(0xFF27AE60),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Konfirmasi Total ▶',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
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
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.3,
        crossAxisSpacing: 5,
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
            backgroundColor: isDel ? const Color(0xFFC0392B) : const Color(0xFF381F15),
            foregroundColor: isDel ? Colors.white : Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: isDel ? Colors.white30 : const Color(0xFF8D4F27), width: 1),
            ),
            elevation: 1,
          ),
          child: Text(
            key,
            style: TextStyle(
              fontSize: key == '000' ? 11 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  // --- STEP 2: CALCULATE CHANGE (100% VISIBLE & TAPPABLE ON ANY SCREEN HEIGHT) ---
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

    // Standard Indonesian Rupiah Bills (50k, 20k, 10k, 5k, 2k, 1k)
    final rupiahBills = [50000, 20000, 10000, 5000, 2000, 1000];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: Payment & Handed Cash Status Info
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF24140D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8D4F27), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Payment Bill Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('💵 Uang Pembeli', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(Product.formatRupiah(payment, withSpace: true), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Belanja:', style: TextStyle(color: Color(0xFFD7CCC8), fontSize: 12)),
                      Text(Product.formatRupiah(total, withSpace: true), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    ],
                  ),
                  const Divider(height: 10, color: Colors.white24),

                  // Change status box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: remaining == 0 ? const Color(0xFF1B4332) : const Color(0xFF4A2818),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: remaining == 0 ? const Color(0xFF27AE60) : const Color(0xFFF1C40F),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sudah diberikan:', style: TextStyle(fontSize: 11, color: Colors.white70)),
                            Text(
                              Product.formatRupiah(currentGiven, withSpace: true),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              remaining == 0 ? 'Kembalian:' : (remaining > 0 ? 'Masih Kurang:' : 'Kelebihan:'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: remaining == 0 ? const Color(0xFF2ECC71) : const Color(0xFFF1C40F),
                              ),
                            ),
                            Text(
                              remaining == 0 ? 'PAS! ✅' : Product.formatRupiah(remaining.abs(), withSpace: true),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: remaining == 0 ? const Color(0xFF2ECC71) : const Color(0xFFF1C40F),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Selected Bills Chips Preview
                  const SizedBox(height: 6),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E100B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: state.selectedChangeBills.isEmpty
                          ? const Center(
                              child: Text(
                                'Ketuk uang pecahan di sebelah kanan ➡️',
                                style: TextStyle(fontSize: 10, color: Colors.white38),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: state.selectedChangeBills.map((b) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getBillColor(b),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.white30),
                                    ),
                                    child: Text(
                                      '+${Product.formatRupiah(b, withSpace: false).replaceFirst('Rp', '')}',
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                  ),

                  if (state.feedbackHint != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        state.feedbackHint!,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFE74C3C)),
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(gameControllerProvider.notifier).removeLastChangeBill();
                            onPlaySfx('item_click');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFC68A4C),
                            side: const BorderSide(color: Color(0xFFC68A4C)),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Hapus 1', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref.read(gameControllerProvider.notifier).clearChangeBills();
                            onPlaySfx('item_click');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE74C3C),
                            side: const BorderSide(color: Color(0xFFE74C3C)),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Reset', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Right: Rupiah Cash Shelf (3 COLUMNS: ONLY 2 COMPACT ROWS! 100% VISIBLE & TAPPABLE!)
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF24140D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8D4F27), width: 1.2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Pilih Pecahan Uang Rupiah:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFF1C40F)),
                  ),
                  const SizedBox(height: 6),

                  // 3 COLUMNS GRID = ONLY 2 ROWS (50k, 20k, 10k on row 1; 5k, 2k, 1k on row 2)
                  Expanded(
                    child: GridView.builder(
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
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
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.white30, width: 1),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            Product.formatRupiah(bill, withSpace: true),
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 6),

                  // SUBMIT CHANGE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 44,
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
                        backgroundColor: remaining == 0 ? const Color(0xFF27AE60) : const Color(0xFFE67E22),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(remaining == 0 ? Icons.check_circle : Icons.send, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            remaining == 0 ? 'Serahkan Kembalian Pas ▶' : 'Coba Serahkan Kembalian ▶',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
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
    );
  }

  Color _getBillColor(int amount) {
    switch (amount) {
      case 50000:
        return const Color(0xFF1976D2); // Indonesian Rp 50.000 Blue
      case 20000:
        return const Color(0xFF2E7D32); // Indonesian Rp 20.000 Green
      case 10000:
        return const Color(0xFF7B1FA2); // Indonesian Rp 10.000 Purple
      case 5000:
        return const Color(0xFFD84315); // Indonesian Rp 5.000 Brown-Orange
      case 2000:
        return const Color(0xFF455A64); // Indonesian Rp 2.000 Slate Gray
      case 1000:
      default:
        return const Color(0xFF616161); // Indonesian Rp 1.000 Bronze Olive
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFF1B4332),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('😊', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${order.customerName}: "Terima kasih, kembaliannya pas!"',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFFF1C40F),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4A2818),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1C40F)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🪙', style: TextStyle(fontSize: 18)),
                SizedBox(width: 6),
                Text(
                  '+15 Koin Ditambahkan!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF1C40F),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 260,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                onCustomerLeave();
                ref.read(gameControllerProvider.notifier).completeCurrentTransaction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Colors.white, width: 1.5),
                ),
                elevation: 4,
              ),
              child: Text(
                isLastCustomer ? 'Selesai Hari Ini 🎉' : 'Pembeli Berikutnya ▶',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
