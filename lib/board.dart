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

  Widget buildSquareBox(Widget child, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: child,
    );
  }

  Widget buildHoleAtIndexPosition(
      int rowIndex, int columnIndex, double width, double height) {
    /// Create a drag target on which pegs can be dropped.
    /// This function defines which pegs can be accepted
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
            print('Middle Peg can be removed at [$popRow, $popColumn]');
            return true;
          } else {
            print('Middle Peg not available at [$popRow, $popColumn]');
            return false;
          }
        } else {
          print('Cant insert peg at $data');
          print((draggedRow - rowIndex).abs());
          print((draggedColumn - columnIndex).abs());
          return false;
        }
      },
      onAccept: (data) {
        print("Peg inserted at $data");
        int draggedRow = data[0];
        int draggedColumn = data[1];
        int popRow = (draggedRow + rowIndex) ~/ 2;
        int popColumn = (draggedColumn + columnIndex) ~/ 2;

        setState(() {
          boardConfiguration.pegs[draggedRow][draggedColumn] = false;
          boardConfiguration.pegs[popRow][popColumn] = false;
          boardConfiguration.pegs[rowIndex][columnIndex] = true;
        });

        if (isGameOver()) {
          print("Game Over!");
        } else {
          print("Waiting for next step");
        }
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

  bool isPegAcceptableInHole(
      int rowPeg, int columnPeg, int rowHole, int columnHole) {
    if (!boardConfiguration.pegs[rowPeg][columnPeg]) {
      return false; // peg does not exist
    }

    if (!boardConfiguration.holes[rowHole][columnHole]) {
      return false; // peg does not exist
    }

    print("Is peg[$rowPeg, $columnPeg] acceptable in [$rowHole, $columnHole]");
    int rowCheck = (rowPeg - rowHole).abs();
    int colCheck = (columnPeg - columnHole).abs();
    print("row check $rowCheck col check $colCheck");
    if (((rowCheck == 2) & (colCheck == 0)) |
        ((rowCheck == 0) & (colCheck == 2))) {
      int rowMiddle = (rowPeg + rowHole) ~/ 2;
      int columnMiddle = (columnPeg + columnHole) ~/ 2;
      bool middlePegExists = boardConfiguration.pegs[rowMiddle][columnMiddle];
      print(
          "Returning $rowMiddle$columnMiddle middlePegExists $middlePegExists");
      return middlePegExists; // it is acceptable if the middle peg exists

    }
    return false;
  }

  bool isGameOver() {
    int counter = 0;
    for (int rowIndex = 0; rowIndex < boardConfiguration.rows; rowIndex++) {
      for (int columnIndex = 0;
          columnIndex < boardConfiguration.columns;
          columnIndex++) {
        bool holeExists = boardConfiguration.holes[rowIndex][columnIndex];
        bool holeIsEmpty = !boardConfiguration.pegs[rowIndex][columnIndex];
        if (holeExists & holeIsEmpty) {
          counter++;
          if (rowIndex + 2 < boardConfiguration.rows) {
            if (isPegAcceptableInHole(
                rowIndex + 2, columnIndex, rowIndex, columnIndex)) {
              return false;
            }
          }

          if (rowIndex - 2 >= 0) {
            if (isPegAcceptableInHole(
                rowIndex - 2, columnIndex, rowIndex, columnIndex)) {
              return false;
            }
          }

          if (columnIndex + 2 < boardConfiguration.columns) {
            if (isPegAcceptableInHole(
                rowIndex, columnIndex + 2, rowIndex, columnIndex)) {
              return false;
            }
          }
          if (columnIndex - 2 >= 0) {
            if (isPegAcceptableInHole(
                rowIndex, columnIndex - 2, rowIndex, columnIndex)) {
              return false;
            }
          }
        }
      }
    }
    print("Found $counter holes");
    return true;
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
