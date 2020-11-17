import 'package:flutter/material.dart';

import 'board2.dart';
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
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Board(),
          )),
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
