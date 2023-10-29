import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../utils/functions.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Container(
        color: _getDrawerBackgroundColor(context),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(context),
            _buildTile(context,
                icon: Icons.home,
                title: translate('homeTitle'),
                onTap: () => Modular.to.pop(),
                isSelected: true,
                isDarkTheme: isDarkTheme),
            _buildTile(context,
                icon: Icons.wb_sunny,
                title: isDarkTheme
                    ? translate('lightTheme')
                    : translate('darkTheme'),
                onTap: () => Modular.to.pushNamed('/theme/'),
                isDarkTheme: isDarkTheme),
            _buildTile(context,
                icon: Icons.language,
                title: translate('languageTitle'),
                onTap: () => Modular.to.pushNamed('/language/'),
                isDarkTheme: isDarkTheme),
            _buildTile(context,
                icon: Icons.exit_to_app,
                title: translate('exitTitle'), onTap: () async {
              if (await showExitDialog(context)) {}
            }, isDarkTheme: isDarkTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Function onTap,
    required bool isDarkTheme,
    bool isSelected = false,
  }) {
    final defaultColor = isDarkTheme ? Colors.white : Colors.black;
    final selectedColor = isSelected
        ? (isDarkTheme
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).primaryColor)
        : defaultColor;

    return ListTile(
      leading: Icon(icon, color: selectedColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: selectedColor,
        ),
      ),
      onTap: onTap as void Function()?,
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkTheme
              ? [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorDark
                ]
              : [Colors.cyan, Colors.greenAccent[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            translate('welcomeText'),
            style: TextStyle(
              color: _getDrawerTextColor(context),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            translate('exploreText'),
            style: TextStyle(
              color: _getDrawerTextColor(context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDrawerBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  Color _getDrawerTextColor(BuildContext context) {
    return Colors.white;
  }
}
