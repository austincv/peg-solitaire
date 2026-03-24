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
    List<List<bool>> holes = List.generate(config.numberOfRows,
        (row) => List.generate(config.numberOfColumns, (col) => config.holes[row][col]));
    List<List<bool>> pegs = List.generate(config.numberOfRows,
        (row) => List.generate(config.numberOfColumns, (col) => config.pegs[row][col]));

    return BoardConfiguration(
        holes, pegs, config.numberOfRows, config.numberOfColumns);
  }
}
