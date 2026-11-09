import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_cerdas/data/product_catalog.dart';
import 'package:toko_cerdas/game/game_controller.dart';
import 'package:toko_cerdas/ui/hud_overlay.dart';
import 'package:toko_cerdas/ui/product_detail_dialog.dart';

void main() {
  group('ProductCatalog Tests', () {
    test('Catalog contains 18 initial products across 5 categories', () {
      expect(ProductCatalog.initialCatalog.length, 18);
    });

    test('Beras 1kg data conforms to PRD specifications', () {
      final beras = ProductCatalog.findById('beras_1kg');
      expect(beras, isNotNull);
      expect(beras!.name, 'Beras');
      expect(beras.categoryId, 'sembako_pokok');
      expect(beras.unitLabel, '1 kg');
      expect(beras.priceIdr, 12000);
      expect(beras.formattedPrice, 'Rp12.000');
    });

    test('Minyak Goreng 1l data conforms to PRD specifications', () {
      final minyak = ProductCatalog.findById('minyak_1l');
      expect(minyak, isNotNull);
      expect(minyak!.name, 'Minyak Goreng');
      expect(minyak.priceIdr, 18000);
      expect(minyak.formattedPrice, 'Rp18.000');
    });

    test('Telur Ayam 1pak data conforms to PRD specifications', () {
      final telur = ProductCatalog.findById('telur_1pak');
      expect(telur, isNotNull);
      expect(telur!.name, 'Telur Ayam');
      expect(telur.priceIdr, 15000);
      expect(telur.formattedPrice, 'Rp15.000');
    });
  });

  group('GameController & State Management Tests', () {
    test('Initial state defaults to TAP_AND_WALK mode and 60 FPS', () {
      final container = ProviderContainer();
      final state = container.read(gameControllerProvider);

      expect(state.navigationMode, 'TAP_AND_WALK');
      expect(state.measuredFps, 60);
      expect(state.isSceneReady, isFalse);
      expect(state.customerState, 'WALKING_IN');
      expect(state.customerName, 'Bu Sari');
    });

    test('Process 3D message for raycast product_tapped updates inspectedProduct', () {
      final container = ProviderContainer();
      final controller = container.read(gameControllerProvider.notifier);

      controller.process3DMessage(
        '{"type":"product_tapped","productId":"beras_1kg","name":"Beras","priceIdr":12000}',
      );

      final state = container.read(gameControllerProvider);
      expect(state.inspectedProduct, isNotNull);
      expect(state.inspectedProduct!.id, 'beras_1kg');
      expect(state.inspectedProduct!.priceIdr, 12000);
    });

    test('Process 3D message for customer_arrived updates customer state', () {
      final container = ProviderContainer();
      final controller = container.read(gameControllerProvider.notifier);

      controller.process3DMessage(
        '{"type":"customer_arrived","name":"Bu Sari","speech":"Halo toko!"}',
      );

      final state = container.read(gameControllerProvider);
      expect(state.customerState, 'ARRIVED');
      expect(state.customerName, 'Bu Sari');
      expect(state.customerSpeech, 'Halo toko!');
    });

    test('Mode switch to FREE_WALK works', () {
      final container = ProviderContainer();
      final controller = container.read(gameControllerProvider.notifier);

      controller.setNavigationMode('FREE_WALK');
      expect(container.read(gameControllerProvider).navigationMode, 'FREE_WALK');
    });
  });

  group('UI Widget Tests', () {
    testWidgets('ProductDetailDialog displays product info and closes on button tap', (tester) async {
      final beras = ProductCatalog.findById('beras_1kg')!;
      bool closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductDetailDialog(
              product: beras,
              onClose: () {
                closed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Beras'), findsOneWidget);
      expect(find.text('Rp12.000'), findsOneWidget);
      expect(find.text('Sembako Pokok'), findsOneWidget);
      expect(find.text('Kembali ke Toko'), findsOneWidget);

      await tester.tap(find.text('Kembali ke Toko'));
      expect(closed, isTrue);
    });

    testWidgets('HudOverlay displays title, FPS, and navigation buttons', (tester) async {
      bool wentToCashier = false;
      String? tappedShelf;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HudOverlay(
                onGoToCashier: () {
                  wentToCashier = true;
                },
                onGoToShelf: (id) {
                  tappedShelf = id;
                },
                onToggleMode: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('🏪 Toko Cerdas 3D'), findsOneWidget);
      expect(find.text('60 FPS'), findsOneWidget);
      expect(find.text('Ke Kasir'), findsOneWidget);

      await tester.tap(find.text('Ke Kasir'));
      expect(wentToCashier, isTrue);

      await tester.tap(find.text('🌾 Sembako'));
      expect(tappedShelf, 'rak_sembako');
    });
  });
}
