import 'dart:math';

import 'model.dart';

Configuration englishConfiguration = Configuration("English", [
  // #1 Row

  Hole(Point(2, 0), true),
  Hole(Point(3, 0), true),
  Hole(Point(4, 0), true),

  // #2 Row

  Hole(Point(2, 1), true),
  Hole(Point(3, 1), true),
  Hole(Point(4, 1), true),

  // #3 Row
  Hole(Point(0, 2), true),
  Hole(Point(1, 2), true),
  Hole(Point(2, 2), true),
  Hole(Point(3, 2), true),
  Hole(Point(4, 2), true),
  Hole(Point(5, 2), true),
  Hole(Point(6, 2), true),

  // #4 Row
  Hole(Point(0, 3), true),
  Hole(Point(1, 3), true),
  Hole(Point(2, 3), true),
  Hole(Point(3, 3), false),
  Hole(Point(4, 3), true),
  Hole(Point(5, 3), true),
  Hole(Point(6, 3), true),

  // #5 Row
  Hole(Point(0, 4), true),
  Hole(Point(1, 4), true),
  Hole(Point(2, 4), true),
  Hole(Point(3, 4), true),
  Hole(Point(4, 4), true),
  Hole(Point(5, 4), true),
  Hole(Point(6, 4), true),

  // #6 Row
  Hole(Point(2, 5), true),
  Hole(Point(3, 5), true),
  Hole(Point(4, 5), true),

  // #7 Row
  Hole(Point(2, 6), true),
  Hole(Point(3, 6), true),
  Hole(Point(4, 6), true),
]);
