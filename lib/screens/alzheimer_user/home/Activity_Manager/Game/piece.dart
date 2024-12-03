import 'dart:ui';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Game/game_board_screen.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Game/values.dart';
import 'package:flutter/material.dart';


class Piece {
  TetroMino type;

  
  Piece({required this.type});

  //the piece is just  list of integers
  List<int> position = [];

  //color of tetris pieces
  Color get color {
    return tetrominoColors[type] ??
      const Color(0x00000000);

  }

  //generate the integer
  void initializePiece (){
    switch (type) {      
      case TetroMino.L:
        position = [
          -26,
          -16,
          -6,
          -5,
        ];
        break;
      case TetroMino.J:
        position = [
          -25,
          -15,
          -5,
          -6,
        ];
        break;
      case TetroMino.I:
        position = [
          -4,
          -5,
          -6,
          -7,
        ];
        break;
      case TetroMino.O:
        position = [
          -15,
          -16,
          -5,
          -6,
        ];
        break;
      case TetroMino.S:
        position = [
          -15,
          -14,
          -6,
          -5,
        ];
        break;
      case TetroMino.Z:
        position = [
          -17,
          -16,
          -6,
          -5,
        ];
        break;
      case TetroMino.T:
        position = [
          -26,
          -16,
          -6,
          -15,
        ];
        break;
      default:    
    }
  }

 

  void movePiece(Direction direction){
    switch (direction) {
      case Direction.down:
        for(int i = 0; i<position.length;i++){
          position[i] += rowLength;
        }        
        break;
      case Direction.left:
        for(int i = 0; i<position.length;i++){
          position[i] -= 1;
        }        
        break;
      case Direction.right:
        for(int i = 0; i<position.length;i++){
          position[i] += 1;
        }        
        break;
      default:
    }
  }

