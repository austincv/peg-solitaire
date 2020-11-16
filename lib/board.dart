import 'package:flutter/material.dart';

import 'constants.dart';
import 'marble.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Map<String, bool> _pegs = {
    '00': false,
    '01': false,
    '02': true,
    '03': true,
    '04': true,
    '05': false,
    '06': false,
    '10': false,
    '11': false,
    '12': true,
    '13': true,
    '14': true,
    '15': false,
    '16': false,
    '20': true,
    '21': true,
    '22': true,
    '23': true,
    '24': true,
    '25': true,
    '26': true,
    '30': true,
    '31': true,
    '32': true,
    '33': true,
    '34': true,
    '35': true,
    '36': true,
    '40': true,
    '41': true,
    '42': true,
    '43': true,
    '44': true,
    '45': true,
    '46': true,
    '50': false,
    '51': false,
    '52': true,
    '53': true,
    '54': true,
    '55': false,
    '56': false,
    '60': false,
    '61': false,
    '62': true,
    '63': true,
    '64': true,
    '65': false,
    '66': false,
  };

  Map<String, bool> _marbles = {
    '00': false,
    '01': false,
    '02': true,
    '03': true,
    '04': true,
    '05': false,
    '06': false,
    '10': false,
    '11': false,
    '12': true,
    '13': true,
    '14': true,
    '15': false,
    '16': false,
    '20': true,
    '21': true,
    '22': true,
    '23': true,
    '24': true,
    '25': true,
    '26': true,
    '30': true,
    '31': true,
    '32': true,
    '33': false,
    '34': true,
    '35': true,
    '36': true,
    '40': true,
    '41': true,
    '42': true,
    '43': true,
    '44': true,
    '45': true,
    '46': true,
    '50': false,
    '51': false,
    '52': true,
    '53': true,
    '54': true,
    '55': false,
    '56': false,
    '60': false,
    '61': false,
    '62': true,
    '63': true,
    '64': true,
    '65': false,
    '66': false,
  };

  bool _hasPeg({@required int rowIndex, @required int cellIndex}) {
    return _pegs['$rowIndex$cellIndex'];
  }

  bool _hasMarble({@required int rowIndex, @required int cellIndex}) {
    return _marbles['$rowIndex$cellIndex'];
  }

  TableCell buildTableCell({
    @required int rowIndex,
    @required int cellIndex,
  }) {
    bool hasPeg = _hasPeg(rowIndex: rowIndex, cellIndex: cellIndex);
    bool hasMarble = _hasMarble(rowIndex: rowIndex, cellIndex: cellIndex);

    Widget dragTarget = DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container();
      },
      onWillAccept: (data) {
        int draggedRow = int.parse(data[0]);
        int draggedColumn = int.parse(data[1]);

        int rowCheck = (draggedRow - rowIndex).abs();
        int colCheck = (draggedColumn - cellIndex).abs();
        if (((rowCheck == 2) & (colCheck == 0)) |
            ((rowCheck == 0) & (colCheck == 2))) {
          int popRow = (draggedRow + rowIndex) ~/ 2;
          int popColumn = (draggedColumn + cellIndex) ~/ 2;
          if (_marbles['$popRow$popColumn'] == true) {
            print('Marble found at $popRow$popColumn');
            return true;
          } else {
            print('Marble not found at $popRow$popColumn');
            return false;
          }
        } else {
          print('Cant accept $data marble');
          print((draggedRow - rowIndex).abs());
          print((draggedColumn - cellIndex).abs());
          return false;
        }
      },
      onAccept: (data) {
        print("Accepted $data");
        int draggedRow = int.parse(data[0]);
        int draggedColumn = int.parse(data[1]);
        int popRow = (draggedRow + rowIndex) ~/ 2;
        int popColumn = (draggedColumn + cellIndex) ~/ 2;

        setState(() {
          _marbles[data] = false;
          _marbles['$popRow$popColumn'] = false;
          _marbles['$rowIndex$cellIndex'] = true;
        });
      },
    );

    Widget peg = hasMarble
        ? Marble(
            row: rowIndex,
            column: cellIndex,
          )
        : dragTarget;

    return TableCell(
        child: Container(
      child: AspectRatio(
        aspectRatio: 1,
        child: hasPeg
            ? Card(
                elevation: 0,
                color: kColorPeg,
                shape: CircleBorder(),
                child: peg,
              )
            : Container(),
      ),
    ));
  }

  TableRow buildTableRow(
      {@required int rowIndex, @required int numberOfCells}) {
    List<TableCell> rowChildren = new List(numberOfCells);
    for (int cellIndex in Iterable<int>.generate(numberOfCells)) {
      rowChildren[cellIndex] =
          buildTableCell(rowIndex: rowIndex, cellIndex: cellIndex);
    }
    return TableRow(children: rowChildren);
  }

  Table buildTable({@required int rows, @required int columns}) {
    List<TableRow> tableChildren = new List(rows);
    for (int rowIndex in Iterable<int>.generate(rows)) {
      tableChildren[rowIndex] =
          buildTableRow(rowIndex: rowIndex, numberOfCells: columns);
    }
    return Table(children: tableChildren);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: buildTable(rows: 7, columns: 7),
    );
  }
}
