import '../box/box.dart';

import '../game.dart';
import '../vector.dart';

import '../traits/traits.dart';

class Player extends ColorBox with Movable, Jump implements Updateable {
  final speed = 100;
  @override
  final defaultJumpTime = 21;
  final gravity = Vector(0, 100);

  Player() : super(Vector(10, 10), Vector(20, 20), 'red');

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

    game.tiles.collidingTiles(this);

    // if (game.tiles.jumpTiles.where((tile) => aabb(this, tile)).isNotEmpty) {
    //   startJump();
    // }
  }
}
