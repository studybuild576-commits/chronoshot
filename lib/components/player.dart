import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../game.dart';
import 'bullet.dart';
import 'enemy.dart';

// HasGameRef ko naye HasGameReference se badal diya gaya hai
class Player extends PositionComponent with HasGameReference<ChronoshotGame>, CollisionCallbacks {
  final double _speed = 300;
  final Timer _shootCooldown = Timer(0.5);
  int health = 3;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2.all(50.0);
    // gameRef ko naye 'game' se badal diya gaya hai
    position = game.size / 2;
    anchor = Anchor.center;
    add(RectangleHitbox());
    _shootCooldown.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _shootCooldown.update(dt);
    // gameRef ko naye 'game' se badal diya gaya hai
    if (!game.joystick.delta.isZero()) {
      position.add(game.joystick.delta.normalized() * _speed * dt);
      position.clamp(Vector2.zero() + size / 2, game.size - size / 2);
    }
    // gameRef ko naye 'game' se badal diya gaya hai
    if (!game.shootJoystick.delta.isZero() && _shootCooldown.finished) {
      shoot();
      _shootCooldown.start();
    }
  }

  void shoot() {
    // gameRef ko naye 'game' se badal diya gaya hai
    final direction = game.shootJoystick.delta.normalized();
    final bullet = Bullet(
      position: position + direction * 25,
      direction: direction,
    );
    parent?.add(bullet);
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
