import 'package:tiled/tiled.dart';

import '../box/box.dart';
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

  void onX(Game game, List<TileBox> tiles) {}

  void onY(Game game, List<TileBox> tiles) {}
  void both(Game game, List<TileBox> tiles) {}

  bool Function(TileBox) test(Layer layer) {
    return (TileBox tile) => true;
  }
}
