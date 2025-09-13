import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../game.dart';

// HasGameRef ko naye HasGameReference se badal diya gaya hai
class Joystick extends Component with DragCallbacks, HasGameReference<ChronoshotGame> {
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
    super.onLoad();
    // gameRef ki jagah 'game' ka istemal
    _backgroundCenter = Vector2(
      margin.left + backgroundRadius,
      game.size.y - margin.bottom - backgroundRadius,
    );
    if (margin.right != 0.0) {
      _backgroundCenter.x = game.size.x - margin.right - backgroundRadius;
    }

    _backgroundRect = Rect.fromCircle(
      center: _backgroundCenter.toOffset(),
      radius: backgroundRadius,
    );
    _knobPosition = _backgroundCenter;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(_backgroundCenter.toOffset(), backgroundRadius, backgroundPaint);
    canvas.drawCircle(_knobPosition.toOffset(), knobRadius, knobPaint);
  }

  // DragStartInfo ko sahi DragStartEvent se badal diya gaya hai
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event); // @mustCallSuper warning theek ki gayi
    if (_backgroundRect.contains(event.localPosition.toOffset())) {
      _isDragging = true;
    }
  }

  // DragUpdateInfo ko sahi DragUpdateEvent se badal diya gaya hai
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event); // @mustCallSuper warning theek ki gayi
    if (_isDragging) {
      // eventPosition.game ko sahi event.localPosition se badal diya gaya hai
      _knobPosition = event.localPosition;
      delta = _knobPosition - _backgroundCenter;
      delta.clampLength(0, backgroundRadius);
      _knobPosition = _backgroundCenter + delta;
    }
  }

  // DragEndInfo ko sahi DragEndEvent se badal diya gaya hai
  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event); // @mustCallSuper warning theek ki gayi
    _isDragging = false;
    _knobPosition = _backgroundCenter;
    delta = Vector2.zero();
  }
}
