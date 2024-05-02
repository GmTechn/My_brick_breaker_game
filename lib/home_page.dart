// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:brick_breaker_game/ball.dart';
import 'package:brick_breaker_game/bricks.dart';
import 'package:brick_breaker_game/cover_screen.dart';
import 'package:brick_breaker_game/gameoverscreen.dart';
import 'package:brick_breaker_game/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// ignore: camel_case_types, constant_identifier_names
enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  /// ball coordinates
  // ignore: non_constant_identifier_names
  double x_coordinate = 0;
  // ignore: non_constant_identifier_names
  double y_coordinate = 0;
  // ignore: non_constant_identifier_names
  double x_coordinate_increments = 0.02;
  // ignore: non_constant_identifier_names
  double y_coordinate_increments = 0.01;

  var ballXDirection = direction.LEFT;
  var ballYDirection = direction.DOWN;

  ///game settings
  // ignore: non_constant_identifier_names
  bool GameStarted = false;
  bool isGameOver = false;

  /// player coordinates
  double playerX = -0.2;
  double playerWidth = 0.4;

  ///bricks coordinates
  // ignore: non_constant_identifier_names
  static double _brick1_xcoordinate = -1 + wallGap;
  // ignore: non_constant_identifier_names
  static double _brick1_ycoordinate = -0.8;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.01;
  static double wallGap = 0.5 *
      (2 - no_ofBricksInRow * brickWidth - (no_ofBricksInRow - 1) * brickGap);

  // ignore: non_constant_identifier_names
  static int no_ofBricksInRow = 4;

  ///Set of bricks
  // ignore: non_constant_identifier_names
  List MyBricks = [
    //[x coord, y coord, broken or not = true/ false]
    [
      _brick1_xcoordinate + 0 * (brickWidth + brickGap),
      _brick1_ycoordinate,
      false
    ],
    [
      _brick1_xcoordinate + 1 * (brickWidth + brickGap),
      _brick1_ycoordinate,
      false
    ],
    [
      _brick1_xcoordinate + 2 * (brickWidth + brickGap),
      _brick1_ycoordinate,
      false
    ],
    [
      _brick1_xcoordinate + 3 * (brickWidth + brickGap),
      _brick1_ycoordinate,
      false
    ],
    [
      _brick1_xcoordinate + 4 * (brickWidth + brickGap),
      _brick1_ycoordinate,
      false
    ],
  ];

  void startGame() {
    //direction of the ball when the game starts (downwards)
    GameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      //update direction
      updateDirection();

      //move ball
      moveBall();

      //check if player dead
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      //check if a brick has been hit

      checkBrokenBricks();
    });
  }

