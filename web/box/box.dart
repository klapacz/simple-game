import 'dart:core';

import '../vector.dart';

export 'color_box.dart';

class Box {
  Vector position, size;

  Box(this.position, this.size);

  Box scaled(scale) => Box(position * scale, size * scale);

  Box get rouned => Box(position.rounded, size.rounded);

  Box get cloned => Box(position, size);

  num get minX => position.x;
  num get minY => position.y;
  num get maxX => minX + size.x;
  num get maxY => minY + size.y;

  num get centerX => position.x + size.x / 2;
  num get centerY => position.y + size.y / 2;
}
