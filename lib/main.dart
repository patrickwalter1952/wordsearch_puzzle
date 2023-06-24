
import 'package:flutter/material.dart';
import 'package:wordsearch_puzzle/screens/home_page.dart';
import 'package:wordsearch_puzzle/screens/word_search_home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

Future initialization(BuildContext? context) async {
  //Load resources
  await Future.delayed(const Duration(seconds: 3));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: HomePage(),
    );
  }
}