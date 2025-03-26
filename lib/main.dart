import 'package:flutter/material.dart';
import 'package:number_plate_app/game_play_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePlayPage(),
    );
  }
}