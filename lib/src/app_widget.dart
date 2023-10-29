import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:spider_robot/src/modules/core/splash/views/splash_screen.dart';

import 'modules/settings/language/controllers/language_controller.dart';
import 'modules/settings/theme/controllers/theme_controller.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  AppWidgetState createState() => AppWidgetState();
}

class AppWidgetState extends State<AppWidget> {
  final LanguageController languageController =
      Modular.get<LanguageController>();
  final ThemeController themeController = Modular.get<ThemeController>();

  LocalizationDelegate? _localizationDelegate;

  @override
  void initState() {
    super.initState();
    _initLocalizationDelegate();
  }

  _initLocalizationDelegate() async {
    Locale? savedLocale = await languageController.loadSavedLocale();
    Locale initialLocale = savedLocale ?? const Locale('pt', 'BR');

    _localizationDelegate = await LocalizationDelegate.create(
      fallbackLocale: initialLocale.toString(),
      supportedLocales: ['en_US', 'pt_BR'],
    );

    languageController.setLocale(initialLocale);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
      stream: languageController.localeStream,
      initialData: const Locale('pt', 'BR'),
      builder: (context, localeSnapshot) {
        if (!localeSnapshot.hasData || _localizationDelegate == null) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SplashScreen(),
            ),
          );
        }

        return StreamBuilder<ThemeMode>(
          stream: themeController.themeModeStream,
          initialData: ThemeMode.system,
          builder: (context, themeSnapshot) {
            if (!themeSnapshot.hasData) {
              return const Directionality(
                textDirection: TextDirection.ltr,
                child: Center(
                  child: SplashScreen(),
                ),
              );
            }
            return MaterialApp.router(
              onGenerateTitle: (context) {
                final titleTranslation = translate('title_key');
                return titleTranslation;
              },
              localizationsDelegates: [
                _localizationDelegate!,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: _localizationDelegate!.supportedLocales,
              locale: localeSnapshot.data,
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              theme: CustomLightTheme.lightTheme,
              darkTheme: CustomDarkTheme.darkTheme,
              themeMode: themeSnapshot.data!,
              routerConfig: Modular.routerConfig,
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    languageController.dispose();
    themeController.dispose();
    super.dispose();
  }
}
