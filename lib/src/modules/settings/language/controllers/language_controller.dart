import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class LanguageController {
  final _localeSubject = BehaviorSubject<Locale>();
  final _hasSelectedLanguageSubject = BehaviorSubject<bool>();

  Stream<Locale> get localeStream => _localeSubject.stream;
  Stream<bool> get hasSelectedLanguageStream =>
      _hasSelectedLanguageSubject.stream;

  LanguageController() {
    initLanguage();
  }

  Future<void> initLanguage() async {
    Locale? savedLocale = await loadSavedLocale();
    bool? hasSelectedLanguage = await hasUserSelectedLanguage();

    if (hasSelectedLanguage != null && hasSelectedLanguage) {
      _localeSubject.add(savedLocale ?? const Locale('pt', 'BR'));
    } else {
      _localeSubject.add(const Locale('pt', 'BR'));
    }
    _hasSelectedLanguageSubject.add(hasSelectedLanguage ?? false);
  }

  Future<Locale?> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    String? countryCode = prefs.getString('country_code');

    if (languageCode != null && countryCode != null) {
      return Locale(languageCode, countryCode);
    }
    return null;
  }

  Future<bool?> hasUserSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSelectedLanguage');
  }

  Future<void> setLocale(Locale locale) async {
    _localeSubject.add(locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    String? countryCode;

    switch (locale.languageCode) {
      case 'en':
        countryCode = 'US';
        break;
      case 'pt':
        countryCode = 'BR';
        break;
      default:
        countryCode = locale.countryCode;
        break;
    }

    if (countryCode != null) {
      await prefs.setString('country_code', countryCode);
    }

    await prefs.setBool('hasSelectedLanguage', true);
  }

  Future<void> saveLanguagesOrder(List<String> languages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('languages_order', languages);
  }

  Future<List<String>?> loadLanguagesOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('languages_order');
  }

  void dispose() {
    _localeSubject.close();
    _hasSelectedLanguageSubject.close();
  }

  void updateLocaleWithoutSaving(Locale locale) {
    _localeSubject.add(locale);
  }
}
