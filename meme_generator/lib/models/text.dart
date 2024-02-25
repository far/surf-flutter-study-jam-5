import 'package:flutter/material.dart';

// main Text model

class TextData {
  Color color;
  String text;
  double left;
  double top;
  double fontSize;
  TextAlign textAlign;
  TextStyle textStyle;

  TextData({
    required this.color,
    required this.text,
    required this.top,
    required this.left,
    required this.fontSize,
    required this.textAlign,
    required this.textStyle,
  });
}
