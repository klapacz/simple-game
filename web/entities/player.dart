import '../box/box.dart';

import '../game.dart';
import '../vector.dart';

import '../traits/traits.dart';

class Player extends Box with Movable, Jump implements Updateable, Drawable {
  final speed = 100;
  @override
  final defaultJumpTime = 21;
  final gravity = Vector(0, 100);

  Player() : super(Vector(10, 10), Vector(15, 20));

  @override
  void update(num deltaTime, Game game) {
    var speedX = 0, speedY = 0;

    if (game.keyboard.isClickedKey('a')) speedX = -speed;
    if (game.keyboard.isClickedKey('d')) speedX = speed;

    // if (game.keyboard.isClickedKey('w')) speedY = -speed;
    // if (game.keyboard.isClickedKey('s')) speedY = speed;

    if (game.keyboard.isClickedKey(' ')) {
      startJump();
    } else {
      stopJump();
    }

    velocity += (Vector(speedX, speedY) + gravity); //

    if (minY > 20 * 16) position = Vector.blank();
  }

  @override
  void draw(context, camera) {
    var toDraw = camera.transform(this);

    context
      ..fillStyle = 'purple'
      ..fillRect(
          toDraw.position.x, toDraw.position.y, toDraw.size.x, toDraw.size.y);
  }
}
