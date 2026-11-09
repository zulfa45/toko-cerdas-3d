import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/level_config.dart';
import '../data/local_storage.dart';
import '../data/product_catalog.dart';

enum GameScreen {
  home,
  dayBriefing,
  inStore,
  daySummary,
  restockPhase,
  parentDashboard,
}

enum CashierStep {
  calculateTotal,
  calculateChange,
  successFeedback,
}

@immutable
class GameState {
  final GameScreen currentScreen;
  final int currentDay;
  final String shopName;
  final String ageGroup; // '6-8' or '9-12'
  final int coins;
  final Map<int, int> starsPerDay;
  final int totalCorrectTransactions;
  final int totalHintsUsed;

  // Level & Customers
  final LevelConfig levelConfig;
  final List<CustomerOrder> todayOrders;
  final int currentOrderIndex;
  final String customerState; // 'SPAWN', 'WALKING_IN', 'ARRIVED', 'HAPPY', 'GONE'

  // Basket & Shopping List
  final Map<String, int> basket; // productId -> count collected
  final Product? inspectedProduct;
  final String? activeShelf;

  // Cashier Panel State
  final bool isCashierOpen;
  final CashierStep cashierStep;
  final int? selectedTotalChoice; // For multiple choice (Day 1-2)
  final String enteredTotalKeypad; // For keypad (Day 3-5)
  final List<int> selectedChangeBills; // Bills given as change, e.g. [10000, 2000]
  final String? feedbackHint;
  final int attemptsOnCurrentStep;

  // Technical & 3D HUD
  final String navigationMode; // 'TAP_AND_WALK' or 'FREE_WALK'
  final int measuredFps;
  final bool isSceneReady;
  final String toastMessage;
  final bool isAudioEnabled;

  const GameState({
    this.currentScreen = GameScreen.home,
    this.currentDay = 1,
    this.shopName = 'Toko Cerdas',
    this.ageGroup = '6-8',
    this.coins = 0,
    this.starsPerDay = const {},
    this.totalCorrectTransactions = 0,
    this.totalHintsUsed = 0,
    required this.levelConfig,
    this.todayOrders = const [],
    this.currentOrderIndex = 0,
    this.customerState = 'SPAWN',
    this.basket = const {},
    this.inspectedProduct,
    this.activeShelf,
    this.isCashierOpen = false,
    this.cashierStep = CashierStep.calculateTotal,
    this.selectedTotalChoice,
    this.enteredTotalKeypad = '',
    this.selectedChangeBills = const [],
    this.feedbackHint,
    this.attemptsOnCurrentStep = 0,
    this.navigationMode = 'TAP_AND_WALK',
    this.measuredFps = 60,
    this.isSceneReady = false,
    this.toastMessage = 'Selamat Datang di Toko Cerdas 3D!',
    this.isAudioEnabled = true,
  });

  CustomerOrder? get currentOrder {
    if (todayOrders.isEmpty || currentOrderIndex >= todayOrders.length) {
      return null;
    }
    return todayOrders[currentOrderIndex];
  }

  bool get isBasketComplete {
    final order = currentOrder;
    if (order == null) return false;
    for (final item in order.items) {
      final inBasket = basket[item.productId] ?? 0;
      if (inBasket < item.quantity) {
        return false;
      }
    }
    return true;
  }

  int get totalChangeGiven {
    return selectedChangeBills.fold(0, (sum, bill) => sum + bill);
  }

