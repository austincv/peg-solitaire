import 'package:flutter/material.dart';
import 'package:peg_solitaire/constants.dart';

import 'boards/configuration.dart';
import 'boards/factory.dart';
import 'boards/hole.dart';
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
  // TODO: multiple pegs can be dragged?
  Index indexOfPegBeingDragged;

  Widget buildHoleAtIndex(Index holeIndex, Size size) {
    /// Create a drag target on which pegs can be dropped.
    /// This function defines which pegs can be accepted
    /// according to the rules of peg solitaire
    return DragTarget<Index>(
      builder: (context, candidateData, rejectedData) {
        Color color = kColorHole;
        if (isPegBeingDragged) {
          if (holeIndex == indexOfPegBeingDragged) {
            color = isPegDroppableOnTheHoleBelow
                ? kColorHoleDroppable
                : kColorHoleNotDroppable;
          }
        }
        return Hole(
          size: size,
          color: color,
        );
      },
      onWillAccept: (pegIndex) {
        bool isPegDroppableInHole =
            boardConfiguration.checkIfPegIsDroppableInHole(pegIndex, holeIndex);

        if (isPegDroppableInHole) {
          setState(() {
            indexOfPegBeingDragged = holeIndex;
            isPegBeingDragged = true;
            isPegDroppableOnTheHoleBelow = true;
          });
        } else {
          setState(() {
            indexOfPegBeingDragged = holeIndex;
            isPegBeingDragged = true;
            isPegDroppableOnTheHoleBelow = false;
          });
        }

        return isPegDroppableInHole;
      },
      onLeave: (pegIndex) {
        setState(() {
          isPegBeingDragged = false;
        });
      },
      onAccept: (pegIndex) {
        print("Peg inserted at $pegIndex.");
        int pegToRemoveRow = (pegIndex.row + holeIndex.row) ~/ 2;
        int pegToRemoveColumn = (pegIndex.column + holeIndex.column) ~/ 2;

        setState(() {
          boardConfiguration.pegs[pegIndex.row][pegIndex.column] = false;
          boardConfiguration.pegs[pegToRemoveRow][pegToRemoveColumn] = false;
          boardConfiguration.pegs[holeIndex.row][holeIndex.column] = true;
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
    double reduceFactor = 0.8;
    Size pegSize = Size(size.width * reduceFactor, size.height * reduceFactor);

    return Hole(
      size: size,
      color: kColorHole,
      peg: Peg(index, pegSize),
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
    isGameOver = false;
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
                    color: kColorResetGameOver,
                    onPressed: () {
                      setState(() {
                        resetBoard();
                      });
                    },
                    child: FittedBox(
                        child: Icon(
                      Icons.autorenew,
                    )),
                  )
                : RaisedButton(
                    color: kColorReset,
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
