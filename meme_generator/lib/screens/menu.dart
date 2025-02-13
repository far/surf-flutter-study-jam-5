import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/screens/edit_image.dart';
import 'package:meme_generator/utils/alert.dart';

//ignore: must_be_immutable
class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);
  final txtController = TextEditingController();
  late XFile img;

  void showLinkDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Upload Image from Internet',
        ),
        content: TextField(
          controller: txtController,
          decoration: const InputDecoration(
            filled: true,
            hintText: 'type image link here',
          ),
        ),
        actions: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            IconButton(
              icon: Icon(
                Icons.paste_rounded,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                Clipboard.getData(Clipboard.kTextPlain).then((value) {
                  if (value == null) {
                    showSnack(context, "Empty clipboard");
                  } else {
                    txtController.text = value.text!;
                  }
                });
              },
              tooltip: 'Paste from Clipboard',
            ),
            ElevatedButton(
              onPressed: () {
                // validate URL
                if (txtController.text.isEmpty) {
                  showSnack(context, 'Invalid URL', bgColor: Colors.red);
                  return;
                }
                final Uri? link = Uri.tryParse(txtController.text);
                if (!link!.hasAbsolutePath) {
                  showSnack(context, 'Invalid URL', bgColor: Colors.red);
                  return;
                }
                // download image from Internet
                // push it to EditScreen with Image.network
                showSnack(
                    context, 'Downloading image from ${txtController.text}');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditScreen(
                      img: Image.network(
                        link.toString(),
                        frameBuilder: (BuildContext context, Widget child,
                            int? frame, bool wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                            child: child,
                          );
                        },
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Text(
                            "Error downloading image ${txtController.text}",
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Upload'),
            ),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: "Upload from Internet",
            icon: const Icon(Icons.public, size: 50, color: Colors.blue),
            onPressed: () async {
              showLinkDialog(context);
            },
          ),
          IconButton(
            tooltip: "Upload from device",
            icon: const Icon(Icons.devices, size: 50, color: Colors.green),
            onPressed: () async {
              // pick the image
              XFile? file = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              // read image content (bytes)
              if (file != null) {
                var size = await file.length();
                var imageBytes = await file.readAsBytes();
                Future.delayed(Duration.zero, () {
                  showSnack(context,
                      "Uploading file \n${file.name.toString()} [size: $size]...");
                  // push it to EditScreen with Image.memory
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        img: Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  );
                });
              }
            },
          )
        ],
      )),
    );
  }
}
