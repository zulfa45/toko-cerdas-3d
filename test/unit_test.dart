import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_cerdas/data/level_config.dart';
import 'package:toko_cerdas/data/product_catalog.dart';
import 'package:toko_cerdas/game/game_controller.dart';
import 'package:toko_cerdas/ui/home_screen.dart';
import 'package:toko_cerdas/ui/hud_overlay.dart';
import 'package:toko_cerdas/ui/product_detail_dialog.dart';
import 'package:toko_cerdas/ui/shopping_list_widget.dart';
import 'package:toko_cerdas/ui/splash_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  group('ProductCatalog Tests', () {
    test('Catalog contains 18 initial products across 5 categories', () {
      expect(ProductCatalog.initialCatalog.length, 18);
    });

    test('Beras 1kg conforms to PRD specifications', () {
      final beras = ProductCatalog.findById('beras_1kg');
      expect(beras, isNotNull);
      expect(beras!.name, 'Beras');
      expect(beras.categoryId, 'sembako_pokok');
      expect(beras.unitLabel, '1 kg');
      expect(beras.priceIdr, 12000);
      expect(beras.formattedPrice, 'Rp12.000');
    });

    test('Minyak Goreng 1l conforms to PRD specifications', () {
      final minyak = ProductCatalog.findById('minyak_1l');
      expect(minyak, isNotNull);
      expect(minyak!.name, 'Minyak Goreng');
      expect(minyak.priceIdr, 18000);
      expect(minyak.formattedPrice, 'Rp18.000');
    });

    test('Telur Ayam 1pak conforms to PRD specifications', () {
      final telur = ProductCatalog.findById('telur_1pak');
      expect(telur, isNotNull);
      expect(telur!.name, 'Telur Ayam');
      expect(telur.priceIdr, 15000);
      expect(telur.formattedPrice, 'Rp15.000');
    });
  });

  group('LevelConfig & Order Generation Tests', () {
    test('5 Days Level Configurations are properly structured', () {
      expect(LevelConfig.allLevels.length, 5);

      final day1 = LevelConfig.getByDay(1);
      expect(day1.day, 1);
      expect(day1.customerCount, 3);
      expect(day1.useMultipleChoiceForTotal, isTrue);

      final day3 = LevelConfig.getByDay(3);
      expect(day3.day, 3);
      expect(day3.customerCount, 4);
      expect(day3.useMultipleChoiceForTotal, isFalse);

      final day5 = LevelConfig.getByDay(5);
      expect(day5.day, 5);
      expect(day5.customerCount, 5);
      expect(day5.showShelfGuideArrow, isFalse);
    });

    test('Order calculation produces correct subtotal and expected change', () {
      final order = CustomerOrder(
        customerName: 'Bu Sari',
        appearanceId: 'customer_1',
        items: const [
          OrderItem(productId: 'beras_1kg', quantity: 1), // 12000
          OrderItem(productId: 'minyak_1l', quantity: 1), // 18000
        ],
        paymentBill: 50000,
      );

      expect(order.totalAmount, 30000);
      expect(order.expectedChange, 20000);
    });

    test('Generated orders for Day 1 always have positive change', () {
      final orders = LevelConfig.generateOrdersForDay(1, 42);
      expect(orders.length, 3);
      for (final o in orders) {
        expect(o.items.length, 1);
        expect(o.paymentBill, greaterThanOrEqualTo(o.totalAmount));
        expect(o.expectedChange, greaterThanOrEqualTo(0));
      }
    });
  });

  group('GameController & Full Transaction Loop Tests', () {
    test('Full transaction flow: Launch day -> Collect item -> Cashier -> Total -> Change -> Success', () {
      final container = ProviderContainer();
      final controller = container.read(gameControllerProvider.notifier);

      // 1. Start Day 1
      controller.startDayBriefing(1);
      expect(container.read(gameControllerProvider).currentScreen, GameScreen.dayBriefing);

      // 2. Launch In Store
      controller.launchInStoreGameplay();
      final stateInStore = container.read(gameControllerProvider);
      expect(stateInStore.currentScreen, GameScreen.inStore);
      expect(stateInStore.todayOrders.length, 3);

      final activeOrder = stateInStore.currentOrder!;
      final neededItemId = activeOrder.items.first.productId;

      // 3. Pick Item to Basket
      expect(stateInStore.isBasketComplete, isFalse);
      controller.pickItemToBasket(neededItemId);

      final stateWithItem = container.read(gameControllerProvider);
      expect(stateWithItem.basket[neededItemId], 1);
      expect(stateWithItem.isBasketComplete, isTrue);

      // 4. Open Cashier Panel
      controller.openCashierPanel();
      final stateCashier = container.read(gameControllerProvider);
      expect(stateCashier.isCashierOpen, isTrue);
      expect(stateCashier.cashierStep, CashierStep.calculateTotal);

      // 5. Submit Total (Day 1 uses multiple choice)
      controller.selectTotalChoice(activeOrder.totalAmount);
      final totalSuccess = controller.submitTotalAnswer();
      expect(totalSuccess, isTrue);

      final stateChangeStep = container.read(gameControllerProvider);
      expect(stateChangeStep.cashierStep, CashierStep.calculateChange);

      // 6. Provide Change Bills
      final expectedChange = activeOrder.expectedChange;
      controller.addChangeBill(expectedChange);
      expect(container.read(gameControllerProvider).totalChangeGiven, expectedChange);

      // 7. Submit Change
      final changeSuccess = controller.submitChangeAnswer();
      expect(changeSuccess, isTrue);

      final stateSuccess = container.read(gameControllerProvider);
      expect(stateSuccess.cashierStep, CashierStep.successFeedback);
      expect(stateSuccess.coins, greaterThan(0));

      // 8. Complete Transaction
      controller.completeCurrentTransaction();
      expect(container.read(gameControllerProvider).currentOrderIndex, 1);
    });

    test('Wrong total provides gentle pedagogical hint without punishing child', () {
      final container = ProviderContainer();
      final controller = container.read(gameControllerProvider.notifier);

      controller.startDayBriefing(1);
      controller.launchInStoreGameplay();

      final activeOrder = container.read(gameControllerProvider).currentOrder!;
      controller.pickItemToBasket(activeOrder.items.first.productId);
      controller.openCashierPanel();

      // Submit wrong choice
      controller.selectTotalChoice(activeOrder.totalAmount + 5000);
      final result = controller.submitTotalAnswer();

      expect(result, isFalse);
      final state = container.read(gameControllerProvider);
      expect(state.feedbackHint, isNotNull);
      expect(state.attemptsOnCurrentStep, 1);
    });

    test('Mode switch to FREE_WALK works properly', () {
      final container = ProviderContainer();
      final controller = container.read(gameControllerProvider.notifier);

      controller.setNavigationMode('FREE_WALK');
      expect(container.read(gameControllerProvider).navigationMode, 'FREE_WALK');
    });
  });

  group('UI Widget Tests', () {
    testWidgets('ProductDetailDialog displays product info and triggers addToBasket', (tester) async {
      final beras = ProductCatalog.findById('beras_1kg')!;
      bool addedToBasket = false;
      bool closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductDetailDialog(
              product: beras,
              isNeededInOrder: true,
              onClose: () => closed = true,
              onAddToBasket: () => addedToBasket = true,
            ),
          ),
        ),
      );

      expect(find.text('Beras'), findsOneWidget);
      expect(find.text('Rp12.000'), findsOneWidget);
      expect(find.text('Sembako Pokok'), findsOneWidget);
      expect(find.text('Ambil Barang 🛒'), findsOneWidget);

      await tester.tap(find.text('Ambil Barang 🛒'));
      expect(addedToBasket, isTrue);
      expect(closed, isTrue);
    });

    testWidgets('HudOverlay displays title, FPS, pills, and cashier button', (tester) async {
      bool wentToCashier = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HudOverlay(
                onGoToCashier: () => wentToCashier = true,
                onGoToShelf: (_) {},
                onToggleMode: (_) {},
                onOpenCashierPanel: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('60 FPS'), findsOneWidget);
      expect(find.text('Ke Kasir'), findsOneWidget);
      expect(find.text('Ambil Barang'), findsOneWidget);

      await tester.tap(find.text('Ke Kasir'));
      expect(wentToCashier, isTrue);
    });

    testWidgets('ShoppingListWidget displays shopping items when active order exists', (tester) async {
      final container = ProviderContainer();
      container.read(gameControllerProvider.notifier).startDayBriefing(1);
      container.read(gameControllerProvider.notifier).launchInStoreGameplay();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: ShoppingListWidget(),
            ),
          ),
        ),
      );

      expect(find.textContaining('Pesanan'), findsOneWidget);
    });

    testWidgets('SplashScreen displays voxel title and transitions on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SplashScreen(),
          ),
        ),
      );

      expect(find.text('TOKO CERDAS 3D'), findsOneWidget);
      expect(find.textContaining('Simulasi Warung Sembako'), findsOneWidget);

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
    });

    testWidgets('HomeScreen renders new overhauled voxel warung layout and day options', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.text('TOKO CERDAS 3D'), findsOneWidget);
      expect(find.textContaining('BUKA TOKO'), findsOneWidget);
      expect(find.text('HARI 1'), findsOneWidget);
    });
  });
}
