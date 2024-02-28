import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:meme_generator/utils/gfonts.dart';

class FontExample extends StatelessWidget {
  final ValueNotifier<PickerFont> fontValue;
  const FontExample({Key? key, required this.fontValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, PickerFont value, Widget? child) {
        return Column(children: [
          Text("Hello, World!\nПривет, Мир!",
              style: createTextStyle(value, fontSize: 30, color: Colors.black)),
          const SizedBox(height: 10),
          Text("Current Font: ${value.toFontSpec()}")
        ]);
      },
      valueListenable: fontValue,
    );
  }
}
