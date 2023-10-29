// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../controllers/language_controller.dart';

class LanguageSelectorScreen extends StatefulWidget {
  const LanguageSelectorScreen({Key? key}) : super(key: key);

  @override
  _LanguageSelectorScreenState createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguageSelectorScreen> {
  late LanguageController _controller;
  String _selectedLanguage = 'english';
  String? _originalLanguage;
  FixedExtentScrollController? _scrollController;

  final List<String> _languages = ['english', 'portuguese'];
  final Map<String, String> _languageToFile = {
    'english': 'en',
    'portuguese': 'pt',
  };

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<LanguageController>();
    _setupLanguage();
  }

  Future<void> _setupLanguage() async {
    List<String>? savedLanguagesOrder = await _controller.loadLanguagesOrder();

    if (savedLanguagesOrder != null) {
      _languages.clear();
      _languages.addAll(savedLanguagesOrder);
      _selectedLanguage = _languages.first;
    } else {
      Locale? savedLocale = await _controller.loadSavedLocale();
      if (savedLocale != null &&
          _languageToFile.containsValue(savedLocale.languageCode)) {
        _selectedLanguage = _languageToFile.entries
            .firstWhere(
              (entry) => entry.value == savedLocale.languageCode,
              orElse: () => const MapEntry('english', 'en'),
            )
            .key;
      }
    }

    _originalLanguage = _selectedLanguage;

    setState(() {
      _scrollController = FixedExtentScrollController(
          initialItem: _languages.indexOf(_selectedLanguage));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: StreamBuilder<Locale>(
            stream: _controller.localeStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: Text(
                      translate("selectLanguage"),
                      key: const ValueKey<String>("selectLanguageKey"),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCupertinoPicker(context),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      _selectLanguage(_selectedLanguage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorDark
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 120.0,
                        minHeight: 40.0,
                      ),
                      child: Text(
                        translate("confirm"),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedLanguage != _originalLanguage) {
      Locale originalLocale = Locale(_languageToFile[_originalLanguage!]!);
      await _controller.setLocale(originalLocale);
    }
    return true;
  }

  Widget _buildCupertinoPicker(BuildContext context) {
    return SizedBox(
      height: 200,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: CupertinoPicker(
          backgroundColor: Colors.transparent,
          itemExtent: 32.0,
          scrollController: _scrollController,
          onSelectedItemChanged: (int index) {
            String language = _languages[index];
            setState(() {
              _selectedLanguage = language;
            });
            _controller
                .updateLocaleWithoutSaving(Locale(_languageToFile[language]!));
          },
          children: _languages
              .map((language) => Center(
                    child: Text(
                      translate(language),
                      style: TextStyle(
                        fontWeight: _selectedLanguage == language
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _selectLanguage(String language) async {
    int currentIndex = _languages.indexOf(language);
    if (currentIndex > 0) {
      setState(() {
        _languages.remove(language);
        _languages.insert(0, language);
      });
      await _controller.saveLanguagesOrder(_languages);
    }

    Locale locale = Locale(_languageToFile[language]!);
    await _controller.setLocale(locale);
    Modular.to.pushReplacementNamed("/home/");
  }
}
