import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/theme_constants.dart';
import 'package:rxdart/rxdart.dart';

class ThemeController {
  SharedPreferences? _prefs;

  final BehaviorSubject<ThemeMode> _themeModeStreamController =
      BehaviorSubject<ThemeMode>();

  Stream<ThemeMode> get themeModeStream => _themeModeStreamController.stream;

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await _getPrefs();
    await prefs.setInt(kThemePreferenceKey, mode.index);
    _themeModeStreamController.add(mode);
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await _getPrefs();
    int? modeIndex = prefs.getInt(kThemePreferenceKey);
    return ThemeMode.values[modeIndex ?? ThemeMode.system.index];
  }

  Future<void> _loadThemeMode() async {
    final mode = await getThemeMode();
    _themeModeStreamController.add(mode);
  }

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  ThemeController() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadThemeMode();
  }

  void dispose() {
    _themeModeStreamController.close();
  }
}
