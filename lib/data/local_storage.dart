import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyCurrentDay = 'tc_current_day';
  static const String _keyCoins = 'tc_coins';
  static const String _keyStars = 'tc_stars';
  static const String _keyShopName = 'tc_shop_name';
  static const String _keyAgeGroup = 'tc_age_group';
  static const String _keyTotalCorrect = 'tc_total_correct';
  static const String _keyTotalHints = 'tc_total_hints';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  int get currentDay => _prefs.getInt(_keyCurrentDay) ?? 1;
  Future<void> saveCurrentDay(int day) async => _prefs.setInt(_keyCurrentDay, day);

  int get coins => _prefs.getInt(_keyCoins) ?? 0;
  Future<void> saveCoins(int count) async => _prefs.setInt(_keyCoins, count);
  Future<void> addCoins(int amount) async => saveCoins(coins + amount);

  String get shopName => _prefs.getString(_keyShopName) ?? 'Toko Cerdas';
  Future<void> saveShopName(String name) async => _prefs.setString(_keyShopName, name);

  String get ageGroup => _prefs.getString(_keyAgeGroup) ?? '6-8';
  Future<void> saveAgeGroup(String group) async => _prefs.setString(_keyAgeGroup, group);

  int get totalCorrectTransactions => _prefs.getInt(_keyTotalCorrect) ?? 0;
  Future<void> incrementCorrectTransactions() async =>
      _prefs.setInt(_keyTotalCorrect, totalCorrectTransactions + 1);

  int get totalHintsUsed => _prefs.getInt(_keyTotalHints) ?? 0;
  Future<void> incrementHintsUsed() async =>
      _prefs.setInt(_keyTotalHints, totalHintsUsed + 1);

  Map<int, int> get starsPerDay {
    final raw = _prefs.getString(_keyStars);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(int.parse(k), v as int));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveStarsForDay(int day, int stars) async {
    final current = Map<int, int>.from(starsPerDay);
    if ((current[day] ?? 0) < stars) {
      current[day] = stars;
      final encoded = jsonEncode(current.map((k, v) => MapEntry(k.toString(), v)));
      await _prefs.setString(_keyStars, encoded);
    }
  }

  Future<void> resetAllData() async {
    await _prefs.remove(_keyCurrentDay);
    await _prefs.remove(_keyCoins);
    await _prefs.remove(_keyStars);
    await _prefs.remove(_keyShopName);
    await _prefs.remove(_keyAgeGroup);
    await _prefs.remove(_keyTotalCorrect);
    await _prefs.remove(_keyTotalHints);
  }
}
