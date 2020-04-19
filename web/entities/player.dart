import '../box/box.dart';

import '../collision.dart';
import '../game.dart';
import '../vector.dart';

import '../traits/traits.dart';

mixin PlayerAnimation on Animation, Movable {
  @override
  final animations = {
    'go': [
      Box(Vector(104, 41), Vector(17, 23)),
      Box(Vector(9, 41), Vector(17, 23)),
      Box(Vector(41, 41), Vector(17, 23)),
      Box(Vector(72, 41), Vector(17, 23)),
    ],
    'stop': [Box(Vector(9, 41), Vector(17, 23))],
    'jump': [Box(Vector(168, 41), Vector(17, 23))],
    'fall': [Box(Vector(200, 41), Vector(17, 23))],
  };

  num lastPositionY = 0;

  @override
  void changeFrame() {
    if (collisionDirections.contains(Directions.Bottom)) {
      currentAnimation = velocity.x == 0 ? 'stop' : 'go';
    } else {
      currentAnimation = position.y < lastPositionY ? 'jump' : 'fall';
    }

    if (velocity.x > 0) flipFrame = false;
    if (velocity.x < 0) flipFrame = true;

    lastPositionY = position.y;
  }
}

class Player extends Physical with Jump, Animation, PlayerAnimation {
  final speed = 100;
  @override
  final defaultJumpTime = 21;

  Player() : super(Vector(10, 10), Vector(15, 23));

  @override
  void update(num deltaTime, Game game) {
    var go = 0;

    final ladderLayers = game.map.collider.ladderLayers;

    final onLadder =
        game.map.collider.collidingTiles(this, ladderLayers).isNotEmpty;

    if (onLadder) {
      var ladderSpeed = 0;

      disabledGravity = true;

      if (game.keyboard.isClickedKey('w')) ladderSpeed = -speed;
      if (game.keyboard.isClickedKey('s')) ladderSpeed = speed;

      velocity.y += ladderSpeed;
    } else if (!isJumping) {
      disabledGravity = false;
    }

    if (game.keyboard.isClickedKey('a')) go = -speed;
    if (game.keyboard.isClickedKey('d')) go = speed;
    if (game.keyboard.isClickedKey(' ')) {
      startJump();
    }

    velocity.x += go;

    // restart game

    var restart = top > game.map.size.y;

    for (var snake in game.snakes) {
      if (aabb(this, snake)) restart = true;
    }

    if (restart) {
      position = Vector.blank();
      stopJump();
    }
  }

  @override
  void draw(context, camera, game) {
    drawFrame(context, camera, game);

    // context
    //   ..fillStyle = '#80008033'
    //   ..fillRect(
    //       toDraw.position.x, toDraw.position.y, toDraw.size.x, toDraw.size.y);
  }
}
