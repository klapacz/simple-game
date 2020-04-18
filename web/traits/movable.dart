import 'dart:core';

import '../game.dart';
import '../tiles/tile_map_collider.dart';
import '../vector.dart';
import '../box/box.dart';

enum Directions { Left, Right, Top, Bottom }

mixin Movable on Box {
  var collisionDirections = <Directions>{};
  Vector velocity = Vector.blank();

  void moveAndCheckCollision({TileMapCollider mapCollider}) {
    collisionDirections.clear();

    if (velocity.x != 0) {
      position.x += velocity.x;

      mapCollider.collidingTiles(this).forEach((Box block) {
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

      mapCollider.collidingTiles(this).forEach((Box block) {
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

  void updateMovable(num deltaTime, Game game) {
    velocity *= deltaTime;

    moveAndCheckCollision(mapCollider: game.map.collider);

    velocity = Vector.blank();
  }
}
