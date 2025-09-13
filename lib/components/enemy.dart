import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

// Dushman Component
class Enemy extends PositionComponent with CollisionCallbacks {
  Enemy({required Vector2 position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2.all(40.0);
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), BasicPalette.red.paint());
  }
}
