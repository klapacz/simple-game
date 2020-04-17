import 'dart:html';

import '../camera.dart';
import '../game.dart';

export 'movable.dart';
export 'jump.dart';
export 'animation.dart';

abstract class Drawable {
  void draw(CanvasRenderingContext2D context, Camera camera, Game game);
}

abstract class Updateable {
  void update(num deltaTime, Game game);
}
