import '../box/box.dart';
import 'colliders.dart';

enum Directions { Left, Right, Top, Bottom }

class TileCollider extends Collider {
  Set<Directions> collisionDirections = {};

  TileCollider(move, entity) : super(move, entity);

  @override
  Type get name => TileCollider;

  @override
  void onX(game, mapCollider) {
    collisionDirections.removeAll([Directions.Left, Directions.Right]);

    mapCollider.collidingTiles(entity).forEach((Box block) {
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
  void onY(game, mapCollider) {
    collisionDirections.removeAll([Directions.Top, Directions.Bottom]);

    mapCollider.collidingTiles(entity).forEach((Box block) {
      if (move.by.y > 0) {
        entity.position.y = block.top - entity.size.y;
        collisionDirections.add(Directions.Bottom);
      } else if (move.by.y < 0) {
        entity.position.y = block.bottom;
        collisionDirections.add(Directions.Top);
      }
    });
  }
}
