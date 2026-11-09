class Product {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String unitLabel;
  final int priceIdr;
  final String modelAsset;
  final String shelfId;
  final String iconEmoji;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.unitLabel,
    required this.priceIdr,
    required this.modelAsset,
    required this.shelfId,
    required this.iconEmoji,
  });

  String get formattedPrice {
    final str = priceIdr.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp${buffer.toString().split('').reversed.join()}';
  }
}

class ProductCatalog {
  static const List<Product> initialCatalog = [
    // Sembako Pokok
    Product(
      id: 'beras_1kg',
      name: 'Beras',
      categoryId: 'sembako_pokok',
      categoryName: 'Sembako Pokok',
      unitLabel: '1 kg',
      priceIdr: 12000,
      modelAsset: 'models/beras.glb',
      shelfId: 'rak_sembako',
      iconEmoji: '🌾',
    ),
    Product(
      id: 'minyak_1l',
      name: 'Minyak Goreng',
      categoryId: 'sembako_pokok',
      categoryName: 'Sembako Pokok',
      unitLabel: '1 liter',
      priceIdr: 18000,
      modelAsset: 'models/minyak.glb',
      shelfId: 'rak_sembako',
      iconEmoji: '🌻',
    ),
    Product(
      id: 'telur_1pak',
      name: 'Telur Ayam',
      categoryId: 'sembako_pokok',
      categoryName: 'Sembako Pokok',
      unitLabel: '1 pak isi 6',
      priceIdr: 15000,
      modelAsset: 'models/telur.glb',
      shelfId: 'rak_sembako',
      iconEmoji: '🥚',
    ),
    Product(
      id: 'gula_1kg',
      name: 'Gula Pasir',
      categoryId: 'sembako_pokok',
      categoryName: 'Sembako Pokok',
      unitLabel: '1 kg',
      priceIdr: 14000,
      modelAsset: 'models/gula.glb',
      shelfId: 'rak_sembako',
      iconEmoji: '🧂',
    ),
    Product(
      id: 'terigu_1kg',
      name: 'Tepung Terigu',
      categoryId: 'sembako_pokok',
      categoryName: 'Sembako Pokok',
      unitLabel: '1 kg',
      priceIdr: 11000,
      modelAsset: 'models/terigu.glb',
      shelfId: 'rak_sembako',
      iconEmoji: '🥡',
    ),

    // Makanan Kering
    Product(
      id: 'mie_instan',
      name: 'Mie Instan',
      categoryId: 'makanan_kering',
      categoryName: 'Makanan Kering',
      unitLabel: '1 bungkus',
      priceIdr: 3000,
      modelAsset: 'models/mie.glb',
      shelfId: 'rak_makanan',
      iconEmoji: '🍜',
    ),
    Product(
      id: 'biskuit_pak',
      name: 'Biskuit',
      categoryId: 'makanan_kering',
      categoryName: 'Makanan Kering',
      unitLabel: '1 pak',
      priceIdr: 8000,
      modelAsset: 'models/biskuit.glb',
      shelfId: 'rak_makanan',
      iconEmoji: '🍪',
    ),
    Product(
      id: 'roti_tawar',
      name: 'Roti Tawar',
      categoryId: 'makanan_kering',
      categoryName: 'Makanan Kering',
      unitLabel: '1 bungkus',
      priceIdr: 13000,
      modelAsset: 'models/roti.glb',
      shelfId: 'rak_makanan',
      iconEmoji: '🍞',
    ),

    // Minuman
    Product(
      id: 'susu_uht',
      name: 'Susu UHT',
      categoryId: 'minuman',
      categoryName: 'Minuman',
      unitLabel: '1 kotak',
      priceIdr: 6000,
      modelAsset: 'models/susu.glb',
      shelfId: 'rak_minuman',
      iconEmoji: '🥛',
    ),
    Product(
      id: 'teh_celup',
      name: 'Teh Celup',
      categoryId: 'minuman',
      categoryName: 'Minuman',
      unitLabel: '1 kotak',
      priceIdr: 7000,
      modelAsset: 'models/teh.glb',
      shelfId: 'rak_minuman',
      iconEmoji: '🍵',
    ),
    Product(
      id: 'kopi_sachet',
      name: 'Kopi Sachet',
      categoryId: 'minuman',
      categoryName: 'Minuman',
      unitLabel: '1 pak',
      priceIdr: 10000,
      modelAsset: 'models/kopi.glb',
      shelfId: 'rak_minuman',
      iconEmoji: '☕',
    ),
    Product(
      id: 'air_mineral',
      name: 'Air Mineral',
      categoryId: 'minuman',
      categoryName: 'Minuman',
      unitLabel: '1 botol',
      priceIdr: 4000,
      modelAsset: 'models/air.glb',
      shelfId: 'rak_minuman',
      iconEmoji: '💧',
    ),

    // Bumbu Dapur
    Product(
      id: 'garam_dapur',
      name: 'Garam Dapur',
      categoryId: 'bumbu_dapur',
      categoryName: 'Bumbu Dapur',
      unitLabel: '1 bungkus',
      priceIdr: 2000,
      modelAsset: 'models/garam.glb',
      shelfId: 'rak_bumbu',
      iconEmoji: '🧂',
    ),
    Product(
      id: 'kecap_manis',
      name: 'Kecap Manis',
      categoryId: 'bumbu_dapur',
      categoryName: 'Bumbu Dapur',
      unitLabel: '1 botol',
      priceIdr: 9000,
      modelAsset: 'models/kecap.glb',
      shelfId: 'rak_bumbu',
      iconEmoji: '🍶',
    ),
    Product(
      id: 'saus_sambal',
      name: 'Saus Sambal',
      categoryId: 'bumbu_dapur',
      categoryName: 'Bumbu Dapur',
      unitLabel: '1 botol',
      priceIdr: 8000,
      modelAsset: 'models/saus.glb',
      shelfId: 'rak_bumbu',
      iconEmoji: '🌶️',
    ),

    // Kebutuhan Rumah
    Product(
      id: 'sabun_mandi',
      name: 'Sabun Mandi',
      categoryId: 'kebutuhan_rumah',
      categoryName: 'Kebutuhan Rumah',
      unitLabel: '1 batang',
      priceIdr: 5000,
      modelAsset: 'models/sabun.glb',
      shelfId: 'rak_rumah',
      iconEmoji: '🧼',
    ),
    Product(
      id: 'pasta_gigi',
      name: 'Pasta Gigi',
      categoryId: 'kebutuhan_rumah',
      categoryName: 'Kebutuhan Rumah',
      unitLabel: '1 tube',
      priceIdr: 9000,
      modelAsset: 'models/pastagigi.glb',
      shelfId: 'rak_rumah',
      iconEmoji: '🪥',
    ),
    Product(
      id: 'deterjen',
      name: 'Deterjen',
      categoryId: 'kebutuhan_rumah',
      categoryName: 'Kebutuhan Rumah',
      unitLabel: '1 bungkus',
      priceIdr: 12000,
      modelAsset: 'models/deterjen.glb',
      shelfId: 'rak_rumah',
      iconEmoji: '🧺',
    ),
  ];

  static Product? findById(String id) {
    try {
      return initialCatalog.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
