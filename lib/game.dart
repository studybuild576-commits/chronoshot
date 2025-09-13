import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'components/player.dart';
import 'components/enemy.dart';
import 'components/joystick.dart';

// Game ki alag-alag states
enum GameState { playing, gameOver }

// Galti 3: HasDraggables aur TapDetector ko naye DragCallbacks aur TapCallbacks se badal diya gaya hai
class ChronoshotGame extends FlameGame with HasCollisionDetection, DragCallbacks, TapCallbacks {
  late Player player;
  late Joystick joystick;
  late Joystick shootJoystick;
  late TextComponent scoreText;
  late TextComponent healthText;

  int score = 0;
  GameState state = GameState.playing;

  final Timer _enemySpawner = Timer(2, repeat: true);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Game shuru hone par
    startGame();
  }

  void startGame() {
    // Sab kuch reset karna
    score = 0;
    state = GameState.playing;
    
    // Player, joystick, etc. banana
    player = Player();
    
    joystick = Joystick(
      knobColor: BasicPalette.blue.withAlpha(200).paint(),
      backgroundColor: BasicPalette.blue.withAlpha(100).paint(),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    shootJoystick = Joystick(
      knobColor: BasicPalette.blue.withAlpha(200).paint(),
      backgroundColor: BasicPalette.blue.withAlpha(100).paint(),
      margin: const EdgeInsets.only(right: 40, bottom: 40),
    );

    scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(size.x - 40, 40),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(style: TextStyle(color: BasicPalette.white.color, fontSize: 24)),
    );

    healthText = TextComponent(
      text: 'Health: 3', // Shuruaat mein health 3 hogi
      position: Vector2(40, 40),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(style: TextStyle(color: BasicPalette.white.color, fontSize: 24)),
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
      
      // Player agar game mein hai to hi health update karo
      if(player.isMounted){
        healthText.text = 'Health: ${player.health}';
      }

      // Agar player mar gaya hai to game over
      if (player.health <= 0 && player.isMounted) {
        player.removeFromParent();
        state = GameState.gameOver;
        showGameOver();
      }
    }
  }

  void showGameOver() {
    // Game over hone par saare dushman aur components hata do
    removeWhere((component) => component is Enemy || component is Joystick);

    // Game Over UI dikhana
    final gameOverText = TextComponent(
      text: 'Game Over',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: BasicPalette.white.color, fontSize: 64)),
    );
    final restartText = TextComponent(
      text: 'Tap to Restart',
      position: size / 2 + Vector2(0, 80),
      anchor: Anchor.center,
      textRenderer: TextPaint(style: TextStyle(color: BasicPalette.white.color, fontSize: 32)),
    );

    add(gameOverText);
    add(restartText);
  }

  void reset() {
    // Saare game over UI aur purane components hata do
    removeWhere((component) => component is TextComponent || component is Player || component is Enemy);
    // Game dobara shuru karo
    startGame();
  }
  
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // Agar game over hai to tap karne par reset karo
    if (state == GameState.gameOver) {
      reset();
    }
  }
}
