import 'package:flutter/material.dart';
import 'package:peg_solitaire/constants.dart';

import 'configuration.dart';
import 'peg.dart';

class Hole extends StatefulWidget {
  final Index index;
  final Size size;
  final Color color;
  final Peg peg;

  Hole(
      {Key key,
      @required this.index,
      @required this.size,
      this.color,
      this.peg})
      : super(key: key);

  @override
  _HoleState createState() => _HoleState();
}

class _HoleState extends State<Hole> {
  double paddingFactor = 0.05;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Padding(
        padding: EdgeInsets.all(widget.size.width * paddingFactor),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: widget.color == null ? kColorHole : widget.color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: widget.peg,
          ),
        ),
      ),
    );
  }
}
