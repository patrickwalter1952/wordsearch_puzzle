import 'dart:collection';
import 'dart:ui';

import 'package:wordsearch_puzzle/models/word_data_model.dart';

import '../services/constants.dart';
import '../wordsearch_lib/utils.dart';
import '../wordsearch_lib/word_search.dart';

late WSNewPuzzle newPuzzle;
List<WSLocation> gridWordLocations = [];
List<String> words = [];
List<String> wordSearchMatrix = [];
List<int> currentWordIndexes = [];

Map<String, List<int>> gridWordIndexes = {};
int nextWordColorIndex = 0;
Map<String, Color> gridWordColor = {};

int nbrRowsCols = NBR_COLS;

///
/// reset the grid attributes for the next created grid
///
void resetGridAttributes() {
  gridWordLocations = [];
  words = [];
  wordSearchMatrix = [];
  currentWordIndexes = [];

  gridWordIndexes = {};
  gridWordColor = {};
  nextWordColorIndex = 0;
}

///
/// create a new Word Search Data grid
///
List<String> createNewWordSearchData(String title) {
  words = getWords(title);

  nbrRowsCols = getNumberOfRowsAndCols(title);

  // Create new instance of the WordSearch class
  WordSearch wordSearch = WordSearch();

  // Create the puzzle settings object
  final WSSettings wordSearchSettings = WSSettings(
    width: nbrRowsCols,
    height: nbrRowsCols,
    orientations: List.from([
      WSOrientation.horizontal,
      WSOrientation.horizontalBack,
      WSOrientation.vertical,
      WSOrientation.verticalUp,
      WSOrientation.diagonal,
      WSOrientation.diagonalBack,
      WSOrientation.diagonalUp,
      WSOrientation.diagonalUpBack,
    ]),
  );

  // Create a new puzzle
  newPuzzle = wordSearch.newPuzzle(words, wordSearchSettings);

  //if the grid grew larger that expected, don't process
  if (newPuzzle.puzzle.length > wordSearchSettings.width) {
    return [];
  }

  //TODO: ADD DIALOG OF ERRORS
  if (!_validWordSearchBoard(newPuzzle, wordSearch)) {
    // Notify the user of the errors
    newPuzzle.errors.forEach((error) {
      print(error);
    });
    return [];
  }

  _setWordSearchMatrix(newPuzzle);

  _setWordLocationsFromGrid(newPuzzle, wordSearch, words);

  return wordSearchMatrix;
}

///
/// get the selected word based on the index
///
String getSelectedCharacter(int index) {
  return wordSearchMatrix[index];
}

///
/// Validate the new Word Search grid created
///
bool _validWordSearchBoard(WSNewPuzzle newPuzzle, WordSearch wordSearch) {
  /// Check if there are errors generated while creating the puzzle
  if (newPuzzle.errors.isEmpty) {

    // Solve puzzle for given word list
    final WSSolved solved = wordSearch.solvePuzzle(
        newPuzzle.puzzle, words);

    // All words that could not be found
    if (solved.notFound.length > 0) {

      solved.notFound.forEach((element) {
        print('word: ${element}');
      });
    }
  } else {
    // Notify the user of the errors
    newPuzzle.errors.forEach((error) {
      print(error);
    });
  }

  return newPuzzle.errors.isEmpty;
}

///
/// set the word locations list
///
void _setWordLocationsFromGrid(WSNewPuzzle newPuzzle, WordSearch wordSearch,
    List<String> words) {

  // Solve puzzle for given word list
  final WSSolved solved = wordSearch.solvePuzzle(newPuzzle.puzzle, words);

  // All found words by solving the puzzle
  solved.found.forEach((element) {
    gridWordLocations.add(element);
  });

}

///
/// set the Word Search character matrix
///
void _setWordSearchMatrix(WSNewPuzzle puzzle) {
  int ndx = 0;
  for (int i = 0; i < puzzle.puzzle.length; i++) {
    for (int j = 0; j < puzzle.puzzle.length; j++) {
      wordSearchMatrix.add(puzzle.puzzle[i][j].toUpperCase());
      ndx++;
    }
  }
}

