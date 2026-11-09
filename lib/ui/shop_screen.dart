import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../game/game_controller.dart';
import 'cashier_panel_modal.dart';
import 'day_briefing_screen.dart';
import 'day_summary_screen.dart';
import 'home_screen.dart';
import 'hud_overlay.dart';
import 'parent_dashboard_screen.dart';
import 'product_detail_dialog.dart';
import 'restock_screen.dart';
import 'splash_screen.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  late final WebViewController _webViewController;
  bool _isWebViewReady = false;
  String? _lastSpawnedCustomerKey;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFD7EDF7))
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (JavaScriptMessage message) {
          ref.read(gameControllerProvider.notifier).process3DMessage(message.message);
        },
      );

    try {
      if (kIsWeb) {
        final html = await rootBundle.loadString('assets/three/index.html');
        final js = await rootBundle.loadString('assets/three/three.min.js');
        final inlinedHtml = html.replaceFirst(
          '<script src="three.min.js"></script>',
          '<script>$js</script>',
        );
        await controller.loadHtmlString(inlinedHtml);
      } else {
        await controller.loadFlutterAsset('assets/three/index.html');
      }
    } catch (e) {
      debugPrint('Fallback loading inlined 3D html: $e');
      final html = await rootBundle.loadString('assets/three/index.html');
      final js = await rootBundle.loadString('assets/three/three.min.js');
      final inlinedHtml = html.replaceFirst(
        '<script src="three.min.js"></script>',
        '<script>$js</script>',
      );
      await controller.loadHtmlString(inlinedHtml);
    }

    _webViewController = controller;
    if (mounted) {
      setState(() {
        _isWebViewReady = true;
      });
    }
  }

  void _runJs(String code) {
    if (_isWebViewReady) {
      _webViewController.runJavaScript(code);
    }
  }

  void _goToCashier() {
    _runJs('window.goToCashier && window.goToCashier();');
  }

  void _goToShelf(String shelfId) {
    _runJs('window.goToShelf && window.goToShelf("$shelfId");');
  }

  void _toggleMode(String mode) {
    _runJs('window.setNavigationMode && window.setNavigationMode("$mode");');
  }

  void _playSfx(String sfx) {
    _runJs('window.playSfx && window.playSfx("$sfx");');
  }

  void _onCustomerHappy() {
    _runJs('window.customerHappy && window.customerHappy();');
  }

  void _onCustomerLeave() {
    _runJs('window.customerLeave && window.customerLeave();');
  }

  void _checkSpawnCustomer(GameState state) {
    if (state.currentScreen == GameScreen.inStore && _isWebViewReady) {
      final order = state.currentOrder;
      if (order != null) {
        final key = '${state.currentDay}_${state.currentOrderIndex}_${order.customerName}';
        if (_lastSpawnedCustomerKey != key) {
          _lastSpawnedCustomerKey = key;
          final orderJson = jsonEncode({
            'customerName': order.customerName,
            'appearanceId': order.appearanceId,
          });
          _runJs('window.startCustomer && window.startCustomer($orderJson);');
          _runJs('window.setFloorGuide && window.setFloorGuide(${state.levelConfig.showShelfGuideArrow});');
          _runJs('window.setAudioEnabled && window.setAudioEnabled(${state.isAudioEnabled});');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);

    // Check if 3D scene needs to spawn customer for active order
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSpawnCustomer(gameState);
    });

    switch (gameState.currentScreen) {
      case GameScreen.splash:
        return const SplashScreen();
      case GameScreen.home:
        return const HomeScreen();
      case GameScreen.dayBriefing:
        return const DayBriefingScreen();
      case GameScreen.daySummary:
        return const DaySummaryScreen();
      case GameScreen.restockPhase:
        return const RestockScreen();
      case GameScreen.parentDashboard:
        return const ParentDashboardScreen();
      case GameScreen.inStore:
        return _buildInStoreView(gameState);
    }
  }

  Widget _buildInStoreView(GameState gameState) {
    final order = gameState.currentOrder;
    final inspectedProd = gameState.inspectedProduct;
    final isNeeded = inspectedProd != null && (order?.items.any((it) => it.productId == inspectedProd.id) ?? false);

    return Scaffold(
      backgroundColor: const Color(0xFFD7EDF7),
      body: Stack(
        children: [
          // 3D Scene WebView
          if (_isWebViewReady)
            WebViewWidget(controller: _webViewController)
          else
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A085)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat Ruko Sembako 3D...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),

          // HUD Overlay
          if (!gameState.isCashierOpen)
            PointerInterceptor(
              child: HudOverlay(
                onGoToCashier: _goToCashier,
                onGoToShelf: _goToShelf,
                onToggleMode: _toggleMode,
                onOpenCashierPanel: () {
                  ref.read(gameControllerProvider.notifier).openCashierPanel();
                  _playSfx('kaching');
                },
              ),
            ),

          // Product Detail Inspection Modal
          if (inspectedProd != null && !gameState.isCashierOpen)
            PointerInterceptor(
              child: Center(
                child: ProductDetailDialog(
                  product: inspectedProd,
                  isNeededInOrder: isNeeded,
                  onClose: () {
                    ref.read(gameControllerProvider.notifier).clearInspectedProduct();
                  },
                  onAddToBasket: () {
                    ref.read(gameControllerProvider.notifier).pickItemToBasket(inspectedProd.id);
                    _playSfx('item_click');
                  },
                ),
              ),
            ),

          // Cashier Panel Modal (2D Checkout over 3D World)
          if (gameState.isCashierOpen)
            PointerInterceptor(
              child: CashierPanelModal(
                onCustomerHappy: _onCustomerHappy,
                onCustomerLeave: _onCustomerLeave,
                onPlaySfx: _playSfx,
              ),
            ),
        ],
      ),
    );
  }
}
