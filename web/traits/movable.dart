import 'dart:core';

import '../entities/player.dart';
import '../game.dart';
import '../tiles/tile_map_collider.dart';
import '../vector.dart';
import '../box/box.dart';

enum Directions { Left, Right, Top, Bottom }

mixin Movable on Box {
  var collisionDirections = <Directions>{};
  Vector velocity = Vector.blank();
  Vector lastVelocity = Vector.blank();

  void moveAndCheckCollision(game, {TileMapCollider mapCollider}) {
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

      if (this is Player) {
        final ladderLayers = game.map.collider.ladderLayers;

        bool penetration(num biggerThan, List<TileBox> tiles) {
          var tile = tiles[0];
          return tile.left - biggerThan < left &&
              tile.right + biggerThan > right;
        }

        var ladderTiles = mapCollider.collidingTiles(this, ladderLayers);
        final onLadder =
            ladderTiles.isNotEmpty && penetration(width / 2, ladderTiles);

        final goLadderDown = (this as Player).goLadderDown;
        print(goLadderDown);

        if (ladderTiles.length == 1 &&
            onLadder &&
            velocity.y > 0 &&
            (velocity.x == 0 || (this as Player).standingOnLadder) &&
            !goLadderDown) {
          (this as Player).standingOnLadder = true;
          position.y = ladderTiles[0].top - size.y;
        } else {
          (this as Player).standingOnLadder = false;
        }
      }
    }
  }

  void updateMovable(num deltaTime, Game game) {
    velocity *= deltaTime;

    moveAndCheckCollision(game, mapCollider: game.map.collider);

    lastVelocity = velocity.cloned;
    velocity = Vector.blank();
  }
}
