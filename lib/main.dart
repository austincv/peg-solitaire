import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'constants.dart';
import 'menu.dart';

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
        home: Menu(),
        theme: ThemeData(
          primaryTextTheme: TextTheme(
              headline6: TextStyle(
            color: Colors.grey,
          )),
          appBarTheme: AppBarTheme(
            color: kColorBackground,
          ),
          scaffoldBackgroundColor: kColorBackground,
        ));
  }
}

void main() {
  runApp(PegSolitaire());
}
