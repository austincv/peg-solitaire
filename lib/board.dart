import 'package:flutter/material.dart';
import 'package:peg_solitaire/constants.dart';

import 'boards/configuration.dart';
import 'boards/factory.dart';
import 'boards/peg.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  BoardFactory boardFactory = BoardFactory();

  BoardConfiguration boardConfiguration;

  bool isGameOver = false;
  bool isPegBeingDragged = false;
  bool isPegDroppableOnTheHoleBelow = false;
  Index indexOfPegBeingDragged;

  Widget buildHoleAtIndex(Index index, Size size) {
    /// Create a drag target on which pegs can be dropped.
    /// This function defines which pegs can be accepted
    /// according to the rules of peg solitaire
    return DragTarget<Index>(
      builder: (context, candidateData, rejectedData) {
        double paddingFactor = 0.05;
        Color color = kColorHole;
        if (isPegBeingDragged) {
          if (index == indexOfPegBeingDragged) {
            color = isPegDroppableOnTheHoleBelow
                ? kColorHoleDroppable
                : kColorHoleNotDroppable;
          }
        }
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: EdgeInsets.all(size.width * paddingFactor),
            child: Container(
              decoration: new BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                    width: size.width * 0.5,
                    height: size.height * 0.5,
                    child: Container()),
              ),
            ),
          ),
        );
      },
      onWillAccept: (peg) {
        bool isPegDroppableInHole =
            boardConfiguration.checkIfPegIsDroppableInHole(peg, index);

        if (isPegDroppableInHole) {
          setState(() {
            indexOfPegBeingDragged = index;
            isPegBeingDragged = true;
            isPegDroppableOnTheHoleBelow = true;
          });
        } else {
          setState(() {
            indexOfPegBeingDragged = index;
            isPegBeingDragged = true;
            isPegDroppableOnTheHoleBelow = false;
          });
        }

        return isPegDroppableInHole;
      },
      onLeave: (peg) {
        setState(() {
          isPegBeingDragged = false;
        });
      },
      onAccept: (peg) {
        print("Peg inserted at $peg.");
        int pegToRemoveRow = (peg.row + index.row) ~/ 2;
        int pegToRemoveColumn = (peg.column + index.column) ~/ 2;

        setState(() {
          boardConfiguration.pegs[peg.row][peg.column] = false;
          boardConfiguration.pegs[pegToRemoveRow][pegToRemoveColumn] = false;
          boardConfiguration.pegs[index.row][index.column] = true;
          isPegBeingDragged = false;

          isGameOver = boardConfiguration.checkGameOver();
          if (isGameOver) {
            print("Game Over!");
          } else {
            print("Waiting for next move.");
          }
        });
      },
    );
  }

  Widget buildHoleWithPegAtIndex(Index index, Size size) {
    double paddingFactor = 0.05;
    double reduceFactor = 0.8;
    Size pegSize = Size(size.width * reduceFactor, size.height * reduceFactor);

    return SizedBox.fromSize(
      size: size,
      child: Padding(
        padding: EdgeInsets.all(size.width * paddingFactor),
        child: Container(
          decoration: new BoxDecoration(
            color: kColorHole,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Peg(index, pegSize),
          ),
        ),
      ),
    );
  }

  Widget buildBoxAtIndex(Index index, Size size) {
    bool isHole = boardConfiguration.holes[index.row][index.column];
    bool hasPeg = boardConfiguration.pegs[index.row][index.column];

    Widget nothing = SizedBox.fromSize(size: size);

    return isHole
        ? hasPeg
            ? buildHoleWithPegAtIndex(index, size)
            : buildHoleAtIndex(index, size)
        : nothing;
  }

  void resetBoard() {
    boardConfiguration = boardFactory.get(0);
  }

  Widget buildBoard(Size size) {
    Size boxSize = Size(size.width / boardConfiguration.numberOfColumns,
        size.height / boardConfiguration.numberOfRows);

    List<Row> rows = new List<Row>(boardConfiguration.numberOfRows);
    for (int rowIndex = 0;
        rowIndex < boardConfiguration.numberOfRows;
        rowIndex++) {
      List<Widget> widgets =
          new List<Widget>(boardConfiguration.numberOfColumns);
      for (int columnIndex = 0;
          columnIndex < boardConfiguration.numberOfColumns;
          columnIndex++) {
        widgets[columnIndex] =
            buildBoxAtIndex(Index(rowIndex, columnIndex), boxSize);
      }
      rows[rowIndex] = Row(
        children: widgets,
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }

    return Column(children: rows, mainAxisAlignment: MainAxisAlignment.center);
  }

  Widget buildLayout(context, constraints) {
    const reduceFactor = 0.9;
    Size size = Size.square((constraints.maxWidth < constraints.maxHeight)
        ? constraints.maxWidth * reduceFactor
        : constraints.maxHeight * reduceFactor);
    return buildBoard(size);
  }

  @override
  Widget build(BuildContext context) {
    if (boardConfiguration == null) {
      boardConfiguration = boardFactory.get(0);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(kTitle),
          actions: [
            isGameOver
                ? RaisedButton(
                    color: kGameOver,
                    onPressed: () {
                      setState(() {
                        resetBoard();
                        isGameOver = false;
                      });
                    },
                    child: FittedBox(
                        child: Icon(
                      Icons.autorenew,
                    )),
                  )
                : RaisedButton(
                    color: kTitleButton,
                    onPressed: () {
                      setState(() {
                        resetBoard();
                      });
                    },
                    child: FittedBox(
                      child: Icon(
                        Icons.autorenew,
                      ),
                    ),
                  )
          ],
        ),
        body: LayoutBuilder(
          builder: buildLayout,
        ));
  }
}
