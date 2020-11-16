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

  bool _hasPeg(int row, int column) {
    return _pegs['$row$column'];
  }

  bool _hasMarble(int row, int column) {
    return _marbles['$row$column'];
  }

  DragTarget getEmptyPeg(int row, int column) {
    /// Create a drag target on which marbles can be dropped.
    /// This function defines which marbles can be accepted
    /// according to the rules of peg solitaire
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container();
      },
      onWillAccept: (data) {
        int draggedRow = int.parse(data[0]);
        int draggedColumn = int.parse(data[1]);

        int rowCheck = (draggedRow - row).abs();
        int colCheck = (draggedColumn - column).abs();
        if (((rowCheck == 2) & (colCheck == 0)) |
            ((rowCheck == 0) & (colCheck == 2))) {
          int popRow = (draggedRow + row) ~/ 2;
          int popColumn = (draggedColumn + column) ~/ 2;
          if (_marbles['$popRow$popColumn'] == true) {
            print('Marble found at $popRow$popColumn');
            return true;
          } else {
            print('Marble not found at $popRow$popColumn');
            return false;
          }
        } else {
          print('Cant accept $data marble');
          print((draggedRow - row).abs());
          print((draggedColumn - column).abs());
          return false;
        }
      },
      onAccept: (data) {
        print("Accepted $data");
        int draggedRow = int.parse(data[0]);
        int draggedColumn = int.parse(data[1]);
        int popRow = (draggedRow + row) ~/ 2;
        int popColumn = (draggedColumn + column) ~/ 2;

        setState(() {
          _marbles[data] = false;
          _marbles['$popRow$popColumn'] = false;
          _marbles['$row$column'] = true;
        });
      },
    );
  }

  TableCell buildTableCell(int row, int column) {
    bool hasPeg = _hasPeg(row, column);
    bool hasMarble = _hasMarble(row, column);

    Widget peg = hasMarble
        ? Marble(
            row: row,
            column: column,
          )
        : getEmptyPeg(row, column);

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

  TableRow buildTableRow(int row, int columns) {
    List<TableCell> cells = new List(columns);
    for (int column = 0; column < columns; column++) {
      cells[column] = buildTableCell(row, column);
    }
    return TableRow(children: cells);
  }

  Table buildTable(int rows, int columns) {
    List<TableRow> tableChildren = new List(rows);
    for (int row = 0; row < rows; row++) {
      tableChildren[row] = buildTableRow(row, columns);
    }
    return Table(children: tableChildren);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: buildTable(7, 7),
    );
  }
}
