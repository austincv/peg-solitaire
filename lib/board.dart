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

  late BoardConfiguration boardConfiguration;

  bool isGameOver = false;
  bool isPegBeingDragged = false;
  bool isPegDroppableOnTheHoleBelow = false;
  // TODO: multiple pegs can be dragged?
  late Index indexOfPegBeingDragged;

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
          index: holeIndex,
          size: size,
          color: color,
        );
      },
      onWillAccept: (pegIndex) {
        if (pegIndex == null) return false;
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

  Widget buildHoleWithPegAtIndex(Index holeIndex, Size size) {
    double reduceFactor = 0.8;
    Size pegSize = Size(size.width * reduceFactor, size.height * reduceFactor);

    return Hole(
      index: holeIndex,
      size: size,
      color: isGameOver ? kColorHoleGameOver : kColorHole,
      peg: Peg(holeIndex, pegSize),
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

  @override
  void initState() {
    super.initState();
    boardConfiguration = boardFactory.get(0);
  }

  void resetBoard() {
    boardConfiguration = boardFactory.get(0);
    isGameOver = false;
  }

  Widget buildBoard(Size size) {
    Size boxSize = Size(size.width / boardConfiguration.numberOfColumns,
        size.height / boardConfiguration.numberOfRows);

    final rows = <Row>[];
    for (int rowIndex = 0;
        rowIndex < boardConfiguration.numberOfRows;
        rowIndex++) {
      final widgets = <Widget>[];
      for (int columnIndex = 0;
          columnIndex < boardConfiguration.numberOfColumns;
          columnIndex++) {
        widgets.add(buildBoxAtIndex(Index(rowIndex, columnIndex), boxSize));
      }
      rows.add(Row(
        children: widgets,
        mainAxisAlignment: MainAxisAlignment.center,
      ));
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
    return Scaffold(
        appBar: AppBar(
          title: Text(kTitle),
          actions: [
            Center(child: kVersion),
            ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade900),
                    onPressed: () {
                      setState(() {
                        resetBoard();
                      });
                    },
                    child: FittedBox(
                      child: Icon(
                        Icons.autorenew,
                        color: isGameOver ? kColorResetGameOver : kColorReset,
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
