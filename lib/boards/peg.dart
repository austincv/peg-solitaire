import 'package:flutter/material.dart';

import '../constants.dart';
import 'configuration.dart';

class Peg extends StatelessWidget {
  final Index index;
  final Size size;

  Peg(this.index, this.size);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Card(
          color: kColorPeg,
          elevation: 1,
          shape: CircleBorder(),
        ),
      ),
      feedback: SizedBox(
        width: size.width,
        height: size.height,
        child: Card(
          color: kColorPeg,
          elevation: 10,
          shape: CircleBorder(),
        ),
      ),
      childWhenDragging: Container(),
      data: index,
    );
  }
}
