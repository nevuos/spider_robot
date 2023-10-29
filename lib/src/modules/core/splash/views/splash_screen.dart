// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';
import '../widgets/splash_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late SplashController _splashController;

  @override
  void initState() {
    super.initState();
    _splashController = SplashController(this);
  }

  @override
  void dispose() {
    _splashController.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashWidget(animation: _splashController.animation),
    );
  }
}
