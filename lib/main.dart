import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/shop_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred orientation to landscape per PRD Bab 20
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Set full screen immersive mode for games
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    const ProviderScope(
      child: TokoCerdasApp(),
    ),
  );
}

class TokoCerdasApp extends StatelessWidget {
  const TokoCerdasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Cerdas 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A085),
          primary: const Color(0xFF16A085),
          secondary: const Color(0xFFF39C12),
        ),
        scaffoldBackgroundColor: const Color(0xFFD7EDF7),
        fontFamily: 'Segoe UI',
      ),
      home: const ShopScreen(),
    );
  }
}
