import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ludo_game/ludo_game/board.dart';
import 'package:ludo_game/ludo_game/dice.dart';
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
    for (var p in LudoPlayer.values) p: List.generate(4, (_) => Token()),
  };

  final playerPaths = PlayerPath().buildPlayerPaths();

  /// Simple home-yard pads for each player's 4 tokens (visible when index == -1).
  /// Tune these coordinates to match your LudoBoard's yard drawing.
  final Map<LudoPlayer, List<Cell>> homePads = {
    LudoPlayer.red: [Cell(1, 1), Cell(1, 4), Cell(4, 1), Cell(4, 4)],
    LudoPlayer.green: [Cell(1, 10), Cell(1, 13), Cell(4, 10), Cell(4, 13)],
    LudoPlayer.yellow: [Cell(10, 1), Cell(10, 4), Cell(13, 1), Cell(13, 4)],
    LudoPlayer.blue: [Cell(10, 10), Cell(10, 13), Cell(13, 10), Cell(13, 13)],
  };

  /// Roll dice for the current player, apply move, handle turn switching, and notify.
  int rollDiceForCurrentPlayer() {
    final int v = _rand.nextInt(6) + 1;
    lastDiceRoll = v;
    notifyListeners();
    return v;
  }

  List<int> getMovableTokens(LudoPlayer player, int diceNumber) {
    final List<Token> playerTokens = tokens[player]!;
    final List<int> movable = [];

    for (int i = 0; i < playerTokens.length; i++) {
      final t = playerTokens[i];
      if (t.index == -1) {
        // still in home
        if (diceNumber == 6) movable.add(i); // can come out
      } else {
        final int newIndex = t.index + diceNumber;
        if (newIndex < playerPaths[player]!.length) {
          movable.add(i);
        }
      }
    }
    return movable;
  }

  List<Cell> highlightCells = [];
  List<int> pendingMoves = [];

  void handleDiceRoll(LudoPlayer player, int diceNumber) {
    // store valid tokens for this player & dice
    pendingMoves = getMovableTokens(player, diceNumber);
    lastDiceRoll = diceNumber;
    currentPlayer = player;

    if (pendingMoves.isEmpty) {
      // No valid moves → skip turn
      return;
    }

    // ✅ Highlight tokens for this player so UI can show them selectable
    highlightCells = pendingMoves.map((i) {
      final token = tokens[player]![i];
      if (token.index == -1) {
        // token still in home, so highlight path start cell
        return playerPaths[player]![0];
      } else {
        final index = token.index + diceNumber;
        return playerPaths[player]![index];
      }
    }).toList();
  }

  /// Collision: if any other player's token sits on the same cell (r,c), send them home.
  void _applyCollision(LudoPlayer mover, int moverIndex) {
    final Cell dest = playerPaths[mover]![moverIndex];
    final List<Cell> safeSpots = [Cell(8,2),Cell(13,6),Cell(6,1),Cell(2,6),Cell(1,8),Cell(6,12),Cell(8,13),Cell(12,8)];

    for (final otherPlayer in LudoPlayer.values) {
      if (otherPlayer == mover) continue;
      final List<Token> otherTokens = tokens[otherPlayer]!;

      for (int i = 0; i < otherTokens.length; i++) {
        final Token ot = otherTokens[i];
        if (ot.index >= 0 && ot.index < playerPaths[otherPlayer]!.length) {
          final Cell otherCell = playerPaths[otherPlayer]![ot.index];
          if (otherCell == dest && !safeSpots.contains(dest)) {
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
      for (var c in LudoColor.values) c: <Cell>[],
    };

    for (final player in LudoPlayer.values) {
      final color = _mapPlayerToColor(player);
      final List<Token> pTokens = tokens[player]!;
      final List<Cell> pPath = playerPaths[player]!;

      for (int i = 0; i < pTokens.length; i++) {
        final Token t = pTokens[i];
        if (t.index == -1) {
          // still at home
          out[color]!.add(homePads[player]![i]);
        } else if (t.index >= 0 && t.index < pPath.length) {
          out[color]!.add(pPath[t.index]);
        } else {
          // defensive: fallback to home if something goes wrong
          out[color]!.add(homePads[player]![i]);
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
        if (t.index >= 0 && t.index < playerPaths[p]!.length) {
          final c = playerPaths[p]![t.index];
          return '(${c.r},${c.c})';
        }
        return '?';
        return '(${c.r},${c.c})';
      }).toList();
      map[p.toString()] = list;
    }
    return map.toString();
  }

  void moveToken(LudoPlayer player, int tokenIndex, int diceNumber) {
    if (currentPlayer.name == player.name) {
      final token = tokens[player]![tokenIndex];
      print("Token Index ${token.index} and $diceNumber");
      if (token.index == -1 && diceNumber == 6 && lastDiceRoll == 6) {
        token.index = 0; // bring out
        _applyCollision(player, 0);
        lastDiceRoll = 0;
      } else {
        //Procced only if token is out of home
        if (token.index != -1) {
          final newIndex = token.index + diceNumber;
          if (newIndex < playerPaths[player]!.length) {
            token.index = newIndex;
            _applyCollision(player, newIndex);
            lastDiceRoll = 0;
          }
        }
      }
    }

    // clear highlights after move
    highlightCells = [];
    pendingMoves = [];
  }
}
