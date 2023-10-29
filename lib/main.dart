import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './src/app_module.dart';
import './src/app_widget.dart';

Future<void> main() async {
  await dotenv.load();
  return runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
