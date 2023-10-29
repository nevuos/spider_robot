import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../constants/splash_constants.dart';

class SplashController {
  SplashController(TickerProvider tickerProvider) {
    controller = AnimationController(
      duration: kSplashAnimationDuration,
      vsync: tickerProvider,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    controller.forward().then((value) => _navigateToMain());
  }

  late AnimationController controller;
  late Animation<double> animation;
}

_navigateToMain() async {
  await Future.delayed(kNavigationDelay);
  Modular.to.pushReplacementNamed('/home/');
}
