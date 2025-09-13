import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Joystick extends JoystickComponent {
  Joystick({
    required Paint knobColor,
    required Paint backgroundColor,
    required EdgeInsets margin,
  }) : super(
          knob: CircleComponent(radius: 30, paint: knobColor),
          background: CircleComponent(radius: 80, paint: backgroundColor),
          margin: margin,
        );
}
