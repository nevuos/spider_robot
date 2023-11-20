import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../modules/settings/language/controllers/language_controller.dart';
import '../services/spider_control_service.dart';

class ControlWidget extends StatefulWidget {
  const ControlWidget({Key? key}) : super(key: key);

  @override
  State<ControlWidget> createState() => _ControlWidgetState();
}

class _ControlWidgetState extends State<ControlWidget> {
  late final LanguageController _languageController;
  late final SpiderControlService _spiderControlService;

  @override
  void initState() {
    super.initState();
    _languageController = Modular.get<LanguageController>();
    _spiderControlService = Modular.get<SpiderControlService>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
      stream: _languageController.localeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> buttonNames = [
            translate('buttonCrouch'),
            translate('buttonStand'),
            translate('buttonWave'),
            translate('buttonSitMode'),
          ];

          return Column(
            children: [
              Expanded(
                flex: 2,
                child: _buildJoystick(),
              ),
              Expanded(
                flex: 2,
                child: _buildButtonGrid(buttonNames),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildJoystick() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Joystick(
            mode: JoystickMode.all,
            listener: (details) {
              sendJoystickData(details.x, details.y);
            },
            stick: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonGrid(List<String> buttonNames) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 25,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
        children: buttonNames.map((name) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: ElevatedButton(
              onPressed: () {
                sendButtonCommand(name);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                constraints:
                    const BoxConstraints(maxWidth: 120.0, minHeight: 40.0),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void showErrorSnackbar(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(
        errorMessage,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void sendJoystickData(double x, double y) {
    _spiderControlService.sendJoystickData(x, y).catchError((e) {
      showErrorSnackbar('Erro ao enviar dados do joystick: $e');
    });
  }

  void sendButtonCommand(String name) {
    _spiderControlService.sendButtonCommand(name).catchError((e) {
      showErrorSnackbar('Erro ao enviar comando do botão: $e');
    });
  }
}
