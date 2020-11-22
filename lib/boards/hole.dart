import 'package:flutter/material.dart';

import 'peg.dart';

class Hole extends StatefulWidget {
  final Size size;
  final Color color;
  final Peg peg;

  Hole({Key key, this.size, this.color, this.peg}) : super(key: key);

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
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
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
