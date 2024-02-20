import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/screens/edit_image.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);
  final txtController = TextEditingController();
  late XFile img;

  showLinkDialog(context) {
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              var link = txtController.text;

              //final resp = await http.get(Uri.());
              //resp.bodyBytes;
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          IconButton(
            tooltip: "Upload from Internet",
            icon: const Icon(
              Icons.upload_file,
              size: 50,
            ),
            onPressed: () async {
              showLinkDialog(context);
            },
          ),
          IconButton(
            tooltip: "Upload from gallery",
            icon: const Icon(
              Icons.computer,
              size: 50,
            ),
            onPressed: () async {
              XFile? file = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );

              if (file != null) {
                var size = await file.length();
                var image_content = await file.readAsBytes();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    duration: Duration(seconds: 1),
                    content: Text(
                      "Uploading file \n" +
                          file.name.toString() +
                          " [size: ${size}]...",
                    ),
                  ),
                );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditScreen(
                      isWeb: kIsWeb,
                      img: Image.memory(
                        image_content,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                );
              }
            },
          )
        ],
      )),
    );
  }
}
