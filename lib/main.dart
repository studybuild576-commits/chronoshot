import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// Hamari mukhya game file ko import karna
import 'game.dart'; 

// App ko shuru karne wala main function
void main() {
  runApp(
    // GameWidget hamare game ko screen par dikhata hai
    GameWidget(
      game: ChronoshotGame(),
    ),
  );
}

