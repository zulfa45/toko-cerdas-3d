import 'dart:math';
import 'product_catalog.dart';

class OrderItem {
  final String productId;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.quantity,
  });

  Product? get product => ProductCatalog.findById(productId);
  int get subtotal => (product?.priceIdr ?? 0) * quantity;
}

class CustomerOrder {
  final String customerName;
  final String appearanceId;
  final List<OrderItem> items;
  final int paymentBill;

  const CustomerOrder({
    required this.customerName,
    required this.appearanceId,
    required this.items,
    required this.paymentBill,
  });

  int get totalAmount {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  int get expectedChange => paymentBill - totalAmount;
}

class LevelConfig {
  final int day;
  final String title;
  final String skillTrained;
  final String mathTip;
  final int customerCount;
  final int maxItemsPerOrder;
  final int maxQuantityPerItem;
  final List<int> availablePaymentBills;
  final bool showShelfGuideArrow;
  final bool useMultipleChoiceForTotal; // Hari 1-2: pilihan ganda, Hari 3+: keypad angka

  const LevelConfig({
    required this.day,
    required this.title,
    required this.skillTrained,
    required this.mathTip,
    required this.customerCount,
    required this.maxItemsPerOrder,
    required this.maxQuantityPerItem,
    required this.availablePaymentBills,
    required this.showShelfGuideArrow,
    required this.useMultipleChoiceForTotal,
  });

  static const List<LevelConfig> allLevels = [
    // Hari 1: Mengenal rak dan mengambil barang (1 barang, 3 pembeli)
    LevelConfig(
      day: 1,
      title: 'Hari 1 — Penjaga Toko Baru',
      skillTrained: 'Mengenal letak rak dan mengambil barang belanjaan',
      mathTip: 'Perhatikan nama barang dan ikuti panah penunjuk lantai ke rak yang benar!',
      customerCount: 3,
      maxItemsPerOrder: 1,
      maxQuantityPerItem: 1,
      availablePaymentBills: [20000],
      showShelfGuideArrow: true,
      useMultipleChoiceForTotal: true,
    ),

    // Hari 2: Menjumlahkan 2 harga (1-2 barang, 4 pembeli)
    LevelConfig(
      day: 2,
      title: 'Hari 2 — Belajar Penjumlahan Harga',
      skillTrained: 'Menjumlahkan 2 barang dengan harga ribuan',
      mathTip: 'Jumlahkan angka ribuan dari depan: Rp12.000 + Rp3.000 = Rp15.000.',
      customerCount: 4,
      maxItemsPerOrder: 2,
      maxQuantityPerItem: 1,
      availablePaymentBills: [20000, 50000],
      showShelfGuideArrow: true,
      useMultipleChoiceForTotal: true,
    ),

    // Hari 3: Kembalian dari pecahan campuran (2-3 barang, 4 pembeli, keypad angka)
    LevelConfig(
      day: 3,
      title: 'Hari 3 — Susun Kembalian Pas',
      skillTrained: 'Menghitung kembalian dan memilih lembaran Rupiah yang tepat',
      mathTip: 'Hitung kembalian dengan cara susun ke atas: harga Rp35.000 dibayar Rp50.000, kembalian Rp15.000.',
      customerCount: 4,
      maxItemsPerOrder: 3,
      maxQuantityPerItem: 1,
      availablePaymentBills: [50000],
      showShelfGuideArrow: true,
      useMultipleChoiceForTotal: false,
    ),

    // Hari 4: Perkalian satuan sederhana (3-4 barang, ada jumlah ×2/×3, 5 pembeli)
    LevelConfig(
      day: 4,
      title: 'Hari 4 — Pesanan Banyak & Perkalian',
      skillTrained: 'Menghitung harga barang berjumlah lebih dari 1 (misal 3 × mie)',
      mathTip: 'Jika mie instan Rp3.000 dan dibeli 3 buah: 3 × Rp3.000 = Rp9.000.',
      customerCount: 5,
      maxItemsPerOrder: 4,
      maxQuantityPerItem: 3,
      availablePaymentBills: [50000, 100000],
      showShelfGuideArrow: true,
      useMultipleChoiceForTotal: false,
    ),

    // Hari 5: Tantangan Toko Ramai (4-6 barang, tanpa panah, 5 pembeli)
    LevelConfig(
      day: 5,
      title: 'Hari 5 — Ahli Kasir Toko Cerdas',
      skillTrained: 'Melayani pesanan campuran mandiri tanpa bantuan panah penunjuk',
      mathTip: 'Keren! Kamu sudah hafal semua letak rak sembako seperti penjaga toko sungguhan!',
      customerCount: 5,
      maxItemsPerOrder: 5,
      maxQuantityPerItem: 3,
      availablePaymentBills: [100000],
      showShelfGuideArrow: false,
      useMultipleChoiceForTotal: false,
    ),
  ];

  static LevelConfig getByDay(int day) {
    if (day < 1) return allLevels.first;
    if (day > allLevels.length) return allLevels.last;
    return allLevels[day - 1];
  }

  // Generate orders for a specific day
  static List<CustomerOrder> generateOrdersForDay(int day, [int? seed]) {
    final config = getByDay(day);
    final random = Random(seed ?? (day * 1337));

    final customerNames = [
      'Bu Sari', 'Pak Budi', 'Kak Rina', 'Bu Dewi', 'Pak Joko',
      'Kak Dimas', 'Bu Ani', 'Pak Hendra', 'Kak Nia', 'Pak Wawan',
      'Bu Endang', 'Kak Ilham'
    ];

    final orders = <CustomerOrder>[];
    final allProducts = ProductCatalog.initialCatalog;

    for (int i = 0; i < config.customerCount; i++) {
      final name = customerNames[i % customerNames.length];
      final appearanceId = 'customer_${(i % 12) + 1}';

      // Pick random distinct products
      final numItems = config.day == 1
          ? 1
          : 1 + random.nextInt(config.maxItemsPerOrder);

      final shuffled = List<Product>.from(allProducts)..shuffle(random);
      final selectedProducts = shuffled.take(numItems).toList();

      final orderItems = <OrderItem>[];
      int total = 0;

      for (final prod in selectedProducts) {
        int qty = 1;
        if (config.maxQuantityPerItem > 1 && config.day >= 4) {
          qty = 1 + random.nextInt(config.maxQuantityPerItem);
        }
        orderItems.add(OrderItem(productId: prod.id, quantity: qty));
        total += prod.priceIdr * qty;
      }

      // Determine payment bill greater than or equal to total
      final possibleBills = [20000, 50000, 100000];
      int paymentBill = 20000;
      for (final bill in possibleBills) {
        if (bill >= total) {
          paymentBill = bill;
          break;
        }
        paymentBill = 100000;
      }
      // If day specifies specific payment bills
      for (final preferred in config.availablePaymentBills) {
        if (preferred >= total) {
          paymentBill = preferred;
          break;
        }
      }
      if (paymentBill < total) {
        paymentBill = 100000;
      }

      orders.add(CustomerOrder(
        customerName: name,
        appearanceId: appearanceId,
        items: orderItems,
        paymentBill: paymentBill,
      ));
    }

    return orders;
  }
}
