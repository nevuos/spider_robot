import 'package:flutter_modular/flutter_modular.dart';
import 'views/splash_screen.dart';

class SplashModule extends Module {
  
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const SplashScreen());
  }
}
