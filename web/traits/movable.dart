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
          position.x = block.left - size.x;
          collisionDirections.add(Directions.Right);
        } else if (velocity.x < 0) {
          position.x = block.right;
          collisionDirections.add(Directions.Left);
        }
      });
    }

    if (velocity.y != 0) {
      position.y += velocity.y;

      mapCollider.collidingTiles(this).forEach((Box block) {
        if (velocity.y > 0) {
          position.y = block.top - size.y;
          collisionDirections.add(Directions.Bottom);
        } else if (velocity.y < 0) {
          position.y = block.bottom;
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
