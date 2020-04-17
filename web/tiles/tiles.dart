import 'dart:html';

import '../traits/traits.dart';
import '../box/box.dart';
import '../camera.dart';
import '../vector.dart';

import 'matrix.dart';
import 'layer.dart';
import 'tile.dart';

export 'tile.dart';

class TileResolver {
  ImageElement sheet;
}

class TilesMap extends Drawable {
  ImageElement sheet;

  CanvasElement tilesImage;
  Box imageBox;
  var layers = <Layer>[];

  Layer get collisionLayer =>
      layers.firstWhere((layer) => layer.name == 'collision');

  var tileSize = 16;
  Vector size;

  TilesMap(this.sheet, Map data) {
    size = Vector(data['width'], data['height']);

    for (var layerData in data['layers']) {
      layers.add(Layer(this, layerData));
    }
  }

  Matrix<Tile> collidingTiles(Box box) {
    return collisionLayer.collidingTiles(box);
  }

  @override
  void draw(CanvasRenderingContext2D context, Camera camera) {
    for (var layer in layers) {
      var toDraw = camera.transform(layer.imageBox);

      context.drawImageScaled(layer.tilesImage, toDraw.position.x,
          toDraw.position.y, toDraw.size.x, toDraw.size.y);
    }
  }
}
