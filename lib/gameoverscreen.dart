import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverScreen extends StatelessWidget {
  final bool isGameOver;
  // ignore: prefer_typing_uninitialized_variables
  final function;

  //font
  static var gameFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(
          color: Colors.blueGrey[600], letterSpacing: 0, fontSize: 28));

  const GameOverScreen({super.key, required this.isGameOver, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.3),
                child: Text(
                  'GAME OVER',
                  style: gameFont,
                ),
              ),
              Container(
                alignment: const Alignment(0, 0),
                child: GestureDetector(
                  onTap: function,
                  child: ClipRRect(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[600],
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'PLAY AGAIN',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              )
            ],
          )
        : Container();
  }
}
