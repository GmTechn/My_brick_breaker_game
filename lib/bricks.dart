import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names
  final brick_xcoord;
  // ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names
  final brick_ycoord;
  // ignore: prefer_typing_uninitialized_variables
  final brickHeight;
  // ignore: prefer_typing_uninitialized_variables
  final brickWidth;

  final bool brickBroken;

  const MyBrick(
      {super.key,
      this.brickHeight,
      this.brickWidth,
      // ignore: non_constant_identifier_names
      this.brick_xcoord,
      // ignore: non_constant_identifier_names
      this.brick_ycoord,
      required this.brickBroken});

  @override
  Widget build(BuildContext context) {
    return brickBroken
        ? Container()
        : Container(
            alignment: Alignment(
                (2 * brick_xcoord + brickWidth) / (2 - brickWidth),
                brick_ycoord),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: MediaQuery.of(context).size.height * brickHeight / 3,
                width: MediaQuery.of(context).size.width * brickWidth * 3,
                color: Colors.white,
              ),
            ),
          );
  }
}