  GameState copyWith({
    GameScreen? currentScreen,
    int? currentDay,
    String? shopName,
    String? ageGroup,
    int? coins,
    Map<int, int>? starsPerDay,
    int? totalCorrectTransactions,
    int? totalHintsUsed,
    LevelConfig? levelConfig,
    List<CustomerOrder>? todayOrders,
    int? currentOrderIndex,
    String? customerState,
    Map<String, int>? basket,
    Product? Function()? inspectedProduct,
    String? activeShelf,
    bool? isCashierOpen,
    CashierStep? cashierStep,
    int? Function()? selectedTotalChoice,
    String? enteredTotalKeypad,
    List<int>? selectedChangeBills,
    String? Function()? feedbackHint,
    int? attemptsOnCurrentStep,
    String? navigationMode,
    int? measuredFps,
    bool? isSceneReady,
    String? toastMessage,
    bool? isAudioEnabled,
  }) {
    return GameState(
      currentScreen: currentScreen ?? this.currentScreen,
      currentDay: currentDay ?? this.currentDay,
      shopName: shopName ?? this.shopName,
      ageGroup: ageGroup ?? this.ageGroup,
      coins: coins ?? this.coins,
      starsPerDay: starsPerDay ?? this.starsPerDay,
      totalCorrectTransactions: totalCorrectTransactions ?? this.totalCorrectTransactions,
      totalHintsUsed: totalHintsUsed ?? this.totalHintsUsed,
      levelConfig: levelConfig ?? this.levelConfig,
      todayOrders: todayOrders ?? this.todayOrders,
      currentOrderIndex: currentOrderIndex ?? this.currentOrderIndex,
      customerState: customerState ?? this.customerState,
      basket: basket ?? this.basket,
      inspectedProduct: inspectedProduct != null ? inspectedProduct() : this.inspectedProduct,
      activeShelf: activeShelf ?? this.activeShelf,
      isCashierOpen: isCashierOpen ?? this.isCashierOpen,
      cashierStep: cashierStep ?? this.cashierStep,
      selectedTotalChoice: selectedTotalChoice != null ? selectedTotalChoice() : this.selectedTotalChoice,
      enteredTotalKeypad: enteredTotalKeypad ?? this.enteredTotalKeypad,
      selectedChangeBills: selectedChangeBills ?? this.selectedChangeBills,
      feedbackHint: feedbackHint != null ? feedbackHint() : this.feedbackHint,
      attemptsOnCurrentStep: attemptsOnCurrentStep ?? this.attemptsOnCurrentStep,
      navigationMode: navigationMode ?? this.navigationMode,
      measuredFps: measuredFps ?? this.measuredFps,
      isSceneReady: isSceneReady ?? this.isSceneReady,
      toastMessage: toastMessage ?? this.toastMessage,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
    );
  }
}

class GameController extends Notifier<GameState> {
  LocalStorageService? _storage;

  @override
  GameState build() {
    _loadFromStorage();
    return GameState(
      levelConfig: LevelConfig.getByDay(1),
    );
  }

  Future<void> _loadFromStorage() async {
    try {
      final storage = await LocalStorageService.init();
      _storage = storage;

      final day = storage.currentDay;
      final config = LevelConfig.getByDay(day);

      state = state.copyWith(
        currentDay: day,
        levelConfig: config,
        shopName: storage.shopName,
        ageGroup: storage.ageGroup,
        coins: storage.coins,
        starsPerDay: storage.starsPerDay,
        totalCorrectTransactions: storage.totalCorrectTransactions,
        totalHintsUsed: storage.totalHintsUsed,
        navigationMode: storage.ageGroup == '6-8' ? 'TAP_AND_WALK' : 'FREE_WALK',
      );
    } catch (e) {
      debugPrint('Failed to load storage: $e');
    }
  }

  void setAgeGroup(String group) {
    state = state.copyWith(
      ageGroup: group,
      navigationMode: group == '6-8' ? 'TAP_AND_WALK' : 'FREE_WALK',
    );
    _storage?.saveAgeGroup(group);
  }

  void setNavigationMode(String mode) {
    state = state.copyWith(navigationMode: mode);
  }

  void setShopName(String name) {
    state = state.copyWith(shopName: name);
    _storage?.saveShopName(name);
  }

  void toggleAudio() {
    state = state.copyWith(isAudioEnabled: !state.isAudioEnabled);
  }

  // --- Navigation & Screens ---
  void goToScreen(GameScreen screen) {
    state = state.copyWith(currentScreen: screen);
  }

  void startDayBriefing(int day) {
    final config = LevelConfig.getByDay(day);
    state = state.copyWith(
      currentDay: day,
      levelConfig: config,
      currentScreen: GameScreen.dayBriefing,
    );
    _storage?.saveCurrentDay(day);
  }

  void launchInStoreGameplay() {
    final orders = LevelConfig.generateOrdersForDay(state.currentDay);
    state = state.copyWith(
      todayOrders: orders,
      currentOrderIndex: 0,
      currentScreen: GameScreen.inStore,
      basket: {},
      customerState: 'SPAWN',
      isCashierOpen: false,
      toastMessage: 'Hari ${state.currentDay} dimulai! Pembeli pertama akan datang.',
    );
  }

  // --- Customer & Order Flow ---
  void onCustomerArrived() {
    state = state.copyWith(
      customerState: 'ARRIVED',
      toastMessage: '${state.currentOrder?.customerName ?? 'Pembeli'} tiba di kasir!',
    );
  }

