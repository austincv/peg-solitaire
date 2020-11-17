import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peg_solitaire/constants.dart';

import 'peg.dart';

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
  final _random = new Random();

  Widget buildSquareBox(Widget child, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: child,
    );
  }

  Widget buildHoleAtIndexPosition(
      int rowIndex, int columnIndex, double width, double height) {
    /// Create a drag target on which marbles can be dropped.
    /// This function defines which marbles can be accepted
    /// according to the rules of peg solitaire
    return DragTarget<List<int>>(
      builder: (context, candidateData, rejectedData) {
        double paddingFactor = 0.05;

        return SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.all(width * paddingFactor),
            child: Container(
              decoration: new BoxDecoration(
                color: kColorHole,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                    width: width * 0.5,
                    height: height * 0.5,
                    child: Container()),
              ),
            ),
          ),
        );
      },
      onWillAccept: (data) {
        int draggedRow = data[0];
        int draggedColumn = data[1];

        int rowCheck = (draggedRow - rowIndex).abs();
        int colCheck = (draggedColumn - columnIndex).abs();
        if (((rowCheck == 2) & (colCheck == 0)) |
            ((rowCheck == 0) & (colCheck == 2))) {
          int popRow = (draggedRow + rowIndex) ~/ 2;
          int popColumn = (draggedColumn + columnIndex) ~/ 2;
          if (boardConfiguration.pegs[popRow][popColumn] == true) {
            print('Marble found at $popRow$popColumn');
            return true;
          } else {
            print('Marble not found at $popRow$popColumn');
            return false;
          }
        } else {
          print('Cant accept $data marble');
          print((draggedRow - rowIndex).abs());
          print((draggedColumn - columnIndex).abs());
          return false;
        }
      },
      onAccept: (data) {
        print("Accepted $data");
        int draggedRow = data[0];
        int draggedColumn = data[1];
        int popRow = (draggedRow + rowIndex) ~/ 2;
        int popColumn = (draggedColumn + columnIndex) ~/ 2;

        setState(() {
          boardConfiguration.pegs[draggedRow][draggedColumn] = false;
          boardConfiguration.pegs[popRow][popColumn] = false;
          boardConfiguration.pegs[rowIndex][columnIndex] = true;
        });
      },
    );
  }

  Widget buildHoleWithPegAtIndexPosition(
      int rowIndex, int columnIndex, double width, double height) {
    double paddingFactor = 0.05;

    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: EdgeInsets.all(width * paddingFactor),
        child: Container(
          decoration: new BoxDecoration(
            color: kColorHole,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Peg(rowIndex, columnIndex, width * 0.8, height * 0.8),
          ),
        ),
      ),
    );
  }

  Widget buildBoxAtIndexPosition(
      {int rowIndex, int columnIndex, double boxWidth, double boxHeight}) {
    bool isHole = boardConfiguration.holes[rowIndex][columnIndex];
    bool hasPeg = boardConfiguration.pegs[rowIndex][columnIndex];

    Widget nothing = SizedBox(width: boxWidth, height: boxHeight);

    return isHole
        ? hasPeg
            ? buildHoleWithPegAtIndexPosition(
                rowIndex, columnIndex, boxWidth, boxHeight)
            : buildHoleAtIndexPosition(
                rowIndex, columnIndex, boxWidth, boxHeight)
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
