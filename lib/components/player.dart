import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../game.dart';
import 'bullet.dart';
import 'enemy.dart';

class Player extends PositionComponent with HasGameReference<ChronoshotGame>, CollisionCallbacks {
  final double _speed = 300;
  final Timer _shootCooldown = Timer(0.5);
  int health = 3;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2.all(50.0);
    position = gameRef.size / 2;
    anchor = Anchor.center;
    add(RectangleHitbox());
    _shootCooldown.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _shootCooldown.update(dt);

    // Movement
    if (!gameRef.joystick.delta.isZero()) {
      position.add(gameRef.joystick.delta.normalized() * _speed * dt);
      position.clamp(Vector2.zero() + size / 2, gameRef.size - size / 2);
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
    gameRef.add(bullet); // Ensures bullet is added to game root
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      health--;
      other.removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), BasicPalette.white.paint());
  }
}
