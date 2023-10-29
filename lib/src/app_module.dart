import 'package:flutter_modular/flutter_modular.dart';

import 'modules/core/home/home_module.dart';
import 'modules/core/splash/splash_module.dart';
import 'modules/settings/language/controllers/language_controller.dart';
import 'modules/settings/language/language_module.dart';
import 'modules/settings/theme/controllers/theme_controller.dart';
import 'modules/settings/theme/theme_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<ThemeController>(ThemeController.new);
    i.addSingleton<LanguageController>(LanguageController.new);
  }

  @override
  void routes(r) {
    r.module('/', module: SplashModule());
    r.module('/home', module: HomeModule());
    r.module('/theme', module: ThemeModule());
    r.module('/language', module: LanguageModule());
  }
}
