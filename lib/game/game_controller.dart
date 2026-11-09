import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_catalog.dart';

@immutable
class GameState {
  final String navigationMode; // 'TAP_AND_WALK' or 'FREE_WALK'
  final int measuredFps;
  final bool isSceneReady;
  final String customerState; // 'SPAWN', 'WALKING_IN', 'ARRIVED'
  final String customerName;
  final String customerSpeech;
  final Product? inspectedProduct;
  final String? activeShelf;
  final String toastMessage;

  const GameState({
    this.navigationMode = 'TAP_AND_WALK',
    this.measuredFps = 60,
    this.isSceneReady = false,
    this.customerState = 'WALKING_IN',
    this.customerName = 'Bu Sari',
    this.customerSpeech = 'Halo! Saya mau beli Beras 1 kg dan Minyak Goreng ya.',
    this.inspectedProduct,
    this.activeShelf,
    this.toastMessage = 'Menyiapkan Toko Cerdas 3D...',
  });

  GameState copyWith({
    String? navigationMode,
    int? measuredFps,
    bool? isSceneReady,
    String? customerState,
    String? customerName,
    String? customerSpeech,
    Product? Function()? inspectedProduct,
    String? activeShelf,
    String? toastMessage,
  }) {
    return GameState(
      navigationMode: navigationMode ?? this.navigationMode,
      measuredFps: measuredFps ?? this.measuredFps,
      isSceneReady: isSceneReady ?? this.isSceneReady,
      customerState: customerState ?? this.customerState,
      customerName: customerName ?? this.customerName,
      customerSpeech: customerSpeech ?? this.customerSpeech,
      inspectedProduct: inspectedProduct != null ? inspectedProduct() : this.inspectedProduct,
      activeShelf: activeShelf ?? this.activeShelf,
      toastMessage: toastMessage ?? this.toastMessage,
    );
  }
}

class GameController extends Notifier<GameState> {
  @override
  GameState build() {
    return const GameState();
  }

  void setSceneReady() {
    state = state.copyWith(
      isSceneReady: true,
      toastMessage: 'Ruko Toko Cerdas Siap! Sentuh rak atau barang.',
    );
  }

  void updateFps(int fps) {
    if (state.measuredFps != fps) {
      state = state.copyWith(measuredFps: fps);
    }
  }

  void setNavigationMode(String mode) {
    state = state.copyWith(navigationMode: mode);
  }

  void onCustomerArrived(String name, String speech) {
    state = state.copyWith(
      customerState: 'ARRIVED',
      customerName: name,
      customerSpeech: speech,
      toastMessage: '$name tiba di kasir!',
    );
  }

  void inspectProduct(Product product) {
    state = state.copyWith(
      inspectedProduct: () => product,
      toastMessage: 'Memeriksa ${product.name} (${product.unitLabel})',
    );
  }

  void clearInspectedProduct() {
    state = state.copyWith(inspectedProduct: () => null);
  }

  void setActiveShelf(String shelfId) {
    state = state.copyWith(activeShelf: shelfId);
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
          final name = data['name'] as String? ?? 'Bu Sari';
          final speech = data['speech'] as String? ?? 'Halo!';
          onCustomerArrived(name, speech);
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
      debugPrint('Error parsing 3D event message: $e');
    }
  }
}

final gameControllerProvider = NotifierProvider<GameController, GameState>(GameController.new);
