import 'package:tiled/tiled.dart';

import '../vector.dart';
import 'box.dart';

class TileBox extends Box {
  Layer layer;
  Vector tilePostion;

  TileBox(Vector position, Vector size, {this.layer, this.tilePostion})
      : super(position, size);
}
