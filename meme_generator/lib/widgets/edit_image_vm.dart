import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
//import 'package:share_plus/share_plus.dart';

// for 'html' renderer workaround (see saveImage below)
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:meme_generator/utils/gfonts.dart';
import 'package:meme_generator/screens/edit_image.dart';
import 'package:meme_generator/models/text.dart';
import 'package:meme_generator/utils/alert.dart';
import 'package:meme_generator/utils/perm.dart';
import './font_example.dart';

abstract class EditImageVM extends State<EditScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController textInputController = TextEditingController();
  final TextEditingController textCurrent = TextEditingController();

  final ValueNotifier<PickerFont> _fontValue =
      ValueNotifier<PickerFont>(PickerFont.fromFontSpec(defaultFontSpec));
  PickerFont font = PickerFont.fromFontSpec(defaultFontSpec);
  // font in Edit dialog
  String dialogFont = defaultFontSpec;
  Color color = Colors.black;
  // list of Text objects
  List<TextData> txtList = [];
  // current Text index
  int idx = 0;
  // Tutorial showed with long delay only first time
  bool tutorialShowed = false;
  bool isClicked = false;
  late Timer _timer;

  void uglyClickHandler() {
    if (isClicked)
      _timer = Timer(Duration(microseconds: 300), () => isClicked = false);
  }

  // save image (screenshot)
  void saveImage(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        showSnack(context, 'Saving image..');
        if (kIsWeb) {
          // working ONLY with 'html' renderer
          js.context.callMethod("saveAs", <Object>[
            html.Blob(<Object>[image]),
            'MEME_${DateTime.now().millisecondsSinceEpoch}.jpg'
          ]);

          // working ONLY with 'canvaskit' renderer

          //await XFile.fromData(image,
          //        mimeType: 'image/jpg',
          //        name: 'MEME_${DateTime.now().millisecondsSinceEpoch}.jpg')
          //    .saveTo('.');
        } else {
          saveLocally(image);
        }
      }
    }).catchError((err) {
      debugPrint(err.toString());
      showSnack(context, 'Loading image error', bgColor: Colors.red);
    });
  }

  // save image locally for not web platforms
  void saveLocally(Uint8List bytes) async {
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes,
        name: 'MEME_${DateTime.now().millisecondsSinceEpoch}.jpg');
  }

  void removeText(BuildContext context) {
    setState(() {
      txtList.removeAt(idx);
    });
    showSnack(context, 'Text Deleted');
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

  void alignCenter() {
    setState(() {
      if (txtList.isEmpty) return;
      txtList[idx].textAlign = TextAlign.center;
    });
  }

  // increase "height" (LineSpace) up to 3.0 by 0.1 (then reset to 1.0)
  // TODO: add UI slider?
  // TODO: move to consts or config (step and max)

  void changeLineSpace() {
    setState(() {
      if (txtList.isEmpty) return;
      if (!txtList[idx].text.contains("\n")) {
        showSnack(context, "Text without lines");
        return;
      } else {
        txtList[idx].height =
            txtList[idx].height > 3 ? 1.0 : txtList[idx].height += 0.1;
      }
    });
  }

  // increase "letterSpace" up to 20 by 1 (then reset to 1.0)
  // TODO: add UI slider?
  // TODO: move to consts or config (step and max)

  void changeLetterSpace() {
    setState(() {
      if (txtList.isEmpty) return;
      txtList[idx].letterSpace =
          txtList[idx].letterSpace > 20 ? 1.0 : txtList[idx].letterSpace += 1;
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
            color: color,
            fontSize: 50,
            height: 1.0,
            letterSpace: 1.0,
            font: font),
      );
      idx = txtList.length - 1;
      if (tutorialShowed) {
        showSnack(context, "New text added");
      } else {
        showSnack(context,
            "💡 Use tools at top bar to change selected text parameters\n\nSingle Tap (click) - SELECT text\nDouble Tap (click) - EDIT text\nLong tap (click) - DELETE text",
            bgColor: Colors.lightBlue, delaySec: 10);
        tutorialShowed = true;
      }
      Navigator.of(context).pop();
    });
  }

  void editText(BuildContext context, int txtIdx) {
    setState(() {
      if (txtList.length <= txtIdx) return;
      if (dialogFont != font.toFontSpec()) txtList[txtIdx].font = font;
      txtList[txtIdx].text = textInputController.text;
      Navigator.of(context).pop();
    });
  }

  // show Add/Edit text dialog
  // textIndex = -1 (default, Add mode)

  void showAddDialog(BuildContext context, {int txtIdx = -1}) {
    var _btnLabel = "Add";
    // save current font before showing Add/Edit dialog
    dialogFont = font.toFontSpec();
    final edit_mode = txtIdx > -1;
    // Add mode
    if (!edit_mode) {
      textInputController.text = '';
      // Edit mode
    } else {
      font = txtList[txtIdx].font;
      _btnLabel = "Update";
      // validate textIndex
      if (txtList.length <= txtIdx) return;
      textInputController.text = txtList[txtIdx].text;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          edit_mode ? 'Edit Text' : 'Add New Text',
        ),
        content: Column(children: [
          TextField(
            controller: textInputController,
            maxLines: 3,
            decoration: const InputDecoration(
              filled: true,
              hintText: 'type your text',
            ),
          ),
          FontExample(fontValue: _fontValue)
        ]),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: () => showFontPicker(context),
                  child: const Text('Font')),
              ElevatedButton(
                onPressed: () =>
                    edit_mode ? editText(context, txtIdx) : addNewText(context),
                child: Text(_btnLabel),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showFontPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: FontPicker(
                showInDialog: true,
                //initialFontFamily: defaultFontSpec.split(":")[0],
                onFontChanged: (f) {
                  setState(() {
                    font = f;
                    _fontValue.value = f;
                  });
                  debugPrint(
                    "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}",
                  );
                },
                googleFonts: googleFonts,
              ),
            ),
          ),
        );
      },
    );
  }
}
