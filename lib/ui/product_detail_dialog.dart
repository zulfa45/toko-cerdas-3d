import 'package:flutter/material.dart';
import '../data/product_catalog.dart';

class ProductDetailDialog extends StatelessWidget {
  final Product product;
  final VoidCallback onClose;
  final VoidCallback onAddToBasket;
  final bool isNeededInOrder;

  const ProductDetailDialog({
    super.key,
    required this.product,
    required this.onClose,
    required this.onAddToBasket,
    this.isNeededInOrder = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isLandscape ? 620 : 400,
          maxHeight: screenSize.height * 0.90,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: isLandscape ? _buildLandscapeLayout(context) : _buildPortraitLayout(context),
        ),
      ),
    );
  }

  // Optimized for horizontal / landscape gaming screens
  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Visual Icon & Price Card
        Container(
          width: 190,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF9F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2D9CC), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Emoji in Circle
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF16A085).withValues(alpha: 0.3), width: 3),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  product.iconEmoji,
                  style: const TextStyle(fontSize: 42),
                ),
              ),
              const SizedBox(height: 10),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A085).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product.categoryName,
                  style: const TextStyle(
                    color: Color(0xFF16A085),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),

              // Price Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1C40F)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Harga Satuan',
                      style: TextStyle(fontSize: 11, color: Color(0xFF7F8C8D), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD35400),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Right Column: Details, Status, & Big Touch-Friendly Action Buttons
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Product Name & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        Text(
                          'Takaran / Satuan: ${product.unitLabel}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close_rounded, size: 26, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Order Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isNeededInOrder
                      ? const Color(0xFFE8F8F5)
                      : const Color(0xFFF5EEF8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isNeededInOrder ? const Color(0xFF27AE60) : const Color(0xFFBDC3C7),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isNeededInOrder ? Icons.check_circle : Icons.info_outline,
                      color: isNeededInOrder ? const Color(0xFF27AE60) : const Color(0xFF7F8C8D),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isNeededInOrder
                            ? 'Barang ini ada di daftar belanja pembeli!'
                            : 'Barang ini tidak diminta pembeli saat ini.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isNeededInOrder ? const Color(0xFF27AE60) : const Color(0xFF7F8C8D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Action Buttons Row (Guaranteed fully on-screen!)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: onClose,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          side: const BorderSide(color: Color(0xFFBDC3C7)),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF7F8C8D)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          onAddToBasket();
                          onClose();
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 20),
                        label: Text(
                          isNeededInOrder ? 'Ambil Barang 🛒' : 'Bukan Pesanan',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isNeededInOrder ? const Color(0xFF16A085) : const Color(0xFF95A5A6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: isNeededInOrder ? 4 : 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Portrait fallback (also compact & scrollable)
  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF16A085).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product.categoryName,
                style: const TextStyle(color: Color(0xFF16A085), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded, size: 24, color: Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Text(product.iconEmoji, style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 6),

        Text(
          product.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
        ),
        Text('Satuan: ${product.unitLabel}', style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D))),
        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1C40F)),
          ),
          child: Column(
            children: [
              const Text('Harga Barang', style: TextStyle(fontSize: 11, color: Color(0xFF7F8C8D))),
              Text(
                product.formattedPrice,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFD35400)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onClose,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  onAddToBasket();
                  onClose();
                },
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: Text(isNeededInOrder ? 'Ambil 🛒' : 'Bukan Pesanan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNeededInOrder ? const Color(0xFF16A085) : const Color(0xFF95A5A6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
