import 'package:tiled/tiled.dart';

import '../vector.dart';
import 'box.dart';

class TileBox extends Box {
  Tile tile;
  Vector tilePostion;

  TileBox(Vector position, Vector size, {this.tile, this.tilePostion})
      : super(position, size);
}
