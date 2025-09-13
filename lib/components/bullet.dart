import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

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

    // Agar goli screen se bahar chali jaye to use hata do.
    if (position.x < 0 || position.x > gameRef.size.x || position.y < 0 || position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // Agar goli dushman se takraye to dono ko hata do.
    if (other is Enemy) {
      removeFromParent();
      other.removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), BasicPalette.green.paint());
  }
}
