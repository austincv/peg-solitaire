import 'package:flutter/material.dart';

class BoardConfiguration {
  final List<List<bool>> holes;
  final List<List<bool>> pegs;

  final int rows;
  final int columns;

  BoardConfiguration(this.holes, this.pegs, this.rows, this.columns);
}

class BoardFactory {
  final List<BoardConfiguration> boardConfigurations = [
    BoardConfiguration([
      [false, false, true, true, true, false, false],
      [false, false, true, true, true, false, false],
      [true, true, true, true, true, true, true],
      [true, true, true, true, true, true, true],
      [true, true, true, true, true, true, true],
      [false, false, true, true, true, false, false],
      [false, false, true, true, true, false, false],
    ], [
      [false, false, true, true, true, false, false],
      [false, false, true, true, true, false, false],
      [true, true, true, true, true, true, true],
      [true, true, true, false, true, true, true],
      [true, true, true, true, true, true, true],
      [false, false, true, true, true, false, false],
      [false, false, true, true, true, false, false],
    ], 7, 7)
  ];

  BoardConfiguration get(int version) {
    return boardConfigurations[version];
  }
}

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  BoardFactory boardFactory = BoardFactory();

  BoardConfiguration boardConfiguration;

  Widget buildBoxAtIndexPosition(
      {int rowIndex, int columnIndex, double boxWidth, double boxHeight}) {
    bool isHole = boardConfiguration.holes[rowIndex][columnIndex];
    bool hasPeg = boardConfiguration.pegs[rowIndex][columnIndex];

    Widget nothing = SizedBox(width: boxWidth, height: boxHeight);
    Widget holeWithPeg = SizedBox(
      width: boxWidth,
      height: boxHeight,
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
    Widget hole = SizedBox(
      width: boxWidth,
      height: boxHeight,
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );

    return isHole
        ? hasPeg
            ? holeWithPeg
            : hole
        : nothing;
  }

  Widget buildBoard(double width, double height) {
    double boxWidth = width / boardConfiguration.columns;
    double boxHeight = height / boardConfiguration.rows;

    List<Row> rows = new List<Row>(boardConfiguration.rows);
    for (int rowIndex = 0; rowIndex < boardConfiguration.rows; rowIndex++) {
      List<Widget> widgets = new List<Widget>(boardConfiguration.columns);
      for (int columnIndex = 0;
          columnIndex < boardConfiguration.columns;
          columnIndex++) {
        widgets[columnIndex] = buildBoxAtIndexPosition(
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            boxWidth: boxWidth,
            boxHeight: boxHeight);
      }
      rows[rowIndex] = Row(children: widgets);
    }

    return Column(children: rows);
  }

  @override
  Widget build(BuildContext context) {
    if (boardConfiguration == null) {
      boardConfiguration = boardFactory.get(0);
    }

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) =>
            buildBoard(constraints.maxWidth, constraints.maxHeight),
      ),
    );
  }
}
