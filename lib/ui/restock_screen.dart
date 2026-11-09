import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_catalog.dart';
import '../game/game_controller.dart';

class RestockScreen extends StatefulWidget {
  const RestockScreen({super.key});

  @override
  State<RestockScreen> createState() => _RestockScreenState();
}

class _RestockScreenState extends State<RestockScreen> {
  final Set<String> _selectedProductIds = {};

  @override
  Widget build(BuildContext context) {
    final products = ProductCatalog.initialCatalog;

    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFD7EDF7),
          body: SafeArea(
            child: Center(
              child: Container(
                width: 720,
                height: 520,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF16A085), width: 3),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 8)),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F8F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.inventory_2, color: Color(0xFF16A085), size: 28),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fase Isi Stok Rak Sembako',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                            ),
                            Text(
                              'Pilih 2 barang kebutuhan toko untuk diisi kembali (${_selectedProductIds.length}/2 Dipilih)',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF7F8C8D), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.home);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Product Cards Grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: products.length,
                        itemBuilder: (ctx, i) {
                          final prod = products[i];
                          final isSelected = _selectedProductIds.contains(prod.id);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedProductIds.remove(prod.id);
                                } else {
                                  if (_selectedProductIds.length < 2) {
                                    _selectedProductIds.add(prod.id);
                                  }
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFE8F8F5) : const Color(0xFFFBF9F5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF16A085) : const Color(0xFFE2D9CC),
                                  width: isSelected ? 2.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(prod.iconEmoji, style: const TextStyle(fontSize: 28)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          prod.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          prod.unitLabel,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF7F8C8D)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                    color: isSelected ? const Color(0xFF16A085) : const Color(0xFFBDC3C7),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Bottom Confirm Button
                    SizedBox(
                      width: 280,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _selectedProductIds.length == 2
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Rak berhasil diisi kembali! Stok toko penuh.')),
                                );
                                ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.home);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A085),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 3,
                        ),
                        child: Text(
                          _selectedProductIds.length == 2 ? 'Selesai Isi Stok ▶' : 'Pilih 2 Barang',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
