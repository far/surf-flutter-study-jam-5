import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/screens/edit_image.dart';

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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              var link = txtController.text;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditScreen(
                    img: Image.network(
                      link,
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
                        return const Text(
                          "Upload Error",
                        );
                      },
                    ),
                  ),
                ),
              );
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
          const SizedBox(
            height: 50,
          ),
          IconButton(
            tooltip: "Upload from Internet",
            icon: const Icon(Icons.upload_file, size: 50, color: Colors.blue),
            onPressed: () async {
              showLinkDialog(context);
            },
          ),
          const SizedBox(
            height: 50,
          ),
          IconButton(
            tooltip: "Upload from gallery",
            icon: const Icon(Icons.computer, size: 50, color: Colors.green),
            onPressed: () async {
              XFile? file = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );

              if (file != null) {
                var size = await file.length();
                var image_content = await file.readAsBytes();
                Future.delayed(Duration.zero, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: const Duration(seconds: 1),
                      content: Text(
                          "Uploading file \n${file.name.toString()} [size: ${size}]..."),
                    ),
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        img: Image.memory(
                          image_content,
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
