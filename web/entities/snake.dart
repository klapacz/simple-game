import 'dart:html';

import '../box/box.dart';
import '../camera.dart';
import '../game.dart';
import '../traits/traits.dart';
import '../vector.dart';

class Snake extends Physical with Animation {
  @override
  final animations = {
    'go': [
      Box(Vector(8, 114), Vector(18, 14)),
      Box(Vector(39, 114), Vector(18, 14)),
      Box(Vector(72, 114), Vector(18, 14)),
      Box(Vector(103, 114), Vector(18, 14)),
    ]
  };

  @override
  final currentAnimation = 'go';

  num arenaMin, arenaMax;
  num speed = 50;

  Snake(position, this.arenaMax)
      : arenaMin = position.x,
        super(position, Vector(16, 14));

  @override
  void draw(CanvasRenderingContext2D context, Camera camera, Game game) {
    drawFrame(context, camera, game);
  }

  @override
  void update(num deltaTime, Game game) {
    if (maxX > arenaMax || minX < arenaMin) {
      speed = -speed;
      flipFrame = !flipFrame;
    }

    velocity.x = speed;
  }
}
