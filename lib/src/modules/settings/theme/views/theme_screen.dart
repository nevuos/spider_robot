// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../constants/theme_constants.dart';
import '../controllers/theme_controller.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  final ThemeController _themeController = Modular.get<ThemeController>();

  final List<ThemeItem> _themes = const [
    ThemeItem('light_mode', ThemeMode.light, kLightThemeIcon),
    ThemeItem('dark_mode', ThemeMode.dark, kDarkThemeIcon),
    ThemeItem('system_mode', ThemeMode.system, kSystemThemeIcon),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: translate('theme_screen_title')),
      body: StreamBuilder<ThemeMode>(
        stream: _themeController.themeModeStream,
        initialData: ThemeMode.light,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: _themes.length,
            itemBuilder: (context, index) {
              final themeItem = _themes[index];
              return ThemeOption(
                themeItem: themeItem,
                currentThemeMode: snapshot.data!,
                onOptionSelected: _updateTheme,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updateTheme(ThemeMode theme) async {
    bool? shouldChange = await _showConfirmationDialog(context, theme);
    if (shouldChange == true) {
      await _themeController.setTheme(theme);
    }
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, ThemeMode themeMode) {
    String themeKey;
    switch (themeMode) {
      case ThemeMode.light:
        themeKey = 'change_theme_dialog_content_light';
        break;
      case ThemeMode.dark:
        themeKey = 'change_theme_dialog_content_dark';
        break;
      case ThemeMode.system:
        themeKey = 'change_theme_dialog_content_system';
        break;
    }

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate('change_theme_dialog_title')),
          content: Text(translate(themeKey), style: Theme.of(context).textTheme.bodyMedium),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(translate('cancel_button'), style: const TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(translate('confirm_button'), style: const TextStyle(color: Color(0xFF64ffda))),
            ),
          ],
        );
      },
    );
  }
}

class ThemeOption extends StatelessWidget {
  final ThemeItem themeItem;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onOptionSelected;

  const ThemeOption({
    Key? key,
    required this.themeItem,
    required this.currentThemeMode,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDarkThemeSelected = currentThemeMode == ThemeMode.dark;

    Color selectedColor = isDarkThemeSelected
        ? themeData.colorScheme.secondary
        : themeData.primaryColor;

    Color defaultColor = themeData.textTheme.bodyMedium!.color!;

    return ListTile(
      leading: Icon(themeItem.icon, color: selectedColor),
      title: Text(
        translate(themeItem.title),
        style: TextStyle(
          fontSize: kOptionTextSize,
          fontWeight: FontWeight.w400,
          color: defaultColor,
        ),
      ),
      trailing: currentThemeMode == themeItem.mode
          ? Icon(Icons.check, color: selectedColor)
          : null,
      onTap: () => onOptionSelected(themeItem.mode),
    );
  }
}

class ThemeItem {
  final String title;
  final ThemeMode mode;
  final IconData icon;

  const ThemeItem(this.title, this.mode, this.icon);
}
