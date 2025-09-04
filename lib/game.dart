import 'package:flutter/material.dart';
import 'package:ludo_game/board.dart' as board;
import 'package:ludo_game/dice.dart' as dice;
import 'package:ludo_game/game_controller.dart' hide Cell;
import 'package:ludo_game/models/cell.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
 
 LudoGameController _gameController = LudoGameController();

 dice.LudoPlayer _playerFromColor(board.LudoColor c) {
  switch (c) {
    case board.LudoColor.red: return dice.LudoPlayer.red;
    case board.LudoColor.green: return dice.LudoPlayer.green;
    case board.LudoColor.yellow: return dice.LudoPlayer.yellow;
    case board.LudoColor.blue: return dice.LudoPlayer.blue;
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              //Dices for each player
          
          Positioned(
            left: 10,bottom: 630,
            child: dice.AnimatedDice(
            player: dice.LudoPlayer.red,
            onRolled: (value, player) {
              setState(() {
                _gameController.handleDiceRoll(player, value);
              });
                 
                  }),),
          
                  Positioned(
            right: 10,bottom: 630,
            child: dice.AnimatedDice(
            player: dice.LudoPlayer.green,
            onRolled: (value, player) {
 setState(() {
                _gameController.handleDiceRoll(player, value);
              });                  }),),
          
                  Positioned(
            left: 10,top: 640,
            child: dice.AnimatedDice(
            player: dice.LudoPlayer.yellow,
            onRolled: (value, player) {
 setState(() {
                _gameController.handleDiceRoll(player, value);
              });                  }),),
          
                  Positioned(
            right: 10,top: 640,
            child: dice.AnimatedDice(
            player: dice.LudoPlayer.blue,
            onRolled: (value, player) {
 setState(() {
                
                _gameController.handleDiceRoll(player, value);
              });                  }),),
          
                  //ludo board
              Center(
                child: board.LudoBoard(
                  size: 380,
                  showGrid: true,
                  tokens: _gameController.getTokenCells(),
                  highlightCells:  [Cell(7, 6), Cell(7, 8)],
                   onTokenTap: (color, tokenIndex) {
    // map LudoColor -> LudoPlayer and call controller's moveToken
    setState(() {
       final player = _playerFromColor(color);
    print("Token index for selected player $tokenIndex");
    _gameController.moveToken(player, tokenIndex,_gameController.lastDiceRoll??0); // or whichever method you have
    });
   
  },
                ),
              ),
            ],
          ),
        
        ),
      );
  }
}