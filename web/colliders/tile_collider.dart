import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../traits/traits.dart';
import 'colliders.dart';

class TileCollider extends Collider {
  TileCollider(move, entity) : super(move, entity);

  @override
  Type get name => TileCollider;

  @override
  void onX(Move move, tiles) {
    tiles.forEach((Box block) {
      if (move.by.x > 0) {
        entity.position.x = block.left - entity.size.x;
        move.collisionDirections.add(Directions.Right);
      } else if (move.by.x < 0) {
        entity.position.x = block.right;
        move.collisionDirections.add(Directions.Left);
      }
    });
  }

  @override
  void onY(Move move, tiles) {
    tiles.forEach((Box block) {
      if (move.by.y > 0) {
        entity.position.y = block.top - entity.size.y;
        move.collisionDirections.add(Directions.Bottom);
      } else if (move.by.y < 0) {
        entity.position.y = block.bottom;
        move.collisionDirections.add(Directions.Top);
      }
    });
  }

  @override
  bool Function(TileBox) test(Layer layer) {
    return (TileBox box) =>
        layer.properties['platform'] != true &&
        box.tile.properties['collision'] != null &&
        box.tile.properties['collision'] == true;
  }
}
