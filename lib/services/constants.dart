

import 'dart:ui';

import 'package:flutter/material.dart';

const int NBR_ROWS = 14;
const int NBR_COLS = 14;
const int NBR_SQUARES = NBR_ROWS * NBR_COLS;

const int NO_CHAR_SELECTED = 9999;

const Color BACKGROUND_DEFAULT_COLOR = Colors.blueGrey;

const List<Color> BACKGROUND_COLORS = [
  Colors.black,
  Colors.pinkAccent,
  Colors.deepPurple,
  Colors.blue,
  Colors.orangeAccent,
  Colors.green,
  Colors.red,
  Colors.pink,
  Colors.indigo,
  Colors.deepOrange,
  Colors.teal,
  Color(0xFF303F9F),  //INDIGO[700]
  Colors.brown,
  Colors.deepPurpleAccent,
  Color(0xFF8FCAF4),  //pink[200]
  Color(0xFFEC407A),  //pink[400]
  Color(0xFFD81B60),  //pink[600]
  Color(0xFFD32F2F),  //red[700]
  Color(0xFF66BB6A),  //green[400]
  Color(0xFF388E3C),  //green[700]
  Color(0xFF1B5E20),  //green[900]
  Color(0xFF00796B),  //TEAL[700]
  Color(0xFF004D40),  //TEAL[900]
  Color(0xFF00838F),  //CYAN[800]
  Color(0xFF1976D2),  //BLUE[700]
  Color(0xFF303F9F),  //INDIGO[700]
  Color(0xFF1A237E),  //INDIGO[900]
  Color(0xFF6A1B9A),  //PURPLE[800]
  Color(0xFF512DA8),  //DEEP PURPLE[700]
];

