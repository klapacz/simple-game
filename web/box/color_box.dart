import 'dart:core';

import '../basic_interfaces.dart';
import 'dart:html';

import '../camera.dart';
import './box.dart';

class ColorBox extends Box implements Drawable {
  String color;
  bool blockCamera;

  ColorBox(position, size, this.color, {this.blockCamera = false})
      : super(position, size);

  @override
  void draw(CanvasRenderingContext2D context, Camera camera) {
    var toDraw = blockCamera ? this : camera.transform(this);

    context
      ..fillStyle = color
      ..fillRect(
          toDraw.position.x, toDraw.position.y, toDraw.size.x, toDraw.size.y);
  }
}