  int rotationState =1;
  void rotatePiece(){
    //new position
    List<int> newPosition = [];

    //roate the piece based on its type
    switch (type) {
      case TetroMino.L:
        switch(rotationState){
          case 0:
          /*

          o
          o
          o o
        
          */

          //get the new position
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + rowLength,
            position[1] + rowLength + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 1:
          /*
          
          o o o
          o
        
          */

          //get the new position
          newPosition = [
            position[1] - 1,
            position[1],
            position[1] + 1,
            position[1] + rowLength - 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          
          break;
        
        case 2:
          /*

          o o
            o
            o
        
          */

          //get the new position
          newPosition = [
            position[1] + rowLength,
            position[1],
            position[1] - rowLength,
            position[1] - rowLength - 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 3:
          /*

              o         
          o o o
        
          */

          //get the new position
          newPosition = [
            position[1] - rowLength + 1,
            position[1],
            position[1] + 1,
            position[1] - 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;
        }
        
        break;

      case TetroMino.J:
        switch(rotationState){
          case 0:
          /*

            o
            o
          o o 
          
          */

          //get the new position
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + rowLength,
            position[1] + rowLength - 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 1:
          /*
          
          o
          o o o
                  
          */

          //get the new position
          newPosition = [
            position[1] - rowLength - 1,
            position[1],
            position[1] - 1,
            position[1] + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          
          break;
        
        case 2:
          /*

          o o
          o
          o
      
          */

          //get the new position
          newPosition = [
            position[1] + rowLength,
            position[1],
            position[1] - rowLength,
            position[1] - rowLength + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 3:
          /*
         
          o o o
              o
        
          */

          //get the new position
          newPosition = [
            position[1] + 1,
            position[1],
            position[1] - 1,
            position[1] + rowLength + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;
        }
        
        break;
      
      case TetroMino.I:
        switch(rotationState){
          case 0:
          /*
            
          o o o o
          
          */

          //get the new position
          newPosition = [
            position[1] - 1,
            position[1],
            position[1] + 1,
            position[1] + 2,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 1:
          /*
          
          o
          o 
          o
          o
                  
          */

          //get the new position
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + rowLength,
            position[1] + 2 * rowLength,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          
          break;
        
        case 2:
          /*

          o o o o
      
          */

          //get the new position
          newPosition = [
            position[1] + 1,
            position[1],
            position[1] - 1,
            position[1] - 2,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 3:
          /*
          
          o
          o 
          o
          o
                  
          */


          //get the new position
          newPosition = [
            position[1] + rowLength,
            position[1],
            position[1] - rowLength,
            position[1] - 2 * rowLength,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;
        }
        
        break;

      case TetroMino.O:
          /*
          the o tetromino does not need to rotate
          
          o o
          o o
                  
          */

        break;

      case TetroMino.S:
        switch(rotationState){
          case 0:
          /*
            
            o o
          o o

          */

          //get the new position
          newPosition = [
            position[1],
            position[1] + 1,
            position[1] + rowLength -1,
            position[1] + rowLength,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 1:
          /*
                    
          o 
          o o
            o
                  
          */

          //get the new position
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + 1,
            position[1] + rowLength + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          
          break;
        
        case 2:
          /*
            
            o o
          o o

          */

          //get the new position
          newPosition = [
            position[1],
            position[1] + 1,
            position[1] + rowLength -1,
            position[1] + rowLength,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 3:
           /*
                    
          o 
          o o
            o
                  
          */

          //get the new position
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + 1,
            position[1] + rowLength + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;
        }
        
        break;
      
      case TetroMino.Z:
        switch(rotationState){
          case 0:
          /*
            
          o o
            o o

          */

          //get the new position
          newPosition = [
            position[1] + rowLength -2,
            position[1],
            position[1] + rowLength -1,
            position[1] + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 1:
          /*
                            
            o
          o o
          o

          */

          //get the new position
          newPosition = [
            position[1] - rowLength + 2,
            position[1],
            position[1] - rowLength +1,
            position[1] - 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          
          break;
        
        case 2:
          /*
            
          o o
            o o

          */

          //get the new position
          newPosition = [
            position[1] + rowLength -2,
            position[1],
            position[1] + rowLength -1,
            position[1] + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 3:
           /*
                            
            o
          o o
          o

          */

          //get the new position
          newPosition = [
            position[1] - rowLength + 2,
            position[1],
            position[1] - rowLength +1,
            position[1] - 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;
        }
        
        break;

      case TetroMino.T:
        switch(rotationState){
          case 0:
          /*
            
          o
          o o
          o

          */

          //get the new position
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] + 1,
            position[1] + rowLength,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 1:
          /*
                            
          o o o
            o
          
          */

          //get the new position
          newPosition = [
            position[1] - 1,
            position[1],
            position[1] + 1,
            position[1] + rowLength,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          
          break;
        
        case 2:
          /*
            
            o
          o o 
            o

          */

          //get the new position
          newPosition = [
            position[1] - rowLength,
            position[1],
            position[1] - 1,
            position[1] + rowLength,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;

        case 3:
           /*
                            
            o
          o o o

          */

          //get the new position
          newPosition = [
            position[1] - rowLength,
            position[1] - 1,
            position[1],
            position[1] + 1,
          ];
          //check that this position is valid move before assigning it to the real position
          if(piecePositionIsValid(newPosition)){
            //update the postion
            position = newPosition;
            //update rotate state
            rotationState = (rotationState + 1) % 4;
          }          
          break;
        }
        
        break;

      default:
    }
  }

  bool positionIsValid(int position){
    int row = (position/rowLength).floor();
    int col = position%rowLength;

    //if the position is taken, return false
    // if(row < 0 || col < 0 || gameBoard[row][col] != null){
      if (row < 0 || row >= rowLength || col < 0 || col >= rowLength) {
      return false;
    }

    // Check if the position is already taken on the game board
    return gameBoard[row][col] == null;
    //otherwise position is valid, retunn true
    // else{
    //   return true;
    // }
  }

//   bool piecePositionIsValid(List<int> piecePosition) {
//   for (int pos in piecePosition) {
//     int row = (pos / rowLength).floor();
//     int col = pos % rowLength;

//     // Check if the position is out of bounds
//     if (row >= colLength || col < 0 || col >= rowLength) {
//       return false;
//     }

//     // Check if the position overlaps with an existing piece
//     if (gameBoard[row][col] != null) {
//       return false;
//     }
//   }
//   return true;
// }

  bool piecePositionIsValid(List<int>piecePosition){
    bool firstColOccupied = false;
    bool lastColOccopied = false;

    for(int pos in piecePosition){
      //return false if any position is already taken 
      if(!positionIsValid(pos)){
        return false;
      }
      //get the column of position
      int col = pos % rowLength;

      //check if first and last column is occupied
      if(col == 0){
        firstColOccupied = true;
      }
      if(col == rowLength-1){
        lastColOccopied = true;
      }
    }
    //if there is a piece in first column and last col, it is going through the wall
    return !(firstColOccupied && lastColOccopied);
  }
}