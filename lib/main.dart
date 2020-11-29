import 'package:flutter/material.dart';
import 'package:peg_solitaire/model/view.dart';

import 'constants.dart';

class PegSolitaire extends StatefulWidget {
  @override
  _PegSolitaireState createState() => _PegSolitaireState();
}

class _PegSolitaireState extends State<PegSolitaire> {
  @override
  Widget build(BuildContext context) {
    final title = kTitle;

    return MaterialApp(
      title: title,
      home: GameScaffold(),
    );
  }
}

void main() {
  runApp(PegSolitaire());
}
