import 'package:flutter/material.dart';

import 'board.dart';
import 'constants.dart';

class PegSolitaire extends StatefulWidget {
  @override
  _PegSolitaireState createState() => _PegSolitaireState();
}

class _PegSolitaireState extends State<PegSolitaire> {
  Board board = Board();

  @override
  Widget build(BuildContext context) {
    final title = kTitle;

    return MaterialApp(
      title: title,
      home: Board(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kColorBackground,
      ),
    );
  }
}

void main() {
  runApp(PegSolitaire());
}
