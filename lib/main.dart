import 'package:flutter/material.dart';

import 'board.dart';
import 'constants.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Peg Solitaire';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: SafeArea(child: Board()),
        ),
      ),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kColorBackground,
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
