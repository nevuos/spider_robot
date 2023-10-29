import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

Future<bool> showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(translate('exitDialogTitle')),
      content: Text(translate('exitDialogMessage')),
      actions: [
        TextButton(
          child: Text(translate('exitDialogCancelButton')),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text(translate('exitDialogConfirmButton')),
          onPressed: () {
            Navigator.of(context).pop(true);
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
        ),
      ],
    ),
  );

  return result ?? false;
}
