import 'package:flutter/material.dart';
import 'package:meme_generator/models/text.dart';

class TextImage extends StatelessWidget {
  final TextData textData;
  const TextImage({
    Key? key,
    required this.textData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textData.text,
      textAlign: textData.textAlign,
      style: TextStyle(
        fontSize: textData.fontSize,
        fontWeight: textData.fontWeight,
        fontStyle: textData.fontStyle,
        color: textData.color,
      ),
    );
  }
}
