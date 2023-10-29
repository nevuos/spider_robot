import 'package:flutter_modular/flutter_modular.dart';

import 'views/theme_screen.dart';

class ThemeModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const ThemeScreen());
  }
}
