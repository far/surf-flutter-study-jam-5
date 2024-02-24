import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:meme_generator/screens/edit_image.dart';
import 'package:meme_generator/models/text.dart';
import 'package:meme_generator/utils/alert.dart';
import 'package:meme_generator/utils/perm.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import 'package:share_plus/share_plus.dart';

abstract class EditImageVM extends State<EditScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController textInputController = TextEditingController();
  final TextEditingController textCurrent = TextEditingController();

  List<TextData> txtList = [];
  int idx = 0;

  saveLocally(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        showMsg(context, 'Saving image..');
        if (kIsWeb) {
          await XFile.fromData(
            image,
            mimeType: 'image/jpg',
          ).saveTo('meme.jpg');
        } else {
          saveImage(image);
        }
      }
    }).catchError((err) {
      showMsg(context, 'Loading image error', bgColor: Colors.red);
    });
  }

  // save image locally for not web platforms

  void saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = "meme_$time";

    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  void removeText(BuildContext context) {
    setState(() {
      txtList.removeAt(idx);
    });
    showMsg(context, 'Text Deleted');
  }

  void changeTextColor(Color color) {
    setState(() {
      if (txtList.isEmpty) return;
      txtList[idx].color = color;
    });
  }

  void incFontSize() {
    setState(() {
      if (txtList.isEmpty) return;
      txtList[idx].fontSize += 3;
    });
  }

  void decFontSize() {
    setState(() {
      if (txtList.isEmpty) return;
      txtList[idx].fontSize -= 3;
    });
  }

  void alignLeft() {
    setState(() {
      if (txtList.isEmpty) return;
      txtList[idx].textAlign = TextAlign.left;
    });
  }

  boldText() {
    setState(() {
      if (txtList.isEmpty) return;
      if (txtList[idx].fontWeight == FontWeight.bold) {
        txtList[idx].fontWeight = FontWeight.normal;
      } else {
        txtList[idx].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (txtList.isEmpty) return;
      if (txtList[idx].fontStyle == FontStyle.italic) {
        txtList[idx].fontStyle = FontStyle.normal;
      } else {
        txtList[idx].fontStyle = FontStyle.italic;
      }
    });
  }

  alignCenter() {
    setState(() {
      if (txtList.isEmpty) return;
      txtList[idx].textAlign = TextAlign.center;
    });
  }

  void alignRight() {
    setState(() {
      if (txtList.isEmpty) return;
      txtList[idx].textAlign = TextAlign.right;
    });
  }

  void addNewText(BuildContext context) {
    setState(() {
      txtList.add(
        TextData(
          text: textInputController.text,
          left: 0,
          top: 0,
          textAlign: TextAlign.left,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
        ),
      );
      idx = txtList.length - 1;
      Navigator.of(context).pop();
    });
  }

  void showAddDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'New Text',
        ),
        content: TextField(
          controller: textInputController,
          maxLines: 10,
          decoration: const InputDecoration(
            filled: true,
            hintText: 'type your text',
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => addNewText(context),
            child: const Text('Add Text'),
          ),
        ],
      ),
    );
  }
}
