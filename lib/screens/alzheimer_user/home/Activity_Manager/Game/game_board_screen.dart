import 'dart:async';
import 'dart:math';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Game/piece.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Game/pixel.dart';
import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/Game/values.dart';
import 'package:flutter/material.dart';

/*
  GAME BOARD
  THIS IS 2x2 grid with null representing an empty space
  a non empty space will have the colour to represent the landed pieces
*/
//create the game board
List<List<TetroMino?>>gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {  

  //curent tetris piece
  Piece currentPiece = Piece(type: TetroMino.L);

  //current score
  int currentScore = 0;
  
  bool gameOver = false;
    Timer? _timer; // Timer variable to keep track of the game loop

  @override
  void initState(){
    super.initState();

    //start game when app start
    startGame();
  }

  void startGame(){
    currentPiece.initializePiece();

    //frame refresh rate
    Duration frameRate = const Duration(milliseconds: 300);
    gameLoop(frameRate);

  }

  void gameLoop(Duration frameRate){
     _timer = Timer.periodic(frameRate, (timer) {
      if (!mounted) return; // Check if the widget is still mounted
        setState(() {
          //clear lines
          clearLines();

         //check landing
          checkLanding();

          //check if game is over
          if(gameOver == true){
            timer.cancel();
            showGameOverDialog();
          }

          //move current piece down
          currentPiece.movePiece(Direction.down);       
          
        });
      }
    );
  }

    void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }
  
  //game over message
  showGameOverDialog(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("Your Score is $currentScore"),
        actions: [
          TextButton(
            onPressed: (){
              //reset the game
              resetGame();

              Navigator.pop(context);
            }, 
            child: Text("Play again")
          )
        ],

      )
    );
  }

  //reset the game
  void resetGame(){
    //clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    //new game
    gameOver = false;
    currentScore = 0;

    //crete a new piece 
    createNewPiece();

    //start the game again
    startGame();
  }

  //chexk for collision in a future position
  //return true => there is collision
  //return flase => there is no collosion
  bool checkCollision(Direction direction){
    //loop through each position of the current piece
    for(int i = 0; i < currentPiece.position.length; i++){
      //calculate the row and colum for the current postion
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      //adjust the row and colum based on the direction
      if(direction == Direction.left){
        col -= 1;
      }
      else if(direction == Direction.right){
        col += 1;
      }
      else if(direction == Direction.down){
        row += 1;
      }
      //check if the piece is out of bound (either too low or too far to the left or right )
      if(row >= colLength || col < 0 || col >= rowLength){
        return true;
      }
      
    }
    //if no collisions are detected, return false
    return false;
  }

//   bool checkCollision(Direction direction) {
//   // Loop through each position of the current piece
//   for (int i = 0; i < currentPiece.position.length; i++) {
//     // Calculate the row and column for the current position
//     int row = (currentPiece.position[i] / rowLength).floor();
//     int col = currentPiece.position[i] % rowLength;

//     // Adjust the row and column based on the direction
//     if (direction == Direction.left) {
//       col -= 1;
//     } else if (direction == Direction.right) {
//       col += 1;
//     } else if (direction == Direction.down) {
//       row += 1;
//     }

//     // Check if the piece is out of bounds (either too low, too high, or too far to the left or right)
//     if (row < 0 || row >= colLength || col < 0 || col >= rowLength) {
//       return true;
//     }

//     // Check if the piece overlaps with an existing block on the board
//     if (gameBoard[row][col] != null) {
//       return true;
//     }
//   }

//   // If no collisions are detected, return false
//   return false;
// }

  

  void checkLanding(){
    //if going down is occupied
    if(checkCollision(Direction.down)){
      //mark position as occupied on gameboard
      for(int i = 0; i < currentPiece.position.length; i++){
        //calculate the row and colum for the current postion
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;           
        //check if the piece is out of bound (either too low or too far to the left or right )
        if(row >= 0 && col >= 0){
          gameBoard[row][col] = currentPiece.type;
        }
      }
      //once landed create a new next piece
      createNewPiece();
    }
  }

  void createNewPiece(){
    //create random object to generate random tetromino type
    Random rand = Random();

    //create a new piece with random type
    TetroMino randomType = 
      TetroMino.values[rand.nextInt(TetroMino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece(); 

    // Set the starting position for the new piece at the top center of the board
    

    /*

    since our game over condition is if there is a piece at the top level
    you want to check if the game is over when you create a new piece
    instead of checking evry frame because new piece are allowed to go throgh the top level
    but if ther is already a piece in the top level when a new piece is created.
    thne game is over

    */ 
    if(isGameOver()){
      gameOver = true;
    }

  }

  //move left
  void moveLeft(){
    //make sure the move is valid before moving there
    if(!checkCollision(Direction.left)){
      setState(() {
        currentPiece.movePiece(Direction.left);        
      });      
    }
  }
  //movre right
  void moveRight(){
    //make sure the move is valid before moving there
    if(!checkCollision(Direction.right)){
      setState(() {
        currentPiece.movePiece(Direction.right);
      });      
    }
  }
  //rotate piece
  void rotatePiece(){
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  //clear lines 
  void clearLines(){
    //step 1: loop through each row of the game board from bottom to top
    for(int row = colLength-1; row >= 0 ; row--){
      //step 2: initialize the variable to track if the row is full
      bool rowIsFull = true;

      //step 3: check if the row is full(all colums in the row are filled with pieces)
      for(int col = 0; col < rowLength; col++){
        //if there is empty column, set rowIsFull to false and break the loop
        if(gameBoard[row][col]==null){
          rowIsFull = false;
          break;
        }
      }
      //step 4: if the row is full,clear the rown and shift the row down
      if(rowIsFull){
        //step 5: move all rows above and cleared row down by one position
        for(int r = row; r > 0; r--){
          //copy above row to the current row
          gameBoard[r] = List.from(gameBoard[r-1]);
        }
        //step 6: set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        //step 7: increase the score
        currentScore++;

      }  
    }
  }

  //game over method
  bool isGameOver(){
    //if any columns in the top row are filled
    for(int col = 0; col < rowLength; col++){
      if(gameBoard[0][col] != null){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            //game grid
            child: GridView.builder(
              itemCount: rowLength * colLength,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowLength
              ), 
              itemBuilder: (context, index) {
                //get row and colum of each index
                int row = (index/rowLength).floor();
                int col = index%rowLength; 
                //current piece
                if(currentPiece.position.contains(index)){
                  return Pixel(
                    color: Colors.yellow,
                    
                  );
                }
                //landes pieces
                else if(gameBoard[row][col] != null ){
                  final TetroMino? tetrominoType = gameBoard[row][col];
                  return Pixel(color: tetrominoColors[tetrominoType],);
                }
                //blank pixel
                else{
                  return Pixel(
                    color: Colors.grey[900],
                   
                  );
                }
              }
            ),
          ),
    
          Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white),
          ),
    
          //game cntroll
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: moveLeft, 
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back_ios_new)
                ),
                IconButton(
                  onPressed: rotatePiece,
                  color: Colors.white,
                  icon: Icon(Icons.rotate_right)
                ),
                IconButton(
                  onPressed: moveRight, 
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios)
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}