import 'package:flutter_modular/flutter_modular.dart';

import 'controllers/home_controller.dart';
import 'views/home_screen.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<HomeController>(HomeController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomeScreen());
  }
}
