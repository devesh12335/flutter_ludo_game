import 'package:flutter/material.dart';
import 'package:ludo_game/board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: Center(
          child: LudoBoard(
            size: 360,
            showGrid: true,
            tokens: {
        // LudoColor.red:   [const Cell(7, 2), const Cell(1, 1)],
        // LudoColor.green: [const Cell(7, 12)],
        // LudoColor.yellow:[const Cell(12, 7)],
        // LudoColor.blue:  [const Cell(2, 7)],
            },
            highlightCells: const [Cell(7, 6), Cell(7, 8)],
          ),
        ),
      ),
    );
  }
}
