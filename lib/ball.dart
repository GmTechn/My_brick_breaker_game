import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final double x_coord;
  // ignore: non_constant_identifier_names
  final double y_coord;

  final bool isGameOver;
  final bool hasGameStarted;

  // ignore: non_constant_identifier_names
  const MyBall(
      {super.key,
      // ignore: non_constant_identifier_names
      required this.x_coord,
      // ignore: non_constant_identifier_names
      required this.y_coord,
      required this.isGameOver,
      required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: Alignment(x_coord, y_coord),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isGameOver ? Colors.blueGrey[600] : Colors.white),
              width: 15,
              height: 15,
            ),
          )
        : Container(
            alignment: Alignment(x_coord, y_coord),
            child: AvatarGlow(
                glowRadiusFactor: 1,
                child: Material(
                  elevation: 0.1,
                  shape: const CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      height: 1,
                      width: 1,
                    ),
                  ),
                )));
  }
}
