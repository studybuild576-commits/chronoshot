import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart'; // Galti 2: Yeh import miss ho gaya tha
import 'package:flutter/material.dart';

// Galti 1: 'package.dart' wala galat import hata diya gaya hai

import '../game.dart';
import 'enemy.dart';

// Goli (Bullet) Component
class Bullet extends PositionComponent with HasGameRef<ChronoshotGame>, CollisionCallbacks {
  final Vector2 direction;
  final double _speed = 600;

  Bullet({required Vector2 position, required this.direction})
      : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(10, 20);
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(direction * _speed * dt);

    if (position.x < 0 || position.x > gameRef.size.x || position.y < 0 || position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      removeFromParent();
      other.removeFromParent();
      gameRef.score += 10; // Score badhao
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), BasicPalette.green.paint());
  }
}
