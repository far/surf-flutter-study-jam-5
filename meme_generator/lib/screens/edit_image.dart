import 'package:flutter/material.dart';
import 'package:meme_generator/widgets/edit_image_vm.dart';
import 'package:meme_generator/widgets/image_text.dart';
import 'package:screenshot/screenshot.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.img}) : super(key: key);
  final Widget img;

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends EditImageVM {
  @override
  Widget build(BuildContext context) {
    if (color == Colors.transparent) color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: _getAppBar,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _img,
                for (int i = 0; i < txtList.length; i++)
                  Positioned(
                    left: txtList[i].left,
                    top: txtList[i].top,
                    child: GestureDetector(
                      onTap: () => setState(() {
                        idx = i;
                        // web onDoubleTap not working as double click
                        if (isClicked) {
                          showAddDialog(context, txtIdx: i);
                        } else {
                          isClicked = true;
                          uglyClickHandler();
                        }
                      }),
                      onDoubleTap: () => setState(() {
                        idx = i;
                        showAddDialog(context, txtIdx: i);
                      }),
                      onLongPress: () => setState(() {
                        idx = i;
                        removeText(context);
                      }),
                      child: Draggable(
                        feedback: TextImage(textData: txtList[i]),
                        child: TextImage(textData: txtList[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            txtList[i].top = off.dy - 60;
                            txtList[i].left = off.dx;
                            idx = i;
                          });
                        },
                      ),
                    ),
                  ),
                textCurrent.text.isNotEmpty
                    ? Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          textCurrent.text,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(
                                0.3,
                              )),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _addFButton,
    );
  }

  Widget get _img => Center(child: widget.img);

  // Floating button (Add New Text)
  Widget get _addFButton => FloatingActionButton(
        tooltip: 'Add New Text',
        backgroundColor: Colors.white,
        onPressed: () => showAddDialog(context),
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      );

  AppBar get _getAppBar => AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            IconButton(
              icon: const Icon(
                Icons.download,
                color: Colors.black,
              ),
              onPressed: () => saveImage(context),
              tooltip: 'Save Image',
            ),
            IconButton(
              icon: const Icon(
                Icons.text_increase,
                color: Colors.black,
              ),
              onPressed: incFontSize,
              tooltip: '↑ Font Size',
            ),
            IconButton(
              icon: const Icon(
                Icons.text_decrease,
                color: Colors.black,
              ),
              onPressed: decFontSize,
              tooltip: '↓ Font Size',
            ),
            IconButton(
              icon: const Icon(
                Icons.abc,
                color: Colors.black,
              ),
              onPressed: changeLetterSpace,
              tooltip: 'Letter Space',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_line_spacing_rounded,
                color: Colors.black,
              ),
              onPressed: changeLineSpace,
              tooltip: 'Line Space',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_left,
                color: Colors.black,
              ),
              onPressed: alignLeft,
              tooltip: 'Align left',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_center,
                color: Colors.black,
              ),
              onPressed: alignCenter,
              tooltip: 'Align Center',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_align_right,
                color: Colors.black,
              ),
              onPressed: alignRight,
              tooltip: 'Align Right',
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(
                Icons.format_color_text,
                color: Colors.black,
              ),
              onPressed: () async {
                showColorPicker(context);
              },
              tooltip: 'Text Color',
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Tooltip(
                    message: "Click to color selected text",
                    child: GestureDetector(
                        onTap: () => changeTextColor(color),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: color),
                          ),
                        )))),
          ],
        ),
      ));
}
