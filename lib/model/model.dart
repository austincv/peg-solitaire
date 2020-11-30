import 'dart:math';

/// [Hole] is a hole on the board.
/// A Hole can have a Peg in it.
/// A Hole can be empty too.
class Hole {
  final Point position;
  bool hasPeg;
  bool isSelected;

  Hole(this.position, this.hasPeg);
}

/// [Configuration] defines how the board is set up.
/// It does not hold the state of the board but the initial setup.
/// There can be different types of Configurations
class Configuration {
  final String name;
  final List<Hole> holes;
  Configuration(this.name, this.holes);
}

/// [GameState] is used by the [Game] to keep track of the movements of pegs.
/// State keeps a copy of the configuration so that it can also reset to init.
class GameState {
  int _numberOfRows;
  int _numberOfColumns;

  final Configuration configuration;
  Map<Point, Hole> holes;

  GameState(this.configuration) {
    _setHoles();
    _setSizeOfBoard();
  }

  void _setHoles() {
    holes = Map<Point, Hole>();
    for (Hole hole in configuration.holes) {
      holes[hole.position] = Hole(hole.position, hole.hasPeg);
    }
  }

  void reset() {
    holes.clear();
    for (Hole hole in configuration.holes) {
      holes[hole.position] = Hole(hole.position, hole.hasPeg);
    }
  }

  void _setSizeOfBoard() {
    int xMax = 0;
    int yMax = 0;
    for (Hole hole in configuration.holes) {
      xMax = xMax > hole.position.x ? xMax : hole.position.x;
      yMax = yMax > hole.position.y ? yMax : hole.position.y;
    }

    _numberOfColumns = xMax + 1;
    _numberOfRows = yMax + 1;
    print('Size of board rows $_numberOfRows , columns $_numberOfColumns');
  }

  int getNumberOfRows() => _numberOfRows;
  int getNumberOfColumns() => _numberOfColumns;
}

/// [Game] knows the rules of the game.
/// It has [GameState] which is updated to keep track of the game.
class Game {
  GameState state;

  Game(Configuration configuration) {
    this.state = GameState(configuration);
  }

  bool movePegFromPositionToPosition(Point startPosition, Point endPosition) {
    /// 1. check if start and end positions are inside board
    /// 2. check if start position has peg
    /// 3. check if end position is empty
    /// 4. check if distance between start and end position is 2
    /// 5. if position between start and end position has a Peg to remove
    ///    then remove the middle peg
    ///    then move peg from start to end position
    if (state.holes.containsKey(startPosition) &&
        state.holes.containsKey(endPosition)) {
      if (state.holes[startPosition].hasPeg &&
          !state.holes[endPosition].hasPeg) {
        if (startPosition.distanceTo(endPosition) == 2) {
          Point point = startPosition + endPosition;
          Point middle = Point(point.x ~/ 2, point.y ~/ 2);
          if (state.holes[middle].hasPeg) {
            state.holes[middle].hasPeg = false;
            state.holes[endPosition].hasPeg = true;
            state.holes[startPosition].hasPeg = false;
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isGameOver() {
    /// If we can find a hole into which a peg can be inserted
    /// then the game is not over
    ///
    ///
    return false;
  }
}

void main() {
  List<Hole> holes = [
    Hole(Point(0, 0), false),
    Hole(Point(0, 1), true),
  ];
  Configuration config = Configuration("test", holes);
  Game game = Game(config);

  Point start = Point(0, 1);
  Point end = Point(0, 3);
  bool move = game.movePegFromPositionToPosition(Point(0, 0), Point(0, 2));
  print('Move $start to $end : $move');
  print(game.state.holes);
}
