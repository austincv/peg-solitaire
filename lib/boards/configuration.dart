class Index {
  final int row;
  final int column;

  Index(this.row, this.column);
}

class BoardConfiguration {
  final List<List<bool>> holes;
  final List<List<bool>> pegs;

  final int numberOfRows;
  final int numberOfColumns;

  BoardConfiguration(
      this.holes, this.pegs, this.numberOfRows, this.numberOfColumns);

  bool checkIfPegAcceptableInHole(Index peg, Index hole) {
    if (!pegs[peg.row][peg.column]) {
      return false; // peg does not exist
    }

    if (!holes[hole.row][hole.column]) {
      return false; // peg does not exist
    }

    int rowCheck = (peg.row - hole.row).abs();
    int colCheck = (peg.column - hole.column).abs();

    if (((rowCheck == 2) & (colCheck == 0)) |
        ((rowCheck == 0) & (colCheck == 2))) {
      int rowMiddle = (peg.row + hole.row) ~/ 2;
      int columnMiddle = (peg.column + hole.column) ~/ 2;
      bool middlePegExists = pegs[rowMiddle][columnMiddle];
      return middlePegExists; // it is acceptable if the middle peg exists
    }
    return false;
  }

  bool checkGameOver() {
    for (int rowIndex = 0; rowIndex < numberOfRows; rowIndex++) {
      for (int columnIndex = 0; columnIndex < numberOfColumns; columnIndex++) {
        bool holeExists = holes[rowIndex][columnIndex];
        bool holeIsEmpty = !pegs[rowIndex][columnIndex];
        if (holeExists & holeIsEmpty) {
          if (rowIndex + 2 < numberOfRows) {
            if (checkIfPegAcceptableInHole(Index(rowIndex + 2, columnIndex),
                Index(rowIndex, columnIndex))) {
              return false;
            }
          }

          if (rowIndex - 2 >= 0) {
            if (checkIfPegAcceptableInHole(Index(rowIndex - 2, columnIndex),
                Index(rowIndex, columnIndex))) {
              return false;
            }
          }

          if (columnIndex + 2 < numberOfColumns) {
            if (checkIfPegAcceptableInHole(Index(rowIndex, columnIndex + 2),
                Index(rowIndex, columnIndex))) {
              return false;
            }
          }
          if (columnIndex - 2 >= 0) {
            if (checkIfPegAcceptableInHole(Index(rowIndex, columnIndex - 2),
                Index(rowIndex, columnIndex))) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }
}
