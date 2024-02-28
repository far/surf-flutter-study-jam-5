import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';

const defaultFontSpec = 'Rubik Gemstones:400';

const List<String> googleFonts = [
  "Amatic SC",
  "Bad Script",
  "Bellota",
  "Caveat",
  "Comforter Brush",
  "Cormorant Unicase",
  "Lobster",
  "Marck Script",
  "Merriweather",
  "Oswald",
  "Pacifico",
  "Prata",
  "Press Start 2P",
  "Roboto",
  "Rubik Beastly",
  "Rubik Microbe",
  "Rubik Mono One",
  "Rubik Gemstones",
  "Rubik Iso",
  "Orelega One",
  "Shantell Sans",
  "Ubuntu",
];

TextStyle createTextStyle(PickerFont font,
        {double fontSize = 30,
        Color color = Colors.black,
        double height = 1.0,
        double letterSpace = 0.0}) =>
    GoogleFonts.getFont(
      font.fontFamily,
      fontWeight: font.fontWeight,
      fontStyle: font.fontStyle,
      fontSize: fontSize,
      color: color,
      letterSpacing: letterSpace,
      height: height,
    );
