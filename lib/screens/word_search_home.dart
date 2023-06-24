
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../models/grid_data_model.dart';
import '../models/word_data_model.dart';
import '../services/constants.dart';

///--------------------------------------------
///WordSearchHome
/// -------------------------------------------
class WordSearchHome extends StatefulWidget {
  WordSearchHome({
    required this.category,
  });

  String category;

  @override
  _WordSearchHomeState createState() => _WordSearchHomeState();
}

///--------------------------------------------
///_WordSearchHomeState
/// -------------------------------------------
class _WordSearchHomeState extends State<WordSearchHome> {

  late List<String> displayElement;
  late List<String> titles;
  late List<String> words;
  List<String> words1 = [];
  List<String> words2 = [];
  List<String> words3 = [];

  int nbrRows = NBR_ROWS;
  int nbrCols = NBR_COLS;
  int nbrSquares = NBR_SQUARES;

  int charNdxSelected1 = NO_CHAR_SELECTED;
  int charNdxSelected2 = NO_CHAR_SELECTED;

  bool useCharacterBackgroundColor = true;

  String selectedWordSearchTitle = "";
  List<String> wordsFound = [];
  List<String> wordsHelpedToFind = [];

  @override
  void initState() {
    super.initState();

    // titles = getWordTitles();
    titles = getTitlesForCategory(widget.category);

    _resetBoard();
  }

