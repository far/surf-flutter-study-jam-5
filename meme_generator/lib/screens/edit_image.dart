import 'package:flutter/material.dart';
import 'package:meme_generator/widgets/edit_image_vm.dart';
import 'package:meme_generator/widgets/image_text.dart';
import 'package:screenshot/screenshot.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.isWeb, required this.img})
      : super(key: key);
  final bool isWeb;
  final Widget img;

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends EditImageVM {
  @override
  Widget build(BuildContext context) {
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
                      onLongPress: () {
                        setState(() {
                          idx = i;
                          removeText(context);
                        });
                      },
                      onTap: () => setCurrentIdx(context, i),
                      child: Draggable(
                        feedback: TextImage(textData: txtList[i]),
                        child: TextImage(textData: txtList[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            txtList[i].top = off.dy - 96;
                            txtList[i].left = off.dx;
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
              onPressed: () => saveLocally(context),
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
                Icons.format_bold,
                color: Colors.black,
              ),
              onPressed: boldText,
              tooltip: 'Bold Text',
            ),
            IconButton(
              icon: const Icon(
                Icons.format_italic,
                color: Colors.black,
              ),
              onPressed: italicText,
              tooltip: 'Italic Text',
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
            Tooltip(
              message: 'Black Text Color',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.black),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Tooltip(
              message: 'White Text Color',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.white),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Tooltip(
              message: 'Red Text Color',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.red),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.red),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Tooltip(
              message: 'Green Text Color',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.green),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.green),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Tooltip(
              message: 'Yellow Text Color',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.blue),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Tooltip(
              message: 'Yellow Text Color',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.yellow),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.yellow),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Tooltip(
              message: 'Pink Text Color',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.orange),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.orange),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Tooltip(
              message: 'Purple',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.purple),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.purple),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Tooltip(
              message: 'Grey',
              child: GestureDetector(
                onTap: () => changeTextColor(Colors.grey),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
          ],
        ),
      ));
}
