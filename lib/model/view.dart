import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peg_solitaire/model/configuration.dart';
import 'package:peg_solitaire/model/model.dart' as model;
import 'package:peg_solitaire/model/theme.dart';

AppColors colors = orange;

class GameScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 0.5625,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Header(), Info(), Board(), Footer()],
            ),
          ),
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  model.Game game = model.Game(englishConfiguration);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Center(
        child: buildBoardLayout(),
      ),
    );
  }

  Widget buildBoardLayout() {
    double aspectRatio =
        game.state.getNumberOfColumns() / game.state.getNumberOfRows();

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        width: double.infinity,
        color: colors.background,
        child: LayoutBuilder(
          builder: (context, constraints) => buildStackOfHoles(constraints),
        ),
      ),
    );
  }

  Stack buildStackOfHoles(BoxConstraints constraints) {
    double extraSpaceAroundStackOfHoles = 1;
    double height = constraints.maxHeight /
        (game.state.getNumberOfRows() + extraSpaceAroundStackOfHoles);
    double width = constraints.maxWidth /
        (game.state.getNumberOfColumns() + extraSpaceAroundStackOfHoles);
    Point offset = Point(extraSpaceAroundStackOfHoles * width / 2,
        extraSpaceAroundStackOfHoles * height / 2);

    double reduceHoleSizeFactor = 0.9;
    Size boxSize = Size(width, height);
    Size holeSize = Size(boxSize.width * reduceHoleSizeFactor,
        boxSize.height * reduceHoleSizeFactor);
    List<PositionedBox> positionedHoles = List<PositionedBox>();

    for (model.Hole hole in game.state.holes.values) {
      PositionedBox positionedHole = PositionedBox(
        position: Point(hole.position.x * width, hole.position.y * height),
        offset: offset,
        boxSize: boxSize,
        holeSize: holeSize,
        holeColor: colors.hole,
        highlightColor: colors.holeHighlight,
      );
      positionedHoles.add(positionedHole);
    }

    return Stack(children: positionedHoles);
  }
}

class PositionedBox extends StatelessWidget {
  final Point position;
  final Point offset;
  final Size boxSize;
  final Size holeSize;
  final Color highlightColor;
  final Color holeColor;

  PositionedBox(
      {this.position,
      this.offset,
      this.boxSize,
      this.holeSize,
      this.highlightColor,
      this.holeColor});

  Widget build(BuildContext context) {
    return positioned(
      SizedBox.fromSize(
          size: boxSize,
          child: Container(
            child: Center(
              child: buildHole(),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: colors.background,
            ),
          )),
    );
  }

  Positioned positioned(child) {
    return Positioned(
      left: position.x + offset.x,
      top: position.y + offset.y,
      child: child,
    );
  }

  SizedBox buildHole() {
    return SizedBox.fromSize(
      size: holeSize,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: holeColor,
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Row(
          children: [Title(), Score()],
        ),
      ),
    );
  }
}

class Score extends StatefulWidget {
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: colors.background,
        child: Center(
          child: Text(
            "Score: 10",
            style: TextStyle(color: colors.text),
          ),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Row(
          children: [Ads()],
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        color: colors.background,
        child: Center(
            child: Text(
          'Peg Solitaire',
          style: TextStyle(color: colors.text),
        )),
      ),
    );
  }
}

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: colors.background,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              'The aim of the game is to move all'
              ' the pegs and end up with nothing',
              style: TextStyle(color: colors.text),
            ),
          ),
        ),
      ),
    );
  }
}

class Ads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Text(
            'Ads go here ... ',
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }
}
