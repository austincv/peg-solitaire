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
    BoardConfiguration config = boardConfigurations[version];

    // deep copy
    int length = config.rows * config.columns;
    List<List<bool>> holes = new List<List<bool>>(length);
    List<List<bool>> pegs = new List<List<bool>>(length);
    for (int row = 0; row < config.rows; row++) {
      List<bool> holeRow = new List<bool>(config.columns);
      List<bool> pegRow = new List<bool>(config.columns);
      for (int column = 0; column < config.columns; column++) {
        holeRow[column] = config.holes[row][column];
        pegRow[column] = config.pegs[row][column];
      }
      holes[row] = holeRow;
      pegs[row] = pegRow;
    }

    return BoardConfiguration(holes, pegs, config.rows, config.columns);
  }
}

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  BoardFactory boardFactory = BoardFactory();

  BoardConfiguration boardConfiguration;

  bool isGameOver = false;
  bool isHovering = false;
  bool isValidHover = false;
  List<int> hoverIndex = new List(2);

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
        Color color = kColorHole;
        if (isHovering) {
          if ((rowIndex == hoverIndex[0]) & (columnIndex == hoverIndex[1])) {
            color =
                isValidHover ? kColorHoleAcceptPeg : kColorHoleCantAcceptPeg;
          }
        }
        return SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.all(width * paddingFactor),
            child: Container(
              decoration: new BoxDecoration(
                color: color,
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
      onWillAccept: (peg) {
        bool isAcceptable =
            checkIfPegAcceptableInHole(peg[0], peg[1], rowIndex, columnIndex);

        if (isAcceptable) {
          setState(() {
            hoverIndex[0] = rowIndex;
            hoverIndex[1] = columnIndex;
            isHovering = true;
            isValidHover = true;
          });
        } else {
          setState(() {
            hoverIndex[0] = rowIndex;
            hoverIndex[1] = columnIndex;
            isHovering = true;
            isValidHover = false;
          });
        }

        return isAcceptable;
      },
      onLeave: (peg) {
        setState(() {
          isHovering = false;
        });
      },
      onAccept: (peg) {
        print("Peg inserted at $peg");
        int pegRow = peg[0];
        int pegColumn = peg[1];
        int pegToRemoveRow = (pegRow + rowIndex) ~/ 2;
        int pegToRemoveColumn = (pegColumn + columnIndex) ~/ 2;

        setState(() {
          boardConfiguration.pegs[pegRow][pegColumn] = false;
          boardConfiguration.pegs[pegToRemoveRow][pegToRemoveColumn] = false;
          boardConfiguration.pegs[rowIndex][columnIndex] = true;
          isHovering = false;

          isGameOver = checkGameOver();
          if (isGameOver) {
            print("Game Over!");
          } else {
            print("Waiting for next step");
          }
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

  bool checkIfPegAcceptableInHole(
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

  bool checkGameOver() {
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
            if (checkIfPegAcceptableInHole(
                rowIndex + 2, columnIndex, rowIndex, columnIndex)) {
              return false;
            }
          }

          if (rowIndex - 2 >= 0) {
            if (checkIfPegAcceptableInHole(
                rowIndex - 2, columnIndex, rowIndex, columnIndex)) {
              return false;
            }
          }

          if (columnIndex + 2 < boardConfiguration.columns) {
            if (checkIfPegAcceptableInHole(
                rowIndex, columnIndex + 2, rowIndex, columnIndex)) {
              return false;
            }
          }
          if (columnIndex - 2 >= 0) {
            if (checkIfPegAcceptableInHole(
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

  void resetBoard() {
    boardConfiguration = boardFactory.get(0);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(kTitle),
      ),
      body: Center(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (context, constraints) =>
                  buildBoard(constraints.maxWidth, constraints.maxHeight),
            ),
          ),
        )),
      ),
      floatingActionButton: isGameOver
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  resetBoard();
                  isGameOver = false;
                });
              },
              label: Text('Game Over'),
              icon: Icon(Icons.autorenew),
              backgroundColor: kColorHoleCantAcceptPeg,
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  resetBoard();
                });
              },
              child: Icon(Icons.autorenew),
              backgroundColor: kColorPeg,
            ),
    );
  }
}
