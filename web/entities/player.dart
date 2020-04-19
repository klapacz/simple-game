import 'dart:html';

import '../box/box.dart';

import '../collision.dart';
import '../game.dart';
import '../vector.dart';

import '../traits/traits.dart';

mixin PlayerAnimation on Animation, Movable, Jump {
  bool onLadder;

  @override
  final animations = {
    'go': [
      Rectangle(104, 41, 17, 23),
      Rectangle(9, 41, 17, 23),
      Rectangle(41, 41, 17, 23),
      Rectangle(72, 41, 17, 23),
    ],
    'stop': [Rectangle(9, 41, 17, 23)],
    'jump': [Rectangle(168, 41, 17, 23)],
    'fall': [Rectangle(200, 41, 17, 23)],
    'stop-on-ladder': [Rectangle(583, 41, 17, 23)],
    'climbing': [
      Rectangle(583, 41, 17, 23),
      Rectangle(616, 41, 17, 23),
      Rectangle(647, 41, 17, 23),
      Rectangle(680, 41, 17, 23),
    ]
  };

  num lastPositionY = 0;

  @override
  void changeFrame() {
    if (collisionDirections.contains(Directions.Bottom)) {
      currentAnimation = velocity.x == 0 ? 'stop' : 'go';
    } else if (onLadder) {
      currentAnimation = 'stop-on-ladder';

      if (velocity.y != 0) currentAnimation = 'climbing';
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

  bool onLadder = false;

  @override
  void update(num deltaTime, Game game) {
    var go = 0;

    final ladderLayers = game.map.collider.ladderLayers;

    bool penetration(num biggerThan, List<TileBox> tiles) {
      var tile = tiles[0];
      return tile.left - biggerThan < left && tile.right + biggerThan > right;
    }

    var ladderTiles = game.map.collider.collidingTiles(this, ladderLayers);
    onLadder = ladderTiles.isNotEmpty && penetration(width / 2, ladderTiles);

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
    } else if (!onLadder) {
      stopJump();
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
