import 'package:flutter/material.dart';

class Marble extends StatelessWidget {
  final int row;
  final int column;
  final double _sizeFactor = 1.0;

  Marble({@required this.row, @required this.column});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Draggable<String>(
        child: SizedBox(
          width: constraints.maxWidth * this._sizeFactor,
          height: constraints.maxHeight * this._sizeFactor,
          child: Card(
            elevation: 1,
            color: Colors.teal.shade300,
            shape: CircleBorder(),
          ),
        ),
        feedback: SizedBox(
          width: constraints.maxWidth * this._sizeFactor,
          height: constraints.maxHeight * this._sizeFactor,
          child: Card(
            elevation: 4,
            color: Colors.teal.shade300,
            shape: CircleBorder(),
          ),
        ),
        childWhenDragging: Container(),
        data: '$row$column',
      ),
    );
  }
}
