import 'package:flutter/material.dart';

class AppColors {
  Color background;
  Color hole;
  Color holeHighlight;
  Color peg;
  Color pegHighlight;
  Color text;
  Color title;

  AppColors({
    @required this.background,
    @required this.hole,
    @required this.holeHighlight,
    @required this.peg,
    @required this.pegHighlight,
    @required this.text,
    @required this.title,
  });
}

AppColors orange = AppColors(
  background: Colors.orange.shade100,
  hole: Colors.orange.shade200,
  holeHighlight: Colors.orange.shade300,
  peg: Colors.orange.shade600,
  pegHighlight: Colors.orange.shade700,
  text: Colors.orange.shade800,
  title: Colors.orange.shade900,
);

AppColors pink = AppColors(
  background: Colors.pink.shade100,
  hole: Colors.pink.shade200,
  holeHighlight: Colors.pink.shade300,
  peg: Colors.pink.shade600,
  pegHighlight: Colors.pink.shade700,
  text: Colors.pink.shade800,
  title: Colors.pink.shade900,
);
