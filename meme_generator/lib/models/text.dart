import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:meme_generator/utils/gfonts.dart';

// main Text model

class TextData {
  Color color;
  String text;
  double left;
  double top;
  double fontSize;
  double height;
  double letterSpace;
  TextAlign textAlign;
  PickerFont font;

  get getTextStyle => createTextStyle(font,
      fontSize: fontSize,
      color: color,
      height: height,
      letterSpace: letterSpace);

  TextData(
      {this.color = Colors.black,
      this.text = "Hello, World",
      this.top = 0,
      this.left = 0,
      this.fontSize = 50,
      this.height = 1.0,
      this.letterSpace = 1.0,
      this.textAlign = TextAlign.left,
      required this.font});
}
