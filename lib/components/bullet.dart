import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../game.dart';
import 'enemy.dart';

// HasGameRef ko naye HasGameReference se badal diya gaya hai
class Bullet extends PositionComponent with HasGameReference<ChronoshotGame>, CollisionCallbacks {
  final Vector2 direction;
  final double _speed = 600;
  Bullet({required Vector2 position, required this.direction}) : super(position: position);

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
    // gameRef ko naye 'game' se badal diya gaya hai
    if (position.x < 0 || position.x > game.size.x || position.y < 0 || position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      removeFromParent();
      other.removeFromParent();
      // gameRef ko naye 'game' se badal diya gaya hai
      game.score += 10;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), BasicPalette.green.paint());
  }
}
