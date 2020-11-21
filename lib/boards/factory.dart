import 'configuration.dart';

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
    int length = config.numberOfRows * config.numberOfColumns;
    List<List<bool>> holes = new List<List<bool>>(length);
    List<List<bool>> pegs = new List<List<bool>>(length);
    for (int row = 0; row < config.numberOfRows; row++) {
      List<bool> holeRow = new List<bool>(config.numberOfColumns);
      List<bool> pegRow = new List<bool>(config.numberOfColumns);
      for (int column = 0; column < config.numberOfColumns; column++) {
        holeRow[column] = config.holes[row][column];
        pegRow[column] = config.pegs[row][column];
      }
      holes[row] = holeRow;
      pegs[row] = pegRow;
    }

    return BoardConfiguration(
        holes, pegs, config.numberOfRows, config.numberOfColumns);
  }
}
