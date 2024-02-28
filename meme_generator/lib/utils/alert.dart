import 'package:flutter/material.dart';

void showSnack(BuildContext context, String msg,
    {Color bgColor = Colors.transparent, int delaySec = 1}) {
  if (bgColor == Colors.transparent &&
      Theme.of(context).primaryColor != Colors.transparent) {
    bgColor = Theme.of(context).primaryColor;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      duration: Duration(seconds: delaySec),
      showCloseIcon: true,
      content: Text(msg),
    ),
  );
}
