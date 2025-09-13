import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../game.dart';
import 'bullet.dart';

// Player Component
class Player extends PositionComponent with HasGameRef<ChronoshotGame>, CollisionCallbacks {
  final double _speed = 300;
  final Timer _shootCooldown = Timer(0.5); // Har 0.5 second mein ek goli.

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2.all(50.0);
    position = gameRef.size / 2;
    anchor = Anchor.center;
    add(RectangleHitbox()); // Takkar ke liye hitbox.
    _shootCooldown.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _shootCooldown.update(dt);

    // Movement
    if (!gameRef.joystick.delta.isZero()) {
      position.add(gameRef.joystick.delta.normalized() * _speed * dt);
    }

    // Shooting
    if (!gameRef.shootJoystick.delta.isZero() && _shootCooldown.finished) {
      shoot();
      _shootCooldown.start();
    }
  }

  void shoot() {
    final direction = gameRef.shootJoystick.delta.normalized();
    final bullet = Bullet(
      position: position + direction * 25,
      direction: direction,
    );
    parent?.add(bullet);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), BasicPalette.white.paint());
  }
}
