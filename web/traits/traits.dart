import 'dart:html';

import '../box/box.dart';
import '../camera.dart';
import '../game.dart';
import 'gravity.dart';
import 'movable.dart';

export 'movable.dart';
export 'jump.dart';
export 'animation.dart';
export 'gravity.dart';

abstract class Physical extends Box
    with Movable, Gravity
    implements Drawable, Updateable {
  Physical(size, position) : super(size, position);
}

abstract class Drawable {
  void draw(CanvasRenderingContext2D context, Camera camera, Game game);
}

abstract class Updateable {
  void update(num deltaTime, Game game);
}
