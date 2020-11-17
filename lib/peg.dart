import 'package:flutter/material.dart';

import 'constants.dart';

class Peg extends StatelessWidget {
  final int row;
  final int column;
  final double width;
  final double height;

  Peg(this.row, this.column, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: SizedBox(
        width: width,
        height: height,
        child: Card(
          color: kColorPeg,
          elevation: 1,
          shape: CircleBorder(),
        ),
      ),
      feedback: SizedBox(
        width: width,
        height: height,
        child: Card(
          color: kColorPeg,
          elevation: 4,
          shape: CircleBorder(),
        ),
      ),
      childWhenDragging: Container(),
      data: [row, column],
    );
  }
}
