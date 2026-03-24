# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get       # Install dependencies
flutter run           # Run on default device
flutter test          # Run tests
flutter build web     # Build for web (output goes to docs/)
```

## Architecture

This is a Flutter implementation of the classic Peg Solitaire board game. State is managed entirely with stateful widgets and `setState()` — no external state management libraries.

### Key files

- `lib/main.dart` — App entry point; wraps `Board` in a `MaterialApp` with dark theme
- `lib/board.dart` — Main `StatefulWidget` orchestrating all game state (`isGameOver`, drag state, current peg being dragged)
- `lib/boards/configuration.dart` — Core game logic: `BoardConfiguration` (holes/pegs as 2D bool arrays, move validation, game-over detection) and the `Index` coordinate type
- `lib/boards/factory.dart` — `BoardFactory.get(0)` returns a fresh 7×7 cross-shaped board with 32 pegs and center hole empty
- `lib/boards/peg.dart` — Draggable peg widget; passes `Index` as drag data
- `lib/boards/hole.dart` — `DragTarget` hole widget with `AnimatedContainer` color transitions (300ms)
- `lib/constants.dart` — All color and UI constants

### Game logic flow

1. Player drags a `Peg`; `board.dart` sets `isPegBeingDragged = true` and records `indexOfPegBeingDragged`
2. Each `Hole` calls `checkIfPegIsDroppableInHole(pegIndex, holeIndex)` on hover to determine color feedback (green = valid, pink = invalid)
3. On drop (`onAccept`), the move is executed: source peg removed, jumped peg removed, target peg placed — all via `setState()`
4. After each move, `checkGameOver()` scans all empty holes for any remaining valid jumps; sets `isGameOver` if none exist

### Board layout

The board is a 7×7 grid where `holes[row][col]` marks valid positions (cross/plus shape). The web build output lives in `docs/` for GitHub Pages deployment.
