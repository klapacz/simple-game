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

    if (game.keyboard.isClickedKey('a')) go = -speed;
    if (game.keyboard.isClickedKey('d')) go = speed;
    if (game.keyboard.isClickedKey(' ')) {
      startJump();
    } else {
      stopJump();
    }

    velocity.x += go;

    // restart game

    var restart = minY > game.mapIllustrator.size.y;

    for (var snake in game.snakes) {
      if (aabb(this, snake)) restart = true;
    }

    if (restart) {
      position = Vector.blank();
      stopJump();
    }

    // remove flowers lol
    // var flowersLayer =
    //     game.tilesMap.layers.firstWhere((layer) => layer.name == 'flowers');

    // game.tilesMap.collidingTiles(this, [flowersLayer]).forEach((tile) {
    //   flowersLayer.tiles[tile.y][tile.x] = null;

    //   flowersLayer.updateTilesImage();
    // });
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
