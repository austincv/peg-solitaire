import 'dart:math';

/// [Board] defines the setup of the game's board
class Board {
  final int width;
  final int height;
  final Map<Position, Hole> positions;
  Board({this.width, this.height, this.positions});

  Board clone() {
    Map<Position, Hole> _positions = Map<Position, Hole>();
    positions.forEach((position, hole) {
      _positions[position] = hole.clone();
    });
    return Board(width: width, height: height, positions: _positions);
  }
}

/// [Position] is a position on the board
class Position extends Point {
  Position(int x, int y) : super(x, y);

  static Position middle(Position a, Position b) {
    int x = (a.x + b.x) ~/ 2;
    int y = (a.y + b.y) ~/ 2;
    return Position(x, y);
  }
}

/// [Hole] is a hole at a [Position] on the [Board].
/// A Hole can have a [Peg] in it.
/// A Hole can be empty too.
class Hole {
  Peg peg;
  Hole({this.peg});
  bool hasPeg() => peg != null;

  Hole clone() {
    return hasPeg() ? Hole(peg: peg.clone()) : Hole();
  }
}

/// [Peg] can be placed in a Hole
class Peg {
  Peg clone() => Peg();
}

/// [Configuration] defines how the board is set up.
/// It does not hold the state of the board but the initial setup.
/// There can be different types of Configurations
class Configuration {
  final String name;
  final Board _board;
  Configuration({this.name, board}) : _board = board;

  Board getNewBoard() {
    return _board.clone();
  }
}

/// [Game] keeps track of the game.
/// It has [Configuration] which is used to create a board.
class Game {
  final Configuration configuration;
  Board board;
  List<Move> moves = List<Move>();

  Game(this.configuration) {
    board = configuration.getNewBoard();
  }

  void restart() {
    board = configuration.getNewBoard();
  }

  bool play(Move move) {
    if (isPlayableMove(move)) {
      board.positions[move.middle].peg = null;
      board.positions[move.end].peg = board.positions[move.start].peg;
      board.positions[move.start].peg = null;
      moves.add(move);
      return true;
    }
    return false;
  }

  bool isPlayableMove(Move move) {
    return move.start.distanceTo(move.end) == 2 &&
        (board.positions[move.start]?.hasPeg() ?? false) &&
        !(board.positions[move.end]?.hasPeg() ?? false) &&
        (board.positions[move.middle]?.hasPeg() ?? false);
  }

  List<Position> _getPossibleStartPositions(Position p) {
    return [
      Position(p.x + 2, p.y),
      Position(p.x - 2, p.y),
      Position(p.x, p.y + 2),
      Position(p.x, p.y - 2),
    ];
  }

  bool hasEnded() {
    /// If we can not find a hole into which a peg can be inserted
    /// then the game has Ended
    for (MapEntry entry in board.positions.entries) {
      Position holePosition = entry.key;
      Hole hole = entry.value;
      if (!hole.hasPeg()) {
        for (Position startPosition
            in _getPossibleStartPositions(holePosition)) {
          if (isPlayableMove(Move(startPosition, holePosition))) {
            return false;
          }
        }
      }
    }
    return true;
  }
}

/// [Move] defines a move that may be played on a [Board]
class Move {
  final Position start;
  final Position end;
  Position _middle;

  Move(this.start, this.end);

  get middle {
    _middle ??= Position.middle(start, end);
    return _middle;
  }
}

void main() {
  Configuration configuration = Configuration(
    name: "english",
    board: Board(width: 3, height: 1, positions: {
      Position(0, 0): Hole(peg: Peg()),
      Position(1, 0): Hole(peg: Peg()),
      Position(2, 0): Hole(peg: null),
    }),
  );

  Game game = Game(configuration);

  print('The game has ended: ${game.hasEnded()}');
  bool played = game.play(Move(Position(0, 0), Position(2, 0)));
  print(played);
  print('The game has ended: ${game.hasEnded()}');
  // print(game.board.positions[Position(-2, 0)]?.hasPeg() ?? false);
}
