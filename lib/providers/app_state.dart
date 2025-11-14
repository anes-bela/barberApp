import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cut.dart';
import '../models/day_record.dart';

class AppState extends ChangeNotifier {
  // 🔹 Clés de stockage
  static const String _kHistoryKey = 'history_v1';
  static const String _kSettingsKey = 'settings_v1';
  static const String _kUserKey = 'user_v1';

  // 🔹 Données principales
  int defaultPercent = 50;
  int historyLimit = 3;
  late DayRecord currentDay;
  List<DayRecord> history = [];

  // 🔹 Thème (mode sombre)
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // 🔹 Utilisateur
  String? userName;
  String? userEmail;
  String? userAddress;
  bool _isGuestMode = false;
  bool get isGuestMode => _isGuestMode;

  AppState() {
    currentDay = DayRecord(date: _todayDate());
    load();
  }

  /// Date du jour sans heure
  static DateTime _todayDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 🔹 Charger toutes les données
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // paramètres
    final settingsStr = prefs.getString(_kSettingsKey);
    if (settingsStr != null) {
      try {
        final s = jsonDecode(settingsStr);
        defaultPercent = (s['defaultPercent'] ?? defaultPercent) as int;
        historyLimit = (s['historyLimit'] ?? historyLimit) as int;
        _isDarkMode = (s['isDarkMode'] ?? false) as bool;
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

    // utilisateur
    final userStr = prefs.getString(_kUserKey);
    if (userStr != null) {
      try {
        final u = jsonDecode(userStr);
        userName = u['name'];
        userEmail = u['email'];
        userAddress = u['address'];
        _isGuestMode = u['isGuest'] ?? false;
      } catch (_) {}
    }

    // restaurer currentDay
    final todayKey = _todayDate();
    if (history.isNotEmpty && history.first.date == todayKey) {
      currentDay = history.removeAt(0);
    } else {
      currentDay = DayRecord(date: todayKey);
    }

    notifyListeners();
  }

  /// 🔹 Sauvegarder toutes les données
  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();

    // paramètres
    final settingsMap = {
      'defaultPercent': defaultPercent,
      'historyLimit': historyLimit,
      'isDarkMode': _isDarkMode,
    };
    await prefs.setString(_kSettingsKey, jsonEncode(settingsMap));

    // historique
    final histToSave = [
      currentDay.toJson(),
      ...history.map((d) => d.toJson()),
    ];
    await prefs.setString(_kHistoryKey, jsonEncode(histToSave));

    // utilisateur
    final userMap = {
      'name': userName,
      'email': userEmail,
      'address': userAddress,
      'isGuest': _isGuestMode,
    };
    await prefs.setString(_kUserKey, jsonEncode(userMap));
  }

  /// 🔹 Ajouter une coupe
  void addCut({required int price, required int percent, String service = ''}) {
    final cut = Cut(price: price, percent: percent, service: service);
    currentDay.cuts.add(cut);
    notifyListeners();
    _saveAll();
  }

  /// 🔹 Supprimer une coupe
  void removeCut(int index) {
    if (index >= 0 && index < currentDay.cuts.length) {
      currentDay.cuts.removeAt(index);
      notifyListeners();
      _saveAll();
    }
  }

  /// 🔹 Fermer la journée
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

  /// 🔹 Mettre à jour les paramètres
  void updateSettings({int? defaultPercent, int? historyLimit}) {
    if (defaultPercent != null) this.defaultPercent = defaultPercent;
    if (historyLimit != null) this.historyLimit = historyLimit;

    if (history.length > this.historyLimit) {
      history = history.sublist(0, this.historyLimit);
    }

    notifyListeners();
    _saveAll();
  }

  /// 🔹 Basculer le mode sombre
  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
    _saveAll();
  }

  /// 🔹 Connexion utilisateur
  void login({required String name, required String email, String? address}) {
    userName = name;
    userEmail = email;
    userAddress = address;
    _isGuestMode = false;
    notifyListeners();
    _saveAll();
  }

  /// 🔹 Mode invité
  void enableGuestMode() {
    userName = "Invité";
    userEmail = null;
    _isGuestMode = true;
    notifyListeners();
    _saveAll();
  }

  /// 🔹 Déconnexion
  void logout() {
    userName = null;
    userEmail = null;
    userAddress = null;
    _isGuestMode = false;
    notifyListeners();
    _saveAll();
  }
}