  void pickItemToBasket(String productId) {
    final order = state.currentOrder;
    if (order == null) return;

    // Check if this item is needed
    final targetItem = order.items.firstWhere(
      (it) => it.productId == productId,
      orElse: () => const OrderItem(productId: '', quantity: 0),
    );

    if (targetItem.productId.isEmpty) {
      state = state.copyWith(
        toastMessage: 'Barang ini tidak ada di daftar belanja pembeli.',
      );
      return;
    }

    final currentQty = state.basket[productId] ?? 0;
    if (currentQty >= targetItem.quantity) {
      state = state.copyWith(
        toastMessage: '${targetItem.product?.name ?? 'Barang'} sudah cukup!',
      );
      return;
    }

    final newBasket = Map<String, int>.from(state.basket);
    newBasket[productId] = currentQty + 1;

    final updatedState = state.copyWith(
      basket: newBasket,
      toastMessage: 'Berhasil mengambil ${targetItem.product?.name}! (${newBasket[productId]}/${targetItem.quantity})',
    );
    state = updatedState;

    if (updatedState.isBasketComplete) {
      state = state.copyWith(
        toastMessage: '🎉 Semua pesanan sudah terkumpul! Ayo kembali ke meja kasir.',
      );
    }
  }

  // --- Cashier Flow ---
  void openCashierPanel() {
    if (!state.isBasketComplete) {
      state = state.copyWith(
        toastMessage: 'Belum semua pesanan diambil. Lengkapi keranjang belanja dulu ya!',
      );
      return;
    }

    state = state.copyWith(
      isCashierOpen: true,
      cashierStep: CashierStep.calculateTotal,
      selectedTotalChoice: () => null,
      enteredTotalKeypad: '',
      selectedChangeBills: [],
      feedbackHint: () => null,
      attemptsOnCurrentStep: 0,
    );
  }

  void closeCashierPanel() {
    state = state.copyWith(isCashierOpen: false);
  }

  // Choose total in Day 1-2
  void selectTotalChoice(int choice) {
    state = state.copyWith(selectedTotalChoice: () => choice);
  }

  // Keypad in Day 3-5
  void appendKeypad(String digit) {
    if (digit == 'C') {
      state = state.copyWith(enteredTotalKeypad: '');
      return;
    }
    if (digit == 'DEL') {
      if (state.enteredTotalKeypad.isNotEmpty) {
        state = state.copyWith(
          enteredTotalKeypad: state.enteredTotalKeypad.substring(0, state.enteredTotalKeypad.length - 1),
        );
      }
      return;
    }
    if (state.enteredTotalKeypad.length < 8) {
      state = state.copyWith(
        enteredTotalKeypad: state.enteredTotalKeypad + digit,
      );
    }
  }

  // Submit Total Answer
  bool submitTotalAnswer() {
    final order = state.currentOrder;
    if (order == null) return false;

    final expectedTotal = order.totalAmount;
    final int submittedTotal = state.levelConfig.useMultipleChoiceForTotal
        ? (state.selectedTotalChoice ?? 0)
        : (int.tryParse(state.enteredTotalKeypad) ?? 0);

    if (submittedTotal == expectedTotal) {
      // Total is correct! Move to Change Step
      state = state.copyWith(
        cashierStep: CashierStep.calculateChange,
        feedbackHint: () => null,
        attemptsOnCurrentStep: 0,
      );
      return true;
    } else {
      // Wrong total - provide gentle hint
      final attempts = state.attemptsOnCurrentStep + 1;
      _storage?.incrementHintsUsed();

      String hint = 'Coba hitung lagi ya.';
      if (attempts == 1) {
        hint = 'Periksa harga masing-masing barang di daftar kasir.';
      } else if (attempts == 2) {
        final calcString = order.items.map((it) => '${it.product?.name}: Rp${it.subtotal}').join(' + ');
        hint = 'Petunjuk: $calcString';
      } else {
        hint = 'Jawaban totalnya adalah: Rp${expectedTotal.toString()}';
      }

      state = state.copyWith(
        feedbackHint: () => hint,
        attemptsOnCurrentStep: attempts,
      );
      return false;
    }
  }

  // Add bill to change
  void addChangeBill(int billAmount) {
    final list = List<int>.from(state.selectedChangeBills)..add(billAmount);
    state = state.copyWith(selectedChangeBills: list);
  }

  // Remove last bill or reset
  void removeLastChangeBill() {
    if (state.selectedChangeBills.isNotEmpty) {
      final list = List<int>.from(state.selectedChangeBills)..removeLast();
      state = state.copyWith(selectedChangeBills: list);
    }
  }

