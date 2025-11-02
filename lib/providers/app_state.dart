import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cut.dart';
import '../models/day_record.dart';
import '../models/predefined_service.dart';

class AppState extends ChangeNotifier {
  static const String _kHistoryKey = 'history_v1';
  static const String _kSettingsKey = 'settings_v1';
  static const String _kServicesKey = 'predefined_services_v1';

  int defaultPercent = 50;
  int historyLimit = 3;

  late DayRecord currentDay;
  List<DayRecord> history = [];
  
  // NOUVEAU: Liste des services prédéfinis
  List<PredefinedService> predefinedServices = [];

  AppState() {
    currentDay = DayRecord(date: _todayDate());
    load();
  }

  static DateTime _todayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

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

    // NOUVEAU: Charger les services prédéfinis
    final servicesStr = prefs.getString(_kServicesKey);
    if (servicesStr != null) {
      try {
        final list = jsonDecode(servicesStr) as List<dynamic>;
        predefinedServices = list.map((e) => PredefinedService.fromJson(Map<String, dynamic>.from(e))).toList();
      } catch (_) {
        predefinedServices = [];
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
    
    // NOUVEAU: Sauvegarder les services prédéfinis
    final servicesJson = predefinedServices.map((s) => s.toJson()).toList();
    await prefs.setString(_kServicesKey, jsonEncode(servicesJson));
  }

  void addCut({required int price, required int percent, String service = ''}) {
    final cut = Cut(price: price, percent: percent, service: service);
    currentDay.cuts.add(cut);
    notifyListeners();
    _saveAll();
  }

  void removeCut(int index) {
    if (index >= 0 && index < currentDay.cuts.length) {
      currentDay.cuts.removeAt(index);
      notifyListeners();
      _saveAll();
    }
  }

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

  void updateSettings({int? defaultPercent, int? historyLimit}) {
    if (defaultPercent != null) this.defaultPercent = defaultPercent;
    if (historyLimit != null) this.historyLimit = historyLimit;

    if (history.length > this.historyLimit) {
      history = history.sublist(0, this.historyLimit);
    }

    notifyListeners();
    _saveAll();
  }
  
  // NOUVELLES MÉTHODES POUR LES SERVICES PRÉDÉFINIS
  void addPredefinedService(String name, int price) {
    predefinedServices.add(PredefinedService(name: name, price: price));
    notifyListeners();
    _saveAll();
  }
  
  void updatePredefinedService(int index, String name, int price) {
    if (index >= 0 && index < predefinedServices.length) {
      predefinedServices[index] = PredefinedService(
        id: predefinedServices[index].id,
        name: name,
        price: price
      );
      notifyListeners();
      _saveAll();
    }
  }
  
  void removePredefinedService(int index) {
    if (index >= 0 && index < predefinedServices.length) {
      predefinedServices.removeAt(index);
      notifyListeners();
      _saveAll();
    }
  }
}