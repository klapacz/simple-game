import '../basic_interfaces.dart';
import 'dart:html';

import '../box/box.dart';
import '../camera.dart';
import '../game.dart';
import '../vector.dart';

export 'player.dart';

class Debugger implements Drawable, Updateable {
  final texts = <Function>[];
  Box player;
  var debugBox = Box(Vector.blank(), Vector.blank());
  Game game;

  @override
  void update(num deltaTime, Game game) {}

  @override
  void draw(CanvasRenderingContext2D context, Camera camera) {
    context
      ..font = '30px VT323, monospace'
      ..fillStyle = 'black';

    texts.asMap().forEach((i, text) {
      context.fillText(text(), 10, 40 + 40 * i);
    });
  }
}
