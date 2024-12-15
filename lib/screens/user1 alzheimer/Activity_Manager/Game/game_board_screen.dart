import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/Game/piece.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/Game/pixel.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/Game/values.dart';

// Create the game board
List<List<TetroMino?>> gameBoard = List.generate(
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
  Piece currentPiece = Piece(type: TetroMino.L);
  int currentScore = 0;
  bool gameOver = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    _timer = Timer.periodic(frameRate, (timer) {
      if (!mounted) return; // Ensure widget is still mounted
      setState(() {
        clearLines();
        checkLanding();

        if (gameOver) {
          timer.cancel();
          showGameOverDialog();
        }

        if (!gameOver) {
          currentPiece.movePiece(Direction.down);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Show the game over dialog
  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Your Score is $currentScore"),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: const Text("Play again"),
          ),
        ],
      ),
    );
  }

  // Reset the game
  void resetGame() {
    setState(() {
      gameBoard = List.generate(
        colLength,
        (i) => List.generate(
          rowLength,
          (j) => null,
        ),
      );
      currentScore = 0;
      gameOver = false;
      createNewPiece();
      startGame();
    });
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // Check for out of bounds or collision with existing blocks
      if (row >= colLength || col < 0 || col >= rowLength || (row >= 0 && gameBoard[row][col] != null)) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    TetroMino randomType =
        TetroMino.values[rand.nextInt(TetroMino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    // Check if the new piece collides immediately
    if (checkCollision(Direction.down)) {
      setState(() {
        gameOver = true;
      });
    }
  }

  void clearLines() {
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFull = true;
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(rowLength, (index) => null);
        currentScore++;
      }
    }
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // Add the quit game confirmation dialog on back press
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Quit Game"),
            content: const Text("Do you want to quit the game?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // True to quit
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // False to stay in game
                },
                child: const Text("No"),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength,
                ),
                itemBuilder: (context, index) {
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;

                  // Check if the current piece occupies the grid cell
                  if (currentPiece.position.contains(index)) {
                    return Pixel(color: Colors.yellow); // Color the current piece
                  } else if (gameBoard[row][col] != null) {
                    // Render blocks that are already placed on the board
                    final TetroMino? tetrominoType = gameBoard[row][col];
                    return Pixel(color: tetrominoColors[tetrominoType]);
                  } else {
                    return Pixel(color: Colors.grey[900]);
                  }
                },
              ),
            ),
            Text(
              'Score: $currentScore',
              style: const TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon: const Icon(Icons.rotate_right),
                  ),
                  IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
