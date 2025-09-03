import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ludo_game/board.dart';
import 'package:ludo_game/dice.dart';
import 'package:ludo_game/models/cell.dart';
import 'package:ludo_game/models/player_path.dart';



// class Cell {
//   final int r;
//   final int c;
//   const Cell(this.r, this.c);

//   @override
//   bool operator ==(Object other) =>
//       other is Cell && other.r == r && other.c == c;
//   @override
//   int get hashCode => r * 31 + c;
// }

/// simple token model: index in that player's path. -1 => in home/yard
class Token {
  int index;
  Token({this.index = -1});
}

/// Controller for game state and rules (not UI)
class LudoGameController extends ChangeNotifier {
  final Random _rand = Random();
int? lastDiceRoll;

  /// Current turn
  LudoPlayer currentPlayer = LudoPlayer.red;

  /// 4 tokens per player
  final Map<LudoPlayer, List<Token>> tokens = {
    for (var p in LudoPlayer.values) p: List.generate(4, (_) => Token())
  };



final playerPaths = PlayerPath().buildPlayerPaths();
  /// Simple home-yard pads for each player's 4 tokens (visible when index == -1).
  /// Tune these coordinates to match your LudoBoard's yard drawing.
  final Map<LudoPlayer, List<Cell>> homePads = {
    LudoPlayer.red: [Cell(1,1), Cell(1,4), Cell(4,1), Cell(4,4)],
    LudoPlayer.green: [Cell(1,10), Cell(1,13), Cell(4,10), Cell(4,13)],
    LudoPlayer.yellow: [Cell(10,1), Cell(10,4), Cell(13,1), Cell(13,4)],
    LudoPlayer.blue: [Cell(10,10), Cell(10,13), Cell(13,10), Cell(13,13)],
  };

  /// Roll dice for the current player, apply move, handle turn switching, and notify.
  int rollDiceForCurrentPlayer() {
 final int v = _rand.nextInt(6) + 1;
  lastDiceRoll = v;
  notifyListeners();
  return v;
  }

  /// Core move logic
  void handleDiceRoll(LudoPlayer player, int diceNumber) {
    final List<Token> playerTokens = tokens[player]!;

    // 🟥 Case 1: all tokens are in home (-1)
  final bool allInHome = playerTokens.every((t) => t.index == -1);
  if (allInHome) {
    if (diceNumber == 6) {
      // bring one token out
      playerTokens.first.index = 0;
      _applyCollision(player, 0);
    }
    // else skip turn (do nothing)
    return;
  }

  // 🟩 Case 2: if dice == 6 and there is still a token at home → bring it out
  if (diceNumber == 6) {
    final int homeTokenIndex = playerTokens.indexWhere((t) => t.index == -1);
    if (homeTokenIndex != -1) {
      playerTokens[homeTokenIndex].index = 0;
      _applyCollision(player, 0);
      return;
    }
  }

  // 🟦 Case 3: move an existing token on the board
  Token? chosen;
  for (final t in playerTokens) {
    if (t.index >= 0) {
      final int newIndex = t.index + diceNumber;
      if (newIndex < playerPaths[player]!.length) {
        chosen = t;
        break;
      }
    }
  }

    if (chosen == null) {
      // nothing can move
      return;
    }

    final int newIndex = chosen.index + diceNumber;
    chosen.index = newIndex;
    _applyCollision(player, newIndex);
  }

  /// Collision: if any other player's token sits on the same cell (r,c), send them home.
  void _applyCollision(LudoPlayer mover, int moverIndex) {
    final Cell dest = playerPaths[mover]![moverIndex];

    for (final otherPlayer in LudoPlayer.values) {
      if (otherPlayer == mover) continue;
      final List<Token> otherTokens = tokens[otherPlayer]!;

      for (int i = 0; i < otherTokens.length; i++) {
        final Token ot = otherTokens[i];
        if (ot.index >= 0 && ot.index < playerPaths[otherPlayer]!.length) {
          final Cell otherCell = playerPaths[otherPlayer]![ot.index];
          if (otherCell == dest) {
            // send that token back to home
            otherTokens[i].index = -1;
          }
        }
      }
    }
  }

  /// Return the data structure expected by your LudoBoard:
  /// Map<LudoColor, List<Cell>>
  Map<LudoColor, List<Cell>> getTokenCells() {
    final Map<LudoColor, List<Cell>> out = {
      for (var c in LudoColor.values) c: <Cell>[]
    };

    for (final player in LudoPlayer.values) {
      final color = _mapPlayerToColor(player);
      final List<Token> pTokens = tokens[player]!;
      final List<Cell> pPath = playerPaths[player]!;

      for (int i = 0; i < pTokens.length; i++) {
        final Token t = pTokens[i];
        if (t.index == -1) {
          // in yard — use homePad assigned by token slot (i)
          out[color]!.add(homePads[player]![i]);
        } else {
          final int idx = t.index;
          // defensive: clamp
          final int safeIdx = (idx < pPath.length) ? idx : pPath.length - 1;
          out[color]!.add(pPath[safeIdx]);
        }
      }
    }
    return out;
  }

  LudoColor _mapPlayerToColor(LudoPlayer p) {
    switch (p) {
      case LudoPlayer.red:
        return LudoColor.red;
      case LudoPlayer.green:
        return LudoColor.green;
      case LudoPlayer.yellow:
        return LudoColor.yellow;
      case LudoPlayer.blue:
        return LudoColor.blue;
    }
  }

  String _debugTokenPositions() {
    final Map<String, List<String>> map = {};
    for (final p in LudoPlayer.values) {
      final list = tokens[p]!.map((t) {
        if (t.index == -1) return 'H';
        final c = playerPaths[p]![t.index];
        return '(${c.r},${c.c})';
      }).toList();
      map[p.toString()] = list;
    }
    return map.toString();
  }

  bool moveToken(LudoPlayer player, int tokenIndex) {
    debugPrint("Move Token CAlled");
  final diceNumber = lastDiceRoll;
  if (diceNumber == null) return false; // no roll yet

  final List<Token> playerTokens = tokens[player]!;
  final Token token = playerTokens[tokenIndex];

  // Case 1: token is at home
  if (token.index == -1) {
    if (diceNumber == 6) {
      token.index = 0; // bring onto board
      _applyCollision(player, 0);
      lastDiceRoll = null; // consume dice
      notifyListeners();
      return true;
    } else {
      return false; // invalid move
    }
  }

  // Case 2: token is on board
  final int newIndex = token.index + diceNumber;
  if (newIndex < playerPaths[player]!.length) {
    token.index = newIndex;
    _applyCollision(player, newIndex);
    lastDiceRoll = null; // consume dice
    notifyListeners();
    return true;
  }

  if (diceNumber != 6) {
  currentPlayer = LudoPlayer.values[
      (currentPlayer.index + 1) % LudoPlayer.values.length];
}


  return false; // move not possible
}

}
