import 'package:flutter/material.dart';
import 'package:meme_generator/screens/menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meme Generator',
      theme: ThemeData.light(),
      home: MenuScreen(),
    );
  }
}
