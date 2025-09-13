import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../game.dart';

// Dushman Component
class Enemy extends PositionComponent with HasGameRef<ChronoshotGame>, CollisionCallbacks {
  final double _speed = 150; // Dushman ki speed

  Enemy({required Vector2 position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2.all(40.0);
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Player ki taraf badhne ka logic
    if (gameRef.player.isMounted) {
      final direction = (gameRef.player.position - position).normalized();
      position.add(direction * _speed * dt);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), BasicPalette.red.paint());
  }
}
