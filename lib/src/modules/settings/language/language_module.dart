import 'package:flutter_modular/flutter_modular.dart';

import 'views/language_screen.dart';

class LanguageModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const LanguageSelectorScreen());
  }
}
