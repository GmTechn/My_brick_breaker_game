import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;
  final bool isGameOver;

  static var gameFont = GoogleFonts.pressStart2p(
      textStyle: const TextStyle(
    color: Colors.white,
    letterSpacing: 0,
    fontSize: 28,
  ));

  const CoverScreen(
      {super.key, required this.hasGameStarted, required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: const Alignment(0, -0.3),
            child: Text(isGameOver ? '' : 'BRICK BREAKER',
                style: gameFont.copyWith(color: Colors.blueGrey[800])),
          )
        : Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.3),
                child: Text('BRICK BREAKER',
                    style: gameFont.copyWith(color: Colors.white)),
              ),
              Container(
                alignment: const Alignment(0, -0.1),
                child: Text(
                  'Tap to Play',
                  style: TextStyle(color: Colors.blueGrey[300]),
                ),
              )
            ],
          );
  }
}
