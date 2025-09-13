import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

// Components ki files ko import karna
import 'components/player.dart';
import 'components/enemy.dart';
import 'components/joystick.dart';

// Yeh hamari main game class hai.
class ChronoshotGame extends FlameGame with HasDraggables, HasCollisionDetection {
  late Player player;
  late Joystick joystick;
  late Joystick shootJoystick;

  // Har 2 second mein ek dushman paida karne ka timer.
  final Timer _enemySpawner = Timer(2, repeat: true);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Movement Joystick (Left side)
    joystick = Joystick(
      knobColor: BasicPalette.blue.withAlpha(200).paint(),
      backgroundColor: BasicPalette.blue.withAlpha(100).paint(),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    // Shooting Joystick (Right side)
    shootJoystick = Joystick(
      knobColor: BasicPalette.blue.withAlpha(200).paint(),
      backgroundColor: BasicPalette.blue.withAlpha(100).paint(),
      margin: const EdgeInsets.only(right: 40, bottom: 40),
    );

    player = Player();

    add(player);
    add(joystick);
    add(shootJoystick);

    // Dushman spawner timer shuru karna.
    _enemySpawner.onTick = spawnEnemy;
    _enemySpawner.start();
  }

  // Dushman paida karne ka function.
  void spawnEnemy() {
    final random = Random();
    final position = Vector2(
      random.nextDouble() * size.x,
      random.nextDouble() * size.y,
    );
    add(Enemy(position: position));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _enemySpawner.update(dt);
  }
}
