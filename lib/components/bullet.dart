import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../game.dart';
import 'enemy.dart';

class Bullet extends PositionComponent
    with HasGameRef<ChronoshotGame>, CollisionCallbacks {
  final double _speed = 500;

  Bullet({required Vector2 position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2.all(10.0);
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(Vector2(0, -1) * _speed * dt);

    // Remove bullet if out of screen
    if (position.y < 0) {
      removeFromParent();
    }

    // Collision check with enemies
    final enemies = gameRef.children.whereType<Enemy>().toList();
    for (var enemy in enemies) {
      if (enemy.toRect().overlaps(toRect())) {
        enemy.removeFromParent();
        removeFromParent();
        break;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), BasicPalette.yellow.paint());
  }

  Rect toRect() => Rect.fromLTWH(position.x, position.y, size.x, size.y);
}
