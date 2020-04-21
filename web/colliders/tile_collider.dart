import 'package:tiled/tiled.dart';

import '../box/box.dart';
import 'colliders.dart';

enum Directions { Left, Right, Top, Bottom }

class TileCollider extends Collider {
  Set<Directions> collisionDirections = {};

  TileCollider(move, entity) : super(move, entity);

  @override
  Type get name => TileCollider;

  @override
  void onX(game, tiles) {
    collisionDirections.removeAll([Directions.Left, Directions.Right]);

    tiles.forEach((Box block) {
      if (move.by.x > 0) {
        entity.position.x = block.left - entity.size.x;
        collisionDirections.add(Directions.Right);
      } else if (move.by.x < 0) {
        entity.position.x = block.right;
        collisionDirections.add(Directions.Left);
      }
    });
  }

  @override
  void onY(game, tiles) {
    collisionDirections.removeAll([Directions.Top, Directions.Bottom]);

    tiles.forEach((Box block) {
      if (move.by.y > 0) {
        entity.position.y = block.top - entity.size.y;
        collisionDirections.add(Directions.Bottom);
      } else if (move.by.y < 0) {
        entity.position.y = block.bottom;
        collisionDirections.add(Directions.Top);
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
