import 'package:ludo_game/dice.dart';
import 'package:ludo_game/models/cell.dart';

class PlayerPath {
  /// canonical 52-cell loop (clockwise) around the board for the painter used earlier
final List<Cell> mainLoop = const [
  // left arm, moving right
  Cell(6,0), Cell(6,1), Cell(6,2), Cell(6,3), Cell(6,4), Cell(6,5),
  // up into top-left of cross
  Cell(5,6), Cell(4,6), Cell(3,6), Cell(2,6), Cell(1,6), Cell(0,6),
  // across top
  Cell(0,7), Cell(0,8),
  // down the top-right column
  Cell(1,8), Cell(2,8), Cell(3,8), Cell(4,8), Cell(5,8), 
  // right arm moving right
  Cell(6,9), Cell(6,10), Cell(6,11), Cell(6,12), Cell(6,13), Cell(6,14),
  // down the rightmost column
  Cell(7,14), Cell(8,14),
  // across lower-right block (leftwards on row 8)
  Cell(8,13), Cell(8,12), Cell(8,11), Cell(8,10), Cell(8,9),
  // down to bottom
  Cell(9,8), Cell(10,8), Cell(11,8), Cell(12,8), Cell(13,8), Cell(14,8),
  // bottom row (leftwards)
  Cell(14,7), Cell(14,6),
  // up into lower-left block
  Cell(13,6), Cell(12,6), Cell(11,6), Cell(10,6), Cell(9,6), 
  // left arm bottom part (moving left)
  Cell(8,5), Cell(8,4), Cell(8,3), Cell(8,2), Cell(8,1), Cell(8,0),
  // back up to start
  Cell(7,0),
];

/// helper to rotate the main loop so the given `startIndex` becomes index 0
List<Cell> _rotatedLoop(int startIndex,int endIndex) {
  final List<Cell> out = [];
  out.addAll(mainLoop.sublist(startIndex));
  out.addAll(mainLoop.sublist(startIndex, endIndex));
  return out;
}

/// home-stretch (6 cells) for each player, ending pointing to the center.
/// These are the 6 cells a token must traverse after the 52-loop to reach the finish.
/// Make sure these coordinates match your painter's center orientation.
final List<Cell> redHome   = const [ Cell(7,1), Cell(7,2), Cell(7,3), Cell(7,4), Cell(7,5), Cell(7,6) ];
final List<Cell> greenHome = const [ Cell(1,7), Cell(2,7), Cell(3,7), Cell(4,7), Cell(5,7), Cell(6,7) ];
final List<Cell> blueHome= const [ Cell(7,13), Cell(7,12), Cell(7,11), Cell(7,10), Cell(7,9), Cell(7,8) ];
final List<Cell> yellowHome  = const [ Cell(13,7), Cell(12,7), Cell(11,7), Cell(10,7), Cell(9,7), Cell(8,7) ];

/// canonical entry indices in `mainLoop` for each player (clockwise)
final Map<LudoPlayer, int> entryIndex = {
  LudoPlayer.red: 1,    // mainLoop[0] == Cell(6,0)
  LudoPlayer.green: 14, // mainLoop[13] == Cell(0,8)
  LudoPlayer.yellow: 41,// mainLoop[26] == Cell(8,14)
  LudoPlayer.blue: 28,  // mainLoop[39] == Cell(14,6)
};

/// canonical exit indices in `mainLoop` for each player (clockwise)
final Map<LudoPlayer, int> exitIndex = {
  LudoPlayer.red: 52,    // mainLoop[0] == Cell(6,0)
  LudoPlayer.green: 14, // mainLoop[13] == Cell(0,8)
  LudoPlayer.yellow: 41,// mainLoop[26] == Cell(8,14)
  LudoPlayer.blue: 28,  // mainLoop[39] == Cell(14,6)
};

/// Build the final playerPaths map: rotated main loop + corresponding home stretch
Map<LudoPlayer, List<Cell>> buildPlayerPaths() {
  print(''' {
    LudoPlayer.red:    [${_rotatedLoop(entryIndex[LudoPlayer.green]!,exitIndex[LudoPlayer.green]!)}   ...redHome],
 
  }''');
  return {
    LudoPlayer.red:    [
      Cell(6,1), Cell(6,2), Cell(6,3), Cell(6,4), Cell(6,5),
  // up into top-left of cross
  Cell(5,6), Cell(4,6), Cell(3,6), Cell(2,6), Cell(1,6), Cell(0,6),
  // across top
  Cell(0,7), Cell(0,8),
  // down the top-right column
  Cell(1,8), Cell(2,8), Cell(3,8), Cell(4,8), Cell(5,8), 
  // right arm moving right
  Cell(6,9), Cell(6,10), Cell(6,11), Cell(6,12), Cell(6,13), Cell(6,14),
  // down the rightmost column
  Cell(7,14), Cell(8,14),
  // across lower-right block (leftwards on row 8)
  Cell(8,13), Cell(8,12), Cell(8,11), Cell(8,10), Cell(8,9),
  // down to bottom
  Cell(9,8), Cell(10,8), Cell(11,8), Cell(12,8), Cell(13,8), Cell(14,8),
  // bottom row (leftwards)
  Cell(14,7), Cell(14,6),
  // up into lower-left block
  Cell(13,6), Cell(12,6), Cell(11,6), Cell(10,6), Cell(9,6), 
  // left arm bottom part (moving left)
  Cell(8,5), Cell(8,4), Cell(8,3), Cell(8,2), Cell(8,1), Cell(8,0),
  // back up to start
  Cell(7,0),   ...redHome],
    LudoPlayer.green:  [Cell(1,8), Cell(2,8), Cell(3,8), Cell(4,8), Cell(5,8), 
  // right arm moving right
  Cell(6,9), Cell(6,10), Cell(6,11), Cell(6,12), Cell(6,13), Cell(6,14),
  // down the rightmost column
  Cell(7,14), Cell(8,14),
  // across lower-right block (leftwards on row 8)
  Cell(8,13), Cell(8,12), Cell(8,11), Cell(8,10), Cell(8,9),
  // down to bottom
  Cell(9,8), Cell(10,8), Cell(11,8), Cell(12,8), Cell(13,8), Cell(14,8),
  // bottom row (leftwards)
  Cell(14,7), Cell(14,6),
  // up into lower-left block
  Cell(13,6), Cell(12,6), Cell(11,6), Cell(10,6), Cell(9,6), 
  // left arm bottom part (moving left)
  Cell(8,5), Cell(8,4), Cell(8,3), Cell(8,2), Cell(8,1), Cell(8,0),
  // back up to start
  Cell(7,0),Cell(6,0), Cell(6,1), Cell(6,2), Cell(6,3), Cell(6,4), Cell(6,5),
  // up into top-left of cross
  Cell(5,6), Cell(4,6), Cell(3,6), Cell(2,6), Cell(1,6), Cell(0,6),
  // across top
  Cell(0,7), ...greenHome],

    LudoPlayer.yellow: [ Cell(13,6), Cell(12,6), Cell(11,6), Cell(10,6), Cell(9,6), 
  // left arm bottom part (moving left)
  Cell(8,5), Cell(8,4), Cell(8,3), Cell(8,2), Cell(8,1), Cell(8,0),
  // back up to start
  Cell(7,0),// left arm, moving right
  Cell(6,0), Cell(6,1), Cell(6,2), Cell(6,3), Cell(6,4), Cell(6,5),
  // up into top-left of cross
  Cell(5,6), Cell(4,6), Cell(3,6), Cell(2,6), Cell(1,6), Cell(0,6),
  // across top
  Cell(0,7), Cell(0,8),
  // down the top-right column
  Cell(1,8), Cell(2,8), Cell(3,8), Cell(4,8), Cell(5,8), 
  // right arm moving right
  Cell(6,9), Cell(6,10), Cell(6,11), Cell(6,12), Cell(6,13), Cell(6,14),
  // down the rightmost column
  Cell(7,14), Cell(8,14),
  // across lower-right block (leftwards on row 8)
  Cell(8,13), Cell(8,12), Cell(8,11), Cell(8,10), Cell(8,9),
  // down to bottom
  Cell(9,8), Cell(10,8), Cell(11,8), Cell(12,8), Cell(13,8), Cell(14,8),
  // bottom row (leftwards)
  Cell(14,7),...yellowHome],

    LudoPlayer.blue:   [Cell(8,13), Cell(8,12), Cell(8,11), Cell(8,10), Cell(8,9),
  // down to bottom
  Cell(9,8), Cell(10,8), Cell(11,8), Cell(12,8), Cell(13,8), Cell(14,8),
  // bottom row (leftwards)
  Cell(14,7), Cell(14,6),
  // up into lower-left block
  Cell(13,6), Cell(12,6), Cell(11,6), Cell(10,6), Cell(9,6), 
  // left arm bottom part (moving left)
  Cell(8,5), Cell(8,4), Cell(8,3), Cell(8,2), Cell(8,1), Cell(8,0),
  // back up to start
  Cell(7,0),  // left arm, moving right
  Cell(6,0), Cell(6,1), Cell(6,2), Cell(6,3), Cell(6,4), Cell(6,5),
  // up into top-left of cross
  Cell(5,6), Cell(4,6), Cell(3,6), Cell(2,6), Cell(1,6), Cell(0,6),
  // across top
  Cell(0,7), Cell(0,8),
  // down the top-right column
  Cell(1,8), Cell(2,8), Cell(3,8), Cell(4,8), Cell(5,8), 
  // right arm moving right
  Cell(6,9), Cell(6,10), Cell(6,11), Cell(6,12), Cell(6,13), Cell(6,14),
  // down the rightmost column
  Cell(7,14), Cell(8,14),  ...blueHome],
  };
}
}
