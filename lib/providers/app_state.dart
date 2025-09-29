import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cut.dart';
import '../models/day_record.dart';

class AppState extends ChangeNotifier {
  static const String _kHistoryKey = 'history_v1';
  static const String _kSettingsKey = 'settings_v1';

  int defaultPercent = 50;
  int historyLimit = 3; // par défaut 3 jours

  late DayRecord currentDay;
  List<DayRecord> history = []; // jours précédents, plus récents en premier

  AppState() {
    currentDay = DayRecord(date: _todayDate());
    load();
  }

  /// Date sans heure (ex: 2025-09-11)
  static DateTime _todayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Charger données
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // settings
    final settingsStr = prefs.getString(_kSettingsKey);
    if (settingsStr != null) {
      try {
        final s = jsonDecode(settingsStr);
        defaultPercent = (s['defaultPercent'] ?? defaultPercent) as int;
        historyLimit = (s['historyLimit'] ?? historyLimit) as int;
      } catch (_) {}
    }

    // historique
    final histStr = prefs.getString(_kHistoryKey);
    if (histStr != null) {
      try {
        final list = jsonDecode(histStr) as List<dynamic>;
        history = list
            .map((e) => DayRecord.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } catch (_) {
        history = [];
      }
    }

    // restaurer currentDay si présent
    final todayKey = _todayDate();
    if (history.isNotEmpty && history.first.date == todayKey) {
      currentDay = history.removeAt(0);
    } else {
      currentDay = DayRecord(date: todayKey);
    }

    notifyListeners();
  }

  /// Sauvegarder tout
  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();

    // settings
    final settingsMap = {
      'defaultPercent': defaultPercent,
      'historyLimit': historyLimit
    };
    await prefs.setString(_kSettingsKey, jsonEncode(settingsMap));

    // history (inclut currentDay au début)
    final histToSave = [
      currentDay.toJson(),
      ...history.map((d) => d.toJson()),
    ];
    await prefs.setString(_kHistoryKey, jsonEncode(histToSave));
  }

  /// Ajouter une coupe
  void addCut({required int price, required int percent, String service = ''}) {
    final cut = Cut(price: price, percent: percent, service: service);
    currentDay.cuts.add(cut);
    notifyListeners();
    _saveAll();
  }

  /// Supprimer une coupe
  void removeCut(int index) {
    if (index >= 0 && index < currentDay.cuts.length) {
      currentDay.cuts.removeAt(index);
      notifyListeners();
      _saveAll();
    }
  }

  /// Fermer la journée et sauvegarder
  void closeDay() {
    if (currentDay.cuts.isEmpty) return;

    history.insert(0, currentDay);

    if (history.length > historyLimit) {
      history = history.sublist(0, historyLimit);
    }

    currentDay = DayRecord(date: _todayDate());
    notifyListeners();
    _saveAll();
  }

  /// Mettre à jour les paramètres
  void updateSettings({int? defaultPercent, int? historyLimit}) {
    if (defaultPercent != null) this.defaultPercent = defaultPercent;
    if (historyLimit != null) this.historyLimit = historyLimit;

    if (history.length > this.historyLimit) {
      history = history.sublist(0, this.historyLimit);
    }

    notifyListeners();
    _saveAll();
  }
}
