import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../game/game_controller.dart';
import 'hud_overlay.dart';
import 'product_detail_dialog.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  late final WebViewController _webViewController;
  bool _isWebViewReady = false;

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
        // In Flutter Web, load the asset HTML file directly with embedded scripts if needed
        final html = await rootBundle.loadString('assets/three/index.html');
        final js = await rootBundle.loadString('assets/three/three.min.js');
        // Inline three.js so webview_flutter_web does not fail on relative asset paths
        final inlinedHtml = html.replaceFirst(
          '<script src="three.min.js"></script>',
          '<script>$js</script>',
        );
        await controller.loadHtmlString(inlinedHtml);
      } else {
        // On Android / iOS, loadFlutterAsset loads asset with relative script resolution
        await controller.loadFlutterAsset('assets/three/index.html');
      }
    } catch (e) {
      debugPrint('Error loading 3D asset via loadFlutterAsset, fallback to inlined HTML: $e');
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

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFD7EDF7),
      body: Stack(
        children: [
          // 3D Scene rendered via WebGL inside WebView
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

          // Interactive HUD overlay on top of 3D Scene
          PointerInterceptor(
            child: HudOverlay(
              onGoToCashier: _goToCashier,
              onGoToShelf: _goToShelf,
              onToggleMode: _toggleMode,
            ),
          ),

          // Product Detail Dialog if child tapped a product
          if (gameState.inspectedProduct != null)
            PointerInterceptor(
              child: Center(
                child: ProductDetailDialog(
                  product: gameState.inspectedProduct!,
                  onClose: () {
                    ref.read(gameControllerProvider.notifier).clearInspectedProduct();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