  ///
  /// Reset the Word Search Board after selection of a new Title
  ///
  void _resetBoard() {
    resetGridAttributes();

    selectedWordSearchTitle =
        selectedWordSearchTitle == "" ? titles.first : selectedWordSearchTitle;
    nbrRows = getNumberOfRowsAndCols(selectedWordSearchTitle);
    nbrCols = nbrRows;
    nbrSquares = nbrRows * nbrCols;

    words = getWords(selectedWordSearchTitle);
    words1 = [];
    words2 = [];
    words3 = [];

    wordsFound = [];
    wordsHelpedToFind = [];

    charNdxSelected1 = NO_CHAR_SELECTED;
    charNdxSelected2 = NO_CHAR_SELECTED;

    int ndx = 0;
    for (int i = 0; i < words.length; i++) {
      if (0 == ndx) {
        words1.add(words[i]);
      } else if (1 == ndx) {
        words2.add(words[i]);
      } else if (2 == ndx) {
        words3.add(words[i]);
      }
      ndx = (ndx == 2 ? 0 : ndx + 1);
    }

    displayElement = createNewWordSearchData(selectedWordSearchTitle);

    if (displayElement == []) {
      _showDialog("Unable to Create Word Search Grid.\nTry another selection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title : Text("Category - ${widget.category}"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            //Build and display Word Search Titles For Game Board
            buildDisplayWordSearchTitlesMenu(),

            const SizedBox(height: 2),
            const Text(
              "Select Word, click First & Last Letters",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            //Build and display the Word Search board
            buildWordSearchBoard(),

            // const SizedBox(height: 2),

            // //Build button to reset character selections
            buildWordBackgroundColorSelectionButton(),

            //Build and display to the Words
            buildDisplayWordsToSearch(),

            // //Build button to reset character selections
            buildShowHelpFindNextWordButton(),

          ],
        ),
      ),
    );
  }

  ///
  /// Build and Display the Word Search title menus
  ///
  Column buildDisplayWordSearchTitlesMenu() {
    return Column(
      children: <Widget> [
        // const Text(
        //   "Select Word Search Title",
        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        // ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),

          margin: const EdgeInsets.all(0),

          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: selectedWordSearchTitle,
              // iconSize: 24,
              // icon: const Icon(Icons.arrow_downward),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
              ),

              menuItemStyleData: const MenuItemStyleData(
                height: 30,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              isExpanded: true,
              // elevation: 16,

              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),

              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  selectedWordSearchTitle = value!;
                  _resetBoard();
                });
              },

              items: titles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),

            ),
          ),
        ),
      ],
    );
  }

  ///
  /// Build the Game Board
  ///
  Flexible buildWordSearchBoard() {

    return Flexible(
      child: GridView.builder(
          itemCount: nbrSquares,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: sqrt(nbrSquares).round()),

          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                _tapped(index);
              },

              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30)),

                child: Center(
                  child: Text(
                    displayElement[index],
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: _getBackgroundColor(index),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  ///
  /// Get the background color of the game board cell/index
  ///
  Color _getBackgroundColor(int index) {
    //this will return colors other than black, or default blueGrey
    // if (useCharacterBackgroundColor) {
    //   return getBackgroundWordColorFromGridIndex(index);
    // }

    //this will return black or default blueGrey
    if (charNdxSelected1 == index) {
      return Colors.black;
    }

    if (getCurrentWordGridIndexes().contains(index)) {
      //color background - if set, else black or default blueGrey
      return !useCharacterBackgroundColor ? Colors.black :
              getBackgroundWordColorFromGridIndex(index);
      }

    return Colors.blueGrey;
  }

  ///
  /// Set Character selections charSelected1 & charSelected2
  ///
  void _tapped(int index) {
    setState(() {

      String selectedChar = "";
      if (charNdxSelected1 == NO_CHAR_SELECTED) {
        charNdxSelected1 = index;
        selectedChar = getSelectedCharacter(index);
        // print("charSelected1 NDX = $charNdxSelected1   CHAR = [$selectedChar]");
      } else if (charNdxSelected2 == NO_CHAR_SELECTED) {
        charNdxSelected2 = index;
        selectedChar = getSelectedCharacter(charNdxSelected1);
        // print("charSelected1 = $charNdxSelected1   CHAR = [$selectedChar]");
        selectedChar = getSelectedCharacter(charNdxSelected2);
        // print("charSelected2 = $charNdxSelected2   CHAR = [$selectedChar]");

        String word = getSelectedWordFromGrid(charNdxSelected1, charNdxSelected2);

        if (!isSelectedGridWordInWords(word)) {
          // print("WORD NOT FOUND!!: [$word]");
          String revWord = word.split('').reversed.join('');
          _showDialog("Selected Word [$word] or [$revWord] not found ");
          _resetCharacterSelections();
          return;
        }

        wordsFound.add(word);
        // print("ADDED WORD wordsFound: [$word]");

        _resetCharacterSelections();

        //did user complete the Word Search?
        if (_completedWordSearch()) {
          _showDialog("Excellent Job!!\nYou completed the Word Search."
              "${wordsHelpedToFind.isNotEmpty ? "\nWith a Little Help!" : ""}");
        }
      }

    });
  }

  ///
  /// Build and display the words to search
  ///
  Padding buildDisplayWordsToSearch() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(2),
                itemCount: words1.length,
                itemBuilder: (context, index) {
                  return Text(
                    words1[index],
                    style: TextStyle(
                        color: _getColorForWordFound(words1[index])),
                  );
                },
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(2),
                itemCount: words2.length,
                itemBuilder: (context, index) {
                  return Text(
                    words2[index],
                    style: TextStyle(
                        color: _getColorForWordFound(words2[index])),
                  );
                },
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(2),
                itemCount: words3.length,
                itemBuilder: (context, index) {
                  return Text(
                    words3[index],
                    style: TextStyle(
                        color: _getColorForWordFound(words3[index])),
                  );
                },
              ),
            ),
          ],
      ),
    );
  }

  ///
  /// determine if the word search has been completed
  ///
  bool _completedWordSearch() {
    bool found = true;
    // print("WORD FOUND SIZE: ${wordsFound.length}  DISPLAY SIZE: ${words.length}");
    for (int i = 0; i < words.length; i++) {
      if (!wordsFound.contains(words[i])) {
        found = false;
        break;
      }
    }
    return found;

  }

  ///
  /// get the color for the word if it was found on the grid
  ///
  Color _getColorForWordFound(String word) {
    // return getCurrentWordColorFromWord(word);
    if (wordsHelpedToFind.contains(word)) {
      return Colors.red.shade900;
    }

    if (wordsFound.contains(word)) {
      return Colors.green;
    }

    return Colors.black;
  }

  ///
  /// Build and display Reset Character Selection button
  ///
  Padding buildWordBackgroundColorSelectionButton() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                useCharacterBackgroundColor = true;
                _resetCharacterSelections();
              },
              child: const Text(
                "Color Background",
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                useCharacterBackgroundColor = false;
                _resetCharacterSelections();
              },
              child: const Text(
                "Black Background",
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Build and display Help Find Next Word Selection button
  ///
  Padding buildShowHelpFindNextWordButton() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _findWordAndMakeSelection,

            child: const Text(
            "Help - Find Next Word"
            ),

          ),
        ],
      ),
    );
  }

  ///
  ///
  ///
  void _findWordAndMakeSelection() {
    String nextWord = "";
    //find word that has not been selected
    for (int i = 0; i < words.length; i++) {
      if (!wordsFound.contains(words[i])) {
        nextWord = words[i];
        break;
      }
    }

    if (nextWord == "") {
      _showDialog("All Words Have Been Found!");
      return;
    }

    if (!findAndSetGridNewWord(nextWord)) {
      String revWord = nextWord.split('').reversed.join('');
      _showDialog("Next Word [$nextWord] or [$revWord] Could Not be Found in Grid.");
      return;
    }

    wordsFound.add(nextWord);
    wordsHelpedToFind.add(nextWord);

    // print("ADDED NEXT WORD wordsFound: [$nextWord]");

    _resetCharacterSelections();

    //did user complete the Word Search?
    if (_completedWordSearch()) {
      _showDialog("Excellent Job!!\nYou completed the Word Search.\nWith a Little Help!!! ");
    }

  }


  ///
  ///
  ///
  void _resetCharacterSelections() {
    setState(() {
      charNdxSelected1 = NO_CHAR_SELECTED;
      charNdxSelected2 = NO_CHAR_SELECTED;
    });
  }

  ///
  ///  dialog box
  ///
  void _showDialog(String msg) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(msg),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  _resetCharacterSelections();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}