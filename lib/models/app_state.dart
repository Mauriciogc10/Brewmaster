import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/brew_method.dart';
import '../models/brew_session.dart';
import '../models/settings.dart';
import '../data/methods.dart';

class AppState extends ChangeNotifier {
  final List<BrewMethod> methods = defaultMethods;
  BrewMethod? selectedMethod;

  // Config actual para la receta
  double waterMl = 300;
  double ratio = 15;
  String grind = 'Media';
  int temperatureC = 92;
  int totalSeconds = 180;
  List<BrewStep> steps = [];

  // Historial y favoritos
  List<BrewSession> history = [];
  Set<String> favorites = {};

  // Settings
  Settings settings = const Settings();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('history_v1');
    if (raw != null) {
      final decoded = jsonDecode(raw) as List;
      history = decoded.map((e) => BrewSession.fromJson(e)).toList();
    }
    final rawSettings = prefs.getString('settings_v1');
    if (rawSettings != null) {
      settings = Settings.fromJson(jsonDecode(rawSettings));
    }
    favorites = (prefs.getStringList('favorites_v1') ?? []).toSet();
  }

  Future<void> persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('history_v1', jsonEncode(history.map((e) => e.toJson()).toList()));
    await prefs.setString('settings_v1', jsonEncode(settings.toJson()));
    await prefs.setStringList('favorites_v1', favorites.toList());
  }

  void selectMethod(BrewMethod method) {
    selectedMethod = method;
    ratio = method.defaultRatio;
    grind = method.grind;
    temperatureC = method.temperatureC;
    totalSeconds = method.totalSeconds;
    steps = List<BrewStep>.from(method.steps);
    notifyListeners();
  }

  void updateConfig({double? waterMl, double? ratio, String? grind, int? temperatureC, int? totalSeconds, List<BrewStep>? steps}) {
    if (waterMl != null) this.waterMl = waterMl;
    if (ratio != null) this.ratio = ratio;
    if (grind != null) this.grind = grind;
    if (temperatureC != null) this.temperatureC = temperatureC;
    if (totalSeconds != null) this.totalSeconds = totalSeconds;
    if (steps != null) this.steps = steps;
    notifyListeners();
  }

  double get coffeeGrams => waterMl / ratio;

  void addToHistory() {
    if (selectedMethod == null) return;
    history.insert(0, BrewSession(
      methodId: selectedMethod!.id,
      methodName: selectedMethod!.name,
      dateIso: DateTime.now().toIso8601String(),
      waterMl: waterMl,
      coffeeGrams: coffeeGrams,
      ratio: ratio,
      grind: grind,
      temperatureC: temperatureC,
      totalSeconds: totalSeconds,
    ));
    persist();
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    persist();
    notifyListeners();
  }

  void updateSettings(Settings s) {
    settings = s;
    persist();
    notifyListeners();
  }

  // Favorites
  bool isFavorite(String id) => favorites.contains(id);
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    persist();
    notifyListeners();
  }

  // Recently used: map last 10 sessions to unique methods preserving order
  List<BrewMethod> get recentlyUsed {
    final ids = <String>{};
    final result = <BrewMethod>[];
    for (final s in history.take(10)) {
      if (!ids.contains(s.methodId)) {
        final m = methods.firstWhere((e) => e.id == s.methodId, orElse: () => methods.first);
        ids.add(s.methodId);
        result.add(m);
      }
    }
    return result;
  }
}