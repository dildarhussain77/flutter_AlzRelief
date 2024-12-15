import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/Game/values.dart';

const int columnCount = 10;
const int rowCount = 20;

class Piece {
  TetroMino type;
  List<int> position = [];
  int rotationState = 0;

  Piece({required this.type});

  Color get color {
    return tetrominoColors[type] ?? const Color(0x00000000);
  }

  void initializePiece() {
    switch (type) {
      case TetroMino.L:
        position = [-26, -16, -6, -5];
        break;
      case TetroMino.J:
        position = [-25, -15, -5, -6];
        break;
      case TetroMino.I:
        position = [-4, -5, -6, -7];
        break;
      case TetroMino.O:
        position = [-15, -16, -5, -6];
        break;
      case TetroMino.S:
        position = [-15, -14, -6, -5];
        break;
      case TetroMino.Z:
        position = [-17, -16, -6, -5];
        break;
      case TetroMino.T:
        position = [-26, -16, -6, -15];
        break;
      default:
        break;
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += columnCount;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
    }
  }

  void rotatePiece() {
    List<int> newPosition = [];
    switch (type) {
      case TetroMino.L:
        newPosition = _calculateRotationLShape();
        break;
      case TetroMino.J:
        newPosition = _calculateRotationJShape();
        break;
      case TetroMino.I:
        newPosition = _calculateRotationIShape();
        break;
      case TetroMino.O:
        return; // O shape does not rotate
      case TetroMino.S:
        newPosition = _calculateRotationSShape();
        break;
      case TetroMino.Z:
        newPosition = _calculateRotationZShape();
        break;
      case TetroMino.T:
        newPosition = _calculateRotationTShape();
        break;
    }
    _updatePosition(newPosition);
  }

  List<int> _calculateRotationLShape() {
    int pivot = position[1];
    switch (rotationState) {
      case 0:
        return [pivot - columnCount, pivot, pivot + columnCount, pivot + columnCount + 1];
      case 1:
        return [pivot - 1, pivot, pivot + 1, pivot + columnCount - 1];
      case 2:
        return [pivot + columnCount, pivot, pivot - columnCount, pivot - columnCount - 1];
      case 3:
        return [pivot - columnCount + 1, pivot, pivot + 1, pivot - 1];
      default:
        return position;
    }
  }

  List<int> _calculateRotationJShape() {
    int pivot = position[1];
    switch (rotationState) {
      case 0:
        return [pivot - columnCount, pivot, pivot + columnCount, pivot + columnCount - 1];
      case 1:
        return [pivot - columnCount - 1, pivot, pivot - 1, pivot + 1];
      case 2:
        return [pivot + columnCount, pivot, pivot - columnCount, pivot - columnCount + 1];
      case 3:
        return [pivot + 1, pivot, pivot - 1, pivot + columnCount + 1];
      default:
        return position;
    }
  }

  List<int> _calculateRotationIShape() {
    int pivot = position[1];
    switch (rotationState) {
      case 0:
        return [pivot - 1, pivot, pivot + 1, pivot + 2];
      case 1:
        return [pivot - columnCount, pivot, pivot + columnCount, pivot + 2 * columnCount];
      case 2:
        return [pivot + 1, pivot, pivot - 1, pivot - 2];
      case 3:
        return [pivot + columnCount, pivot, pivot - columnCount, pivot - 2 * columnCount];
      default:
        return position;
    }
  }

  List<int> _calculateRotationSShape() {
    int pivot = position[1];
    switch (rotationState) {
      case 0:
      case 2:
        return [pivot + 1, pivot, pivot + columnCount, pivot + columnCount - 1];
      case 1:
      case 3:
        return [pivot - columnCount, pivot, pivot + 1, pivot + columnCount + 1];
      default:
        return position;
    }
  }

  List<int> _calculateRotationZShape() {
    int pivot = position[1];
    switch (rotationState) {
      case 0:
      case 2:
        return [pivot - columnCount + 1, pivot, pivot + columnCount, pivot + columnCount - 1];
      case 1:
      case 3:
        return [pivot - columnCount, pivot, pivot + 1, pivot + columnCount + 1];
      default:
        return position;
    }
  }

  List<int> _calculateRotationTShape() {
    int pivot = position[1];
    switch (rotationState) {
      case 0:
        return [pivot - columnCount, pivot, pivot + 1, pivot + columnCount];
      case 1:
        return [pivot - columnCount, pivot, pivot - 1, pivot + columnCount];
      case 2:
        return [pivot + columnCount, pivot, pivot - 1, pivot - columnCount];
      case 3:
        return [pivot + columnCount, pivot, pivot + 1, pivot - columnCount];
      default:
        return position;
    }
  }

  void _updatePosition(List<int> newPosition) {
    if (piecePositionIsValid(newPosition)) {
      position = newPosition;
      rotationState = (rotationState + 1) % 4;
    }
  }

  bool piecePositionIsValid(List<int> newPosition) {
    for (int i = 0; i < newPosition.length; i++) {
      int x = newPosition[i] % columnCount;
      int y = newPosition[i] ~/ columnCount;
      if (x < 0 || x >= columnCount || y >= rowCount) {
        return false;
      }
      // Assuming grid is a 2D array, check if the spot is occupied by another piece
      // Replace this with your actual grid state checking logic
      if (false) { // Check grid state here
        return false;
      }
    }
    return true;
  }
}
