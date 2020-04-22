import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../traits/traits.dart';
import 'colliders.dart';

class PlatformCollider extends Collider {
  bool goDown = false;

  PlatformCollider(move, entity) : super(move, entity);

  @override
  Type get name => PlatformCollider;

  @override
  void onY(Move move, tiles) {
    tiles.forEach((Box block) {
      if (move.by.y > 0 && goDown == false) {
        entity.position.y = block.top - entity.size.y;
        move.collisionDirections.addAll([
          Directions.Bottom,
          Directions.Platform,
        ]);
      }
    });
  }

  @override
  void nothing(Move move) {
    goDown = false;
  }

  @override
  bool Function(TileBox) test(Layer layer) {
    return (TileBox box) =>
        layer.properties['platform'] == true &&
        box.tile.properties['platform'] != null &&
        box.tile.properties['platform'] == true;
  }
}
