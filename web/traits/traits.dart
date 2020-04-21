import 'dart:html';

import '../camera.dart';
import '../entities/entity.dart';
import '../game.dart';

export 'move.dart';
export 'jump.dart';
export 'animation.dart';
export 'gravity.dart';

// abstract class Physical extends Box
//     with Movable, Gravity
//     implements Drawable, Updateable {
//   Physical(size, position) : super(size, position);
// }

abstract class Drawable {
  void draw(CanvasRenderingContext2D context, Camera camera, Game game);
}

abstract class Updateable {
  void update(num deltaTime, Game game);
}

abstract class Illustrator implements Drawable {
  Entity entity;
}

abstract class Trait implements Updateable {
  Type get name;

  @override
  void update(num deltaTime, Game game) {}
}