  void clearChangeBills() {
    state = state.copyWith(selectedChangeBills: []);
  }

  // Submit Change Answer
  bool submitChangeAnswer() {
    final order = state.currentOrder;
    if (order == null) return false;

    final expectedChange = order.expectedChange;
    final actualChange = state.totalChangeGiven;

    if (actualChange == expectedChange) {
      // Correct change!
      final rewardCoins = state.attemptsOnCurrentStep == 0 ? 15 : 10;
      final newCoins = state.coins + rewardCoins;

      _storage?.addCoins(rewardCoins);
      _storage?.incrementCorrectTransactions();

      state = state.copyWith(
        cashierStep: CashierStep.successFeedback,
        coins: newCoins,
        feedbackHint: () => null,
        totalCorrectTransactions: state.totalCorrectTransactions + 1,
      );
      return true;
    } else {
      final attempts = state.attemptsOnCurrentStep + 1;
      _storage?.incrementHintsUsed();

      final diff = (expectedChange - actualChange).abs();
      String hint = actualChange < expectedChange
          ? 'Kembaliannya masih kurang Rp${diff.toString()} lagi.'
          : 'Kembaliannya kelebihan Rp${diff.toString()}. Coba kurangi lembarannya.';

      if (attempts >= 3) {
        hint = 'Petunjuk: Kembalian yang pas adalah Rp${expectedChange.toString()}.';
      }

      state = state.copyWith(
        feedbackHint: () => hint,
        attemptsOnCurrentStep: attempts,
      );
      return false;
    }
  }

  // Finish Customer Transaction & Advance
  void completeCurrentTransaction() {
    final nextIndex = state.currentOrderIndex + 1;
    if (nextIndex >= state.todayOrders.length) {
      // All customers for today served! Calculate stars & go to summary
      final stars = 3; // Finished all orders
      _storage?.saveStarsForDay(state.currentDay, stars);

      final updatedStars = Map<int, int>.from(state.starsPerDay);
      updatedStars[state.currentDay] = stars;

      state = state.copyWith(
        isCashierOpen: false,
        starsPerDay: updatedStars,
        currentScreen: GameScreen.daySummary,
      );
    } else {
      // Next customer
      state = state.copyWith(
        currentOrderIndex: nextIndex,
        isCashierOpen: false,
        basket: {},
        customerState: 'SPAWN',
        toastMessage: 'Pembeli berikutnya sedang datang...',
      );
    }
  }

  // --- Product Inspection & 3D Events ---
  void inspectProduct(Product product) {
    state = state.copyWith(
      inspectedProduct: () => product,
    );
  }

  void clearInspectedProduct() {
    state = state.copyWith(inspectedProduct: () => null);
  }

  void setActiveShelf(String shelfId) {
    state = state.copyWith(activeShelf: shelfId);
  }

  void updateFps(int fps) {
    if (state.measuredFps != fps) {
      state = state.copyWith(measuredFps: fps);
    }
  }

  void setSceneReady() {
    state = state.copyWith(isSceneReady: true);
  }

  void process3DMessage(String rawJson) {
    try {
      final data = jsonDecode(rawJson) as Map<String, dynamic>;
      final type = data['type'] as String?;

      switch (type) {
        case 'scene_ready':
          setSceneReady();
          break;
        case 'fps_update':
          final fps = (data['fps'] as num?)?.toInt() ?? 60;
          updateFps(fps);
          break;
        case 'customer_arrived':
          onCustomerArrived();
          break;
        case 'product_tapped':
          final productId = data['productId'] as String?;
          if (productId != null) {
            final product = ProductCatalog.findById(productId);
            if (product != null) {
              inspectProduct(product);
            }
          }
          break;
        case 'shelf_tapped':
          final shelfId = data['shelfId'] as String?;
          if (shelfId != null) {
            setActiveShelf(shelfId);
          }
          break;
      }
    } catch (e) {
      debugPrint('Error parsing 3D event: $e');
    }
  }

  // Reset progress from Parent Dashboard
  Future<void> resetAllGameData() async {
    await _storage?.resetAllData();
    state = state.copyWith(
      currentDay: 1,
      coins: 0,
      starsPerDay: {},
      totalCorrectTransactions: 0,
      totalHintsUsed: 0,
      currentScreen: GameScreen.home,
    );
  }
}

final gameControllerProvider = NotifierProvider<GameController, GameState>(GameController.new);
