import 'package:flutter/material.dart';

import 'board.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Play'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Board();
            }));
          },
        ),
      ),
    );
  }
}
