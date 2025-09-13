import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'components/player.dart';
import 'components/enemy.dart';

// Game ki alag-alag states
enum GameState { playing, gameOver }

// Updated Flame 1.18+ Game class
class ChronoshotGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Player player;
  late JoystickComponent joystick;
  late JoystickComponent shootJoystick;
  late TextComponent scoreText;
  late TextComponent healthText;

  int score = 0;
  GameState state = GameState.playing;

  final Timer _enemySpawner = Timer(2, repeat: true);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    startGame();
  }

  void startGame() {
    score = 0;
    state = GameState.playing;

    player = Player();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.blue.withAlpha(200)),
      background: CircleComponent(radius: 50, paint: Paint()..color = Colors.blue.withAlpha(100)),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    shootJoystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.red.withAlpha(200)),
      background: CircleComponent(radius: 50, paint: Paint()..color = Colors.red.withAlpha(100)),
      margin: const EdgeInsets.only(right: 40, bottom: 40),
    );

    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(size.x - 40, 40),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24)),
    );

    healthText = TextComponent(
      text: 'Health: 3',
      position: const Vector2(40, 40),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24)),
    );

    add(player);
    add(joystick);
    add(shootJoystick);
    add(scoreText);
    add(healthText);

    _enemySpawner.onTick = spawnEnemy;
    _enemySpawner.start();
  }

  void spawnEnemy() {
    if (state == GameState.playing) {
      final random = Random();
      final position = Vector2(
        random.nextDouble() * size.x,
        random.nextDouble() * size.y,
      );
      add(Enemy(position: position));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state == GameState.playing) {
      _enemySpawner.update(dt);
      scoreText.text = 'Score: $score';

      if (player.isMounted) {
        healthText.text = 'Health: ${player.health}';
      }

      if (player.health <= 0 && player.isMounted) {
        player.removeFromParent();
        state = GameState.gameOver;
        showGameOver();
      }
    }
  }

  void showGameOver() {
    removeWhere((component) => component is Enemy || component is JoystickComponent);

    final gameOverText = TextComponent(
      text: 'Game Over',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: const TextPaint(style: TextStyle(color: Colors.white, fontSize: 64)),
    );

    final restartText = TextComponent(
      text: 'Tap to Restart',
      position: size / 2 + Vector2(0, 80),
      anchor: Anchor.center,
      textRenderer: const TextPaint(style: TextStyle(color: Colors.white, fontSize: 32)),
    );

    add(gameOverText);
    add(restartText);
  }

  void reset() {
    removeWhere((component) => component is TextComponent || component is Player || component is Enemy);
    startGame();
  }

  @override
  void onTapDown(TapDownDetails details) {
    if (state == GameState.gameOver) {
      reset();
    }
  }
}