//update direction
  void updateDirection() {
    setState(() {
      //ball goes up when it hits the player
      if (y_coordinate >= 0.9 &&
          x_coordinate >= playerX &&
          x_coordinate <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      }

      //ball goes down when it hits the top of the screen

      else if (y_coordinate <= -1) {
        ballYDirection = direction.DOWN;
      }

      //ball goes left when it hits the right wall

      if (x_coordinate >= 1) {
        ballXDirection = direction.LEFT;
      }

      //ball goes right when it hits the left wall

      else if (x_coordinate <= -1) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

// just to move in the oposite direction
  void moveBall() {
    setState(() {
      //move horizontally
      if (ballXDirection == direction.LEFT) {
        x_coordinate -= x_coordinate_increments;
      } else if (ballXDirection == direction.RIGHT) {
        x_coordinate += x_coordinate_increments;
      }

      // move ball vertically
      if (ballYDirection == direction.DOWN) {
        y_coordinate += y_coordinate_increments;
      } else if (ballYDirection == direction.UP) {
        y_coordinate -= y_coordinate_increments;
      }
    });
  }

//moving the player to the left

  void moveLeft() {
    //for the player to not go off the screen from the left
    if (!(playerX - 0.2 < -1)) playerX -= 0.2;
  }

//moving the player to the left

  void moveRight() {
    //for the player to not go off the screen from the left

    if (!(playerX + playerWidth > 1)) playerX += 0.2;
  }

  //check if the brick is broken
  void checkBrokenBricks() {
    for (int i = 0; i < MyBricks.length; i++) {
      // check if the ball has hit the botton of the brick

      if (x_coordinate >= MyBricks[i][0] &&
          x_coordinate <= MyBricks[i][0] + brickWidth &&
          y_coordinate <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;
          ballYDirection = direction.DOWN;
        });
        //Update the direction of the ball when it hits a brick
        //Basically bounces in opposite way
        //If the distance between the ball and one of the sides is the smallest than
        //the ball has touched the brick and should bounce back, therefore we calculate the
        //distance between the ball and each side of the brick and we get the minimum distance

        double leftSideDistance = (MyBricks[i][0] - x_coordinate).abs();
        double rightSideDistance =
            (MyBricks[i][0] + brickWidth - x_coordinate).abs();
        double topSideDistance = (MyBricks[i][0] - y_coordinate).abs();
        double bottomSideDistance =
            (MyBricks[i][0] + brickHeight - y_coordinate).abs();

        String minDistance = findMin(leftSideDistance, rightSideDistance,
            topSideDistance, bottomSideDistance);

        switch (minDistance) {
          //Ball hits left side
          case 'left':
            ballXDirection = direction.LEFT;
            break;

          //Ball hits right side

          case 'right':
            ballXDirection = direction.RIGHT;
            break;

          //Ball hits top side

          case 'top':
            ballYDirection = direction.UP;
            break;

          //Ball bottom botton side

          case 'down':
            ballYDirection = direction.DOWN;
            break;
        }
      }
    }
  }

//returns the small distance

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];

    double currentMin = a;

    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
      if ((currentMin - a).abs() < 0.01) {
        return 'left';
      } else if ((currentMin - b).abs() < 0.01) {
        return 'right';
      }
      if ((currentMin - c).abs() < 0.01) {
        return 'top';
      }
      if ((currentMin - d).abs() < 0.01) {
        return 'bottom';
      }
    }
    return '';
  }

  ///Player is dead
  bool isPlayerDead() {
    if (y_coordinate >= 1) {
      return true;
    }
    return false;
  }

  ///Reset the game

  void resetGame() {
    setState(() {
      playerX = -0.2;
      x_coordinate = 0;
      y_coordinate = 0;
      isGameOver = false;
      GameStarted = false;

      MyBricks = [
        //[x coord, y coord, broken or not = true/ false]
        [
          _brick1_xcoordinate + 0 * (brickWidth + brickGap),
          _brick1_ycoordinate,
          false
        ],
        [
          _brick1_xcoordinate + 1 * (brickWidth + brickGap),
          _brick1_ycoordinate,
          false
        ],
        [
          _brick1_xcoordinate + 2 * (brickWidth + brickGap),
          _brick1_ycoordinate,
          false
        ],
        [
          _brick1_xcoordinate + 3 * (brickWidth + brickGap),
          _brick1_ycoordinate,
          false
        ],
        [
          _brick1_xcoordinate + 4 * (brickWidth + brickGap),
          _brick1_ycoordinate,
          false
        ],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        // ignore: deprecated_member_use
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
          // ignore: deprecated_member_use
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
          onTap: startGame,
          child: Scaffold(
              backgroundColor: Colors.blueGrey[900],
              body: Center(
                  child: Stack(
                children: [
                  //Game Over Screen
                  GameOverScreen(
                    isGameOver: isGameOver,
                    function: resetGame,
                  ),

                  //Cover Screen before the game starts
                  CoverScreen(
                    hasGameStarted: GameStarted,
                    isGameOver: isGameOver,
                  ),

                  //the rounded container as the ball
                  MyBall(
                    x_coord: x_coordinate,
                    y_coord: y_coordinate,
                    isGameOver: isGameOver,
                    hasGameStarted: GameStarted,
                  ),

                  // the rectangle shapped container as the player
                  MyPlayer(
                    playerWidth: playerWidth,
                    playerX: playerX,
                  ),
                  //the rectangles containers to stand as brick to hit by the ball
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickHeight,
                    brick_xcoord: MyBricks[0][0],
                    brick_ycoord: MyBricks[0][1],
                    brickBroken: MyBricks[0][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickHeight,
                    brick_xcoord: MyBricks[1][0],
                    brick_ycoord: MyBricks[1][1],
                    brickBroken: MyBricks[1][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickHeight,
                    brick_xcoord: MyBricks[2][0],
                    brick_ycoord: MyBricks[2][1],
                    brickBroken: MyBricks[2][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickHeight,
                    brick_xcoord: MyBricks[3][0],
                    brick_ycoord: MyBricks[3][1],
                    brickBroken: MyBricks[3][2],
                  ),
                  MyBrick(
                    brickHeight: brickHeight,
                    brickWidth: brickHeight,
                    brick_xcoord: MyBricks[4][0],
                    brick_ycoord: MyBricks[4][1],
                    brickBroken: MyBricks[4][2],
                  ),
                ],
              )))),
    );
  }
}
