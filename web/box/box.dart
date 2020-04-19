import 'dart:core';
import 'dart:html';

import '../vector.dart';

export 'color_box.dart';

class Box extends Rectangle {
  Vector position, size;

  Box(this.position, this.size) : super(position.x, position.y, size.x, size.y);

  Box scaled(scale) => Box(position * scale, size * scale);

  Box get rouned => Box(position.rounded, size.rounded);

  Box get cloned => Box(position, size);

  @override
  num get left => position.x;
  @override
  num get top => position.y;
  @override
  num get right => left + size.x;
  @override
  num get bottom => top + size.y;

  num get centerX => position.x + size.x / 2;
  num get centerY => position.y + size.y / 2;

  @override
  String toString() => 'Boxed ${super.toString()}';
}
