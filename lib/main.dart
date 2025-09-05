import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ludo_game/ludo_game/board.dart';
import 'package:ludo_game/ludo_game/dice.dart';
import 'package:ludo_game/ludo_game/game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

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
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Game()
    );
  }
}
