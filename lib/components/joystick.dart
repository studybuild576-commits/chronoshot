import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Joystick extends Component with DragCallbacks, HasGameRef {
  final Paint backgroundPaint;
  final Paint knobPaint;
  final double knobRadius;
  final double backgroundRadius;
  final EdgeInsets margin;

  late Rect _backgroundRect;
  late Vector2 _backgroundCenter;
  late Vector2 _knobPosition;

  bool _isDragging = false;
  Vector2 delta = Vector2.zero();

  Joystick({
    required Component knob,
    required Component background,
    this.margin = const EdgeInsets.only(left: 40, bottom: 40),
  })  : knobPaint = (knob as ShapeComponent).paint,
        backgroundPaint = (background as ShapeComponent).paint,
        knobRadius = (knob as CircleComponent).radius,
        backgroundRadius = (background as CircleComponent).radius;

  @override
  Future<void> onLoad() async {
    _backgroundCenter = Vector2(
      margin.left + backgroundRadius,
      gameRef.size.y - margin.bottom - backgroundRadius,
    );
    if (margin.right != 0.0) {
      _backgroundCenter.x = gameRef.size.x - margin.right - backgroundRadius;
    }

    _backgroundRect = Rect.fromCircle(
      center: _backgroundCenter.toOffset(),
      radius: backgroundRadius,
    );
    _knobPosition = _backgroundCenter;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(_backgroundCenter.toOffset(), backgroundRadius, backgroundPaint);
    canvas.drawCircle(_knobPosition.toOffset(), knobRadius, knobPaint);
  }

  @override
  void onDragStart(DragStartInfo info) {
    if (_backgroundRect.contains(info.eventPosition.game.toOffset())) {
      _isDragging = true;
    }
  }

  @override
  void onDragUpdate(DragUpdateInfo info) {
    if (_isDragging) {
      _knobPosition = info.eventPosition.game;
      delta = _knobPosition - _backgroundCenter;
      delta.clampLength(0, backgroundRadius);
      _knobPosition = _backgroundCenter + delta;
    }
  }

  @override
  void onDragEnd(DragEndInfo info) {
    _isDragging = false;
    _knobPosition = _backgroundCenter;
    delta = Vector2.zero();
  }
}
