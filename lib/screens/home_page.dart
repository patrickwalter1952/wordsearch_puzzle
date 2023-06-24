
import 'package:flutter/material.dart';
import 'package:wordsearch_puzzle/screens/CategorySelectionPage.dart';
import 'package:wordsearch_puzzle/screens/word_search_home.dart';

///--------------------------------------------
///HomePage
/// -------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

///--------------------------------------------
///_HomePageState
/// -------------------------------------------
class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : const Text("Word Search Game"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment. start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget> [

            const SizedBox(height: 60),

            const Image(
              image: AssetImage('assets/images/Wordsearch2.PNG'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Welcome',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CategorySelectionPage()));
                },

                child: const Text(
                  "Word Search - Select Category",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            const SizedBox(height: 4),

            ],
          ),
      ),

      );
  }

}
