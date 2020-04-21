import '../entities/entity.dart';
import '../game.dart';
import '../tiles/tile_map_collider.dart';
import '../traits/move.dart';

export 'ladder_collider.dart';
export 'tile_collider.dart';

class Collider {
  Move move;
  BoxEntity entity;
  Type name;

  Collider(this.move, this.entity);

  void onX(Game game, TileMapCollider mapCollider) {}

  void onY(Game game, TileMapCollider mapCollider) {}
  void both(Game game, TileMapCollider mapCollider) {}
}
