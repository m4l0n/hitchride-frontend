// Programmer's Name: Ang Ru Xian
// Program Name: fade_dialog.dart
// Description: This is a file that contains the widget to show a dialog that appears in a fade transition.
// Last Modified: 22 July 2023

import 'package:flutter/material.dart';

void showFadeDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  required List<Widget> actions,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return AlertDialog(
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        title: Text(title),
        content: content,
        actions: actions,
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}