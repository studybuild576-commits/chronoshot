import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class Joystick extends Component with DragCallbacks, HasGameReference {
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
    required CircleComponent knob,
    required CircleComponent background,
    this.margin = const EdgeInsets.only(left: 40, bottom: 40),
  })  : knobPaint = knob.paint,
        backgroundPaint = background.paint,
        knobRadius = knob.radius,
        backgroundRadius = background.radius;

  @override
  Future<void> onLoad() async {
    final gameSize = gameRef.size;

    _backgroundCenter = Vector2(
      margin.left + backgroundRadius,
      gameSize.y - margin.bottom - backgroundRadius,
    );

    if (margin.right != 0.0) {
      _backgroundCenter.x = gameSize.x - margin.right - backgroundRadius;
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
  void onDragStart(DragStartEvent event) {
    final local = event.localPosition.toOffset();
    if (_backgroundRect.contains(local)) {
      _isDragging = true;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_isDragging) {
      final local = event.localPosition;
      delta = local - _backgroundCenter;
      delta.clampLength(0, backgroundRadius);
      _knobPosition = _backgroundCenter + delta;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _isDragging = false;
    _knobPosition = _backgroundCenter;
    delta = Vector2.zero();
  }
}
