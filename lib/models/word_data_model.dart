
import 'package:wordsearch_puzzle/services/constants.dart';

import '../data/word_data.dart';

///--------------------------------------------
/// WordDataModel
/// -------------------------------------------
class WordDataModel {
  final String category;
  final String title;
  final int nbrRowCol;
  final List<String> words;

  WordDataModel( {
    required this.category,
    required this.title,
    required this.nbrRowCol,
    required this.words,
  });

  factory WordDataModel.fromJason(Map<String, dynamic> parsedJson) {
    return WordDataModel(
        category: parsedJson['category'],
        title: parsedJson['title'],
        nbrRowCol: parsedJson['nbrRowCol'],
        words: parsedJson['words']);

  }
}

Map<String, dynamic> getWordDataMap(String title) {
  for (int i = 0; i < wordDataList.length; i++) {
    Map<String, dynamic> data = wordDataList[i];
    if (data['title'] == title) {
      return data;
    }
  }
  return wordDataList[0];
}

List<String> getWordCategories() {
  List<String> wordCategories = [];
  for (int i = 0; i < wordDataList.length; i++) {
    Map<String, dynamic> data = wordDataList[i];
    if (!wordCategories.contains(data['category'])) {
      wordCategories.add(data['category']);
    }
  }

  //sort the categories
  wordCategories.sort();

  return wordCategories;
}

List<String> getTitlesForCategory(String category) {
  List<String> wordTitles = [];

  for (int i = 0; i < wordDataList.length; i++) {
    Map<String, dynamic> data = wordDataList[i];
    if (data['category'] == category) {
      wordTitles.add(data['title']);
    }
  }

  //sort the titles
  wordTitles.sort();

  return wordTitles;
}

List<String> getWordTitles() {
  List<String> wordTitles = [];
  for (int i = 0; i < wordDataList.length; i++) {
    Map<String, dynamic> data = wordDataList[i];
    wordTitles.add(data['title']);
  }
  return wordTitles;
}

int getNumberOfRowsAndCols(String title) {
  for (int i = 0; i < wordDataList.length; i++) {
    Map<String, dynamic> data = wordDataList[i];
    if (title == data['title']) {
      return data['nbrRowCol'];
    }
  }
  return NBR_ROWS;
}

List<String> getWords(String title) {
  List<String> words = [];
  for (int i = 0; i < wordDataList.length; i++) {
    Map<String, dynamic> data = wordDataList[i];
    if (title == data['title']) {
      List<String> words = data['words'];
      List<String> items = words.map((words)=>words.toUpperCase()).toList();
      items.sort();
      return items;
    }
  }
  return words;
}



