import 'package:flutter/material.dart';
import '../data/product_catalog.dart';

class ProductDetailDialog extends StatelessWidget {
  final Product product;
  final VoidCallback onClose;

  const ProductDetailDialog({
    super.key,
    required this.product,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 12,
      backgroundColor: Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Category Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A085).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    product.categoryName,
                    style: const TextStyle(
                      color: Color(0xFF16A085),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Product Icon (Large & Friendly)
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F7F3),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE0D8CB), width: 3),
              ),
              alignment: Alignment.center,
              child: Text(
                product.iconEmoji,
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 16),

            // Product Name (Min 18px logical size per PRD)
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Unit Label
            Text(
              'Satuan: ${product.unitLabel}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7F8C8D),
              ),
            ),
            const SizedBox(height: 16),

            // Price in Integer Rupiah
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1C40F), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'Harga Barang',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7F8C8D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.formattedPrice,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD35400),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Positive learning feedback
            const Text(
              '✓ Barang terdeteksi lewat Raycast 3D di Rak Toko!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF27AE60),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Large Action Button (Min 56px height per PRD)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A085),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Kembali ke Toko',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
