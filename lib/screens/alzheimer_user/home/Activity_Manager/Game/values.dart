  
  import 'package:flutter/material.dart';

int rowLength = 10;
  int colLength = 15;

enum Direction {
  left,
  right,
  down,
}
enum TetroMino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<TetroMino, Color> tetrominoColors = {
  TetroMino.L: Colors.orange,
  TetroMino.J: Colors.blue,
  TetroMino.I: Colors.pink,
  TetroMino.O: Colors.yellow,
  TetroMino.S: Colors.green,
  TetroMino.Z: Colors.red,
  TetroMino.T: Colors.purple,
}; 