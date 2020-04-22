import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../entities/entity.dart';
import '../traits/move.dart';

export 'ladder_collider.dart';
export 'tile_collider.dart';
export 'platform_collider.dart';

class Collider {
  Move move;
  BoxEntity entity;
  Type name;

  Collider(this.move, this.entity);

  void onX(Move move, List<TileBox> tiles) {}

  void onY(Move move, List<TileBox> tiles) {}
  void both(Move move, List<TileBox> tiles) {}

  void nothing(Move move) {}

  bool Function(TileBox) test(Layer layer) {
    return (TileBox tile) => true;
  }
}