///
/// get the selected word from the data grid based on start and stop indexes
///
String getSelectedWordFromGrid(int startNdx, int stopNdx) {
  String selectedWord = "";
  String wordReversed = "";
  List<int> wordIndexes = [];

  if (startNdx < 0 || stopNdx < 0 || startNdx == stopNdx) {
    return "";
  }

  int startColNdx = startNdx % nbrRowsCols;
  int startRowNdx = startNdx ~/ nbrRowsCols;

  int stopColNdx = stopNdx % nbrRowsCols;
  int stopRowNdx = stopNdx ~/ nbrRowsCols;

  //
  // get selected word, could be in reverse order
  //
  //selection was same row
  if (startRowNdx == stopRowNdx) {
    int fromNdx = startNdx < stopNdx ? startNdx : stopNdx;
    int toNdx = startNdx < stopNdx ? stopNdx : startNdx;
    for (int i = fromNdx; i <= toNdx; i++) {
      selectedWord = selectedWord + wordSearchMatrix[i];
      wordIndexes.add(i);
    }

    wordReversed = selectedWord.split('').reversed.join('');

  } else if (startColNdx == stopColNdx) {
    //selection was same col
    int fromNdx = startNdx < stopNdx ? startNdx : stopNdx;
    int toNdx = startNdx < stopNdx ? stopNdx : startNdx;

    for (int i = fromNdx; i <= toNdx; i = i + nbrRowsCols) {
      selectedWord = selectedWord + wordSearchMatrix[i];
      wordIndexes.add(i);
    }

    wordReversed = selectedWord.split('').reversed.join('');

  } else {
    //selection is a diagonal
    if (startNdx < stopNdx) {
      //selection is down to left or right
      for (int i = startNdx; i <= stopNdx;
            i = i + (startColNdx < stopColNdx ? nbrRowsCols + 1 : nbrRowsCols - 1)) {
        selectedWord = selectedWord + wordSearchMatrix[i];
        wordIndexes.add(i);
      }

      wordReversed = selectedWord.split('').reversed.join('');

    } else {
      //selection is up to left or right
      for (int i = startNdx; i >= stopNdx;
            i = i - (startColNdx > stopColNdx ? nbrRowsCols + 1 : nbrRowsCols - 1)) {
        selectedWord = selectedWord + wordSearchMatrix[i];
        wordIndexes.add(i);
      }

      wordReversed = selectedWord.split('').reversed.join('');

    }
  }

  //return the word or its reverse if found
  if (words.contains(selectedWord)) {
    currentWordIndexes.addAll(wordIndexes);
    gridWordIndexes.putIfAbsent(selectedWord, () => wordIndexes);
    gridWordColor.putIfAbsent(selectedWord, () => BACKGROUND_COLORS[nextWordColorIndex]);
    nextWordColorIndex++;
    return selectedWord;
  }

  if (words.contains(wordReversed)) {
    currentWordIndexes.addAll(wordIndexes);
    gridWordIndexes.putIfAbsent(selectedWord, () => wordIndexes);
    gridWordColor.putIfAbsent(selectedWord, () => BACKGROUND_COLORS[nextWordColorIndex]);
    nextWordColorIndex++;
    return wordReversed;
  }

  //word not found but still return invalid word
  return selectedWord;
}

///
/// get the list of current word indexes from the grid
///
List<int> getCurrentWordGridIndexes() {
  return currentWordIndexes;
}

///
/// get the associated background color for the word based on the grid index
///
Color getBackgroundWordColorFromGridIndex(int index) {
  String indexWord = '';
  gridWordIndexes.forEach((key, value) {
    if (value.contains(index)) {
      indexWord = key;
    }
  });
  if (indexWord == '') {
    return BACKGROUND_DEFAULT_COLOR;
  }
  return gridWordColor[indexWord] ?? BACKGROUND_DEFAULT_COLOR;
}
///
/// get the associated background color for the word
///
Color getCurrentWordColorFromWord(String word) {
  return gridWordColor[word] ?? BACKGROUND_DEFAULT_COLOR;
}

///
/// determine if the selected word in the list of current words to search
///
bool isSelectedGridWordInWords(String selectedWord) {
  //return the word or its reverse if found
  return words.contains(selectedWord);
}

///
/// find the requested word on the grid
///
bool findAndSetGridNewWord(String nextWord) {
  int x = 0;
  int y = 0;
  int startNdx = 0;
  int stopNdx = 0;
  WSOrientation wordOrientation = WSOrientation.horizontal;
  for (int i = 0; i < gridWordLocations.length; i++) {
    if (gridWordLocations[i].word == nextWord) {
      x = gridWordLocations[i].x;
      y = gridWordLocations[i].y;
      wordOrientation = gridWordLocations[i].orientation;
      break;
    }
  }

  //find the start and stop indexes based on the complete grid
  startNdx = y * nbrRowsCols + x;
  int wordSize = nextWord.length - 1;
  switch (wordOrientation) {
    case WSOrientation.horizontal:
      //to right
      stopNdx = startNdx + wordSize;
      break;
    case WSOrientation.horizontalBack:
      //to left
      stopNdx = startNdx - wordSize;
      break;
    case WSOrientation.vertical:
      //down
      stopNdx = startNdx + wordSize * nbrRowsCols;
      break;
    case WSOrientation.verticalUp:
      //up
      stopNdx = startNdx - wordSize * nbrRowsCols;
      break;
    case WSOrientation.diagonal:
      //down to right
      stopNdx = (startNdx + wordSize * nbrRowsCols) + wordSize;
      break;
    case WSOrientation.diagonalUp:
      //up to right
      stopNdx = (startNdx - wordSize * nbrRowsCols) + wordSize;
      break;
    case WSOrientation.diagonalBack:
      //down to left
      stopNdx = (startNdx + wordSize * nbrRowsCols) - wordSize;
      break;
    case WSOrientation.diagonalUpBack:
      //up to left
      stopNdx = (startNdx - wordSize * nbrRowsCols) - wordSize;
      break;
    default:
      //this should not be needed
  }

  //get selected word from the grid
  String word = getSelectedWordFromGrid(startNdx, stopNdx);

  //did it find the next word?
  return words.contains(word);
}

