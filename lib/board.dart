import 'package:flutter/material.dart';
import 'package:peg_solitaire/constants.dart';

import 'boards/configuration.dart';
import 'boards/factory.dart';
import 'peg.dart';

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
  Index hoverIndex;

  Widget buildHoleAtIndexPosition(Index index, Size size) {
    /// Create a drag target on which pegs can be dropped.
    /// This function defines which pegs can be accepted
    /// according to the rules of peg solitaire
    return DragTarget<List<int>>(
      builder: (context, candidateData, rejectedData) {
        double paddingFactor = 0.05;
        Color color = kColorHole;
        if (isHovering) {
          if ((index.row == hoverIndex.row) &
              (index.column == hoverIndex.column)) {
            color =
                isValidHover ? kColorHoleAcceptPeg : kColorHoleCantAcceptPeg;
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
        bool isAcceptable = boardConfiguration.checkIfPegAcceptableInHole(
            Index(peg[0], peg[1]), index);

        if (isAcceptable) {
          setState(() {
            hoverIndex = index;
            isHovering = true;
            isValidHover = true;
          });
        } else {
          setState(() {
            hoverIndex = index;
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
        int pegToRemoveRow = (pegRow + index.row) ~/ 2;
        int pegToRemoveColumn = (pegColumn + index.column) ~/ 2;

        setState(() {
          boardConfiguration.pegs[pegRow][pegColumn] = false;
          boardConfiguration.pegs[pegToRemoveRow][pegToRemoveColumn] = false;
          boardConfiguration.pegs[index.row][index.column] = true;
          isHovering = false;

          isGameOver = boardConfiguration.checkGameOver();
          if (isGameOver) {
            print("Game Over!");
          } else {
            print("Waiting for next step");
          }
        });
      },
    );
  }

  Widget buildHoleWithPegAtIndexPosition(Index index, Size size) {
    double paddingFactor = 0.05;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Padding(
        padding: EdgeInsets.all(size.width * paddingFactor),
        child: Container(
          decoration: new BoxDecoration(
            color: kColorHole,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Peg(
                index.row, index.column, size.width * 0.8, size.height * 0.8),
          ),
        ),
      ),
    );
  }

  Widget buildBoxAtIndexPosition(Index index, Size size) {
    bool isHole = boardConfiguration.holes[index.row][index.column];
    bool hasPeg = boardConfiguration.pegs[index.row][index.column];

    Widget nothing = SizedBox.fromSize(size: size);

    return isHole
        ? hasPeg
            ? buildHoleWithPegAtIndexPosition(index, size)
            : buildHoleAtIndexPosition(index, size)
        : nothing;
  }

  void resetBoard() {
    boardConfiguration = boardFactory.get(0);
  }

  Widget buildBoard(Size size) {
    double boxWidth = size.width / boardConfiguration.numberOfColumns;
    double boxHeight = size.height / boardConfiguration.numberOfRows;

    List<Row> rows = new List<Row>(boardConfiguration.numberOfRows);
    for (int rowIndex = 0;
        rowIndex < boardConfiguration.numberOfRows;
        rowIndex++) {
      List<Widget> widgets =
          new List<Widget>(boardConfiguration.numberOfColumns);
      for (int columnIndex = 0;
          columnIndex < boardConfiguration.numberOfColumns;
          columnIndex++) {
        widgets[columnIndex] = buildBoxAtIndexPosition(
            Index(rowIndex, columnIndex), Size(boxWidth, boxHeight));
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
