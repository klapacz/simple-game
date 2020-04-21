import 'dart:math';

import '../box/tile_box.dart';
import '../game.dart';
import '../tiles/tile_map_collider.dart';
import 'colliders.dart';

class LadderCollider extends Collider {
  bool onLadder = false, standingOnLadder = false, goLadderDown = false;

  LadderCollider(move, entity) : super(move, entity);

  @override
  Type get name => LadderCollider;

  bool calculatePenetration(num biggerThan, List<TileBox> tiles) {
    for (final tile in tiles) {
      if (tile.left - biggerThan < entity.left &&
          tile.right + biggerThan > entity.right) return true;
    }
    return false;
  }

  @override
  void onY(Game game, TileMapCollider mapCollider) {}

  @override
  void both(Game game, TileMapCollider mapCollider) {
    final ladderLayers = game.map.collider.ladderLayers;
    final ladderTiles = mapCollider.collidingTiles(entity, ladderLayers);
    final penetration = calculatePenetration(entity.width / 2, ladderTiles);
    onLadder = ladderTiles.isNotEmpty && penetration;

    if (onLadder &&
        move.by.y > 0 &&
        !goLadderDown &&
        (move.by.x == 0 || standingOnLadder)) {
      standingOnLadder = true;
      final minY = ladderTiles.map((tile) => tile.position.y).reduce(max);
      entity.position.y = minY - entity.size.y;
    } else {
      standingOnLadder = false;
    }
  }
}
