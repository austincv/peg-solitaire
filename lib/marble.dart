import 'package:flutter/material.dart';

import 'constants.dart';

class Marble extends StatelessWidget {
  final int row;
  final int column;
  final double _sizeFactor = 1.0;

  Marble(this.row, this.column);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Draggable<String>(
        child: SizedBox(
          width: constraints.maxWidth * this._sizeFactor,
          height: constraints.maxHeight * this._sizeFactor,
          child: Card(
            color: kColorMarble,
            elevation: 1,
            shape: CircleBorder(),
          ),
        ),
        feedback: SizedBox(
          width: constraints.maxWidth * this._sizeFactor,
          height: constraints.maxHeight * this._sizeFactor,
          child: Card(
            color: kColorMarble,
            elevation: 4,
            shape: CircleBorder(),
          ),
        ),
        childWhenDragging: Container(),
        data: '$row$column',
      ),
    );
  }
}
