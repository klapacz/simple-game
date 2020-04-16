import 'dart:core';

import '../main.dart';
import '../tiles/tiles.dart';
import '../vector.dart';
import '../box/box.dart';

enum Directions { Left, Right, Top, Bottom }

mixin Movable on Box {
  var collisionDirections = <Directions>{};
  Vector velocity;

  void moveAndCheckCollision({Tiles tiles}) {
    collisionDirections.clear();

    if (velocity.x != 0) {
      position.x += velocity.x;

      tiles.collidingTiles(this).forEach((Box block) {
        if (velocity.x > 0) {
          position.x = block.minX - size.x;
          collisionDirections.add(Directions.Right);
        } else if (velocity.x < 0) {
          position.x = block.maxX;
          collisionDirections.add(Directions.Left);
        }
      });
    }

    if (velocity.y != 0) {
      position.y += velocity.y;

      tiles.collidingTiles(this).forEach((Box block) {
        if (velocity.y > 0) {
          position.y = block.minY - size.y;
          collisionDirections.add(Directions.Bottom);
        } else if (velocity.y < 0) {
          position.y = block.maxY;
          collisionDirections.add(Directions.Top);
        }
      });
    }
  }

  void updateMove(num deltaTime, Game game) {
    velocity *= deltaTime;

    moveAndCheckCollision(tiles: game.tiles);

    velocity = Vector.blank();
  }
}
