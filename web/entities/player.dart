import '../box/box.dart';
import '../basic_interfaces.dart';

import '../main.dart';
import '../vector.dart';

import '../traits/movable.dart';

mixin Jump on Movable {
  bool isJumping = false;
  final defaultJumpTime = 0;
  int jumpTime = 0;
  int onFloorTime = 0;
  var defaultJumpSpeed = Vector(0, -400);

  Vector get jump => isJumping ? defaultJumpSpeed : Vector(0, 0);

  void startJump() {
    if (isJumping == false && onFloorTime > 5) isJumping = true;
  }

  void stopJump() {
    isJumping = false;
    jumpTime = defaultJumpTime;
  }

  void updateJump() {
    if (isJumping == true) {
      jumpTime--;
    }

    if (collisionDirections.contains(Directions.Bottom)) {
      onFloorTime++;
    } else {
      onFloorTime = 0;
    }

    if (jumpTime <= 0 || collisionDirections.contains(Directions.Top)) {
      stopJump();
    }
  }
}

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

    updateJump();

    velocity = (Vector(speedX, speedY) + jump + gravity); //

    game.tiles.collidingTiles(this);

    // if (game.tiles.jumpTiles.where((tile) => aabb(this, tile)).isNotEmpty) {
    //   startJump();
    // }
  }
}
