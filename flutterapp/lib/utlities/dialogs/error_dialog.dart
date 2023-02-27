import 'package:flutter/material.dart';
import 'package:flutterapp/utlities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: "An ereor occurred",
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
