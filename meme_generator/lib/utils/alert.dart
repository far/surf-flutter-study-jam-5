import 'package:flutter/material.dart';

void showMsg(BuildContext context, String msg,
    {Color bgColor = Colors.transparent}) {
  if (bgColor == Colors.transparent &&
      Theme.of(context).primaryColor != Colors.transparent) {
    bgColor = Theme.of(context).primaryColor;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      duration: const Duration(seconds: 1),
      showCloseIcon: true,
      content: Text(msg),
    ),
  );
}
