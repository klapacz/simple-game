import 'dart:html';

import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../vector.dart';
import 'tile_map_illustrator.dart';

class LayerIllustrator {
  Layer layer;
  TileMapIllustrator tileMapDrawer;
  CanvasElement image;

  LayerIllustrator(this.layer, this.tileMapDrawer) {
    var tileSize = Vector(layer.map.tileWidth, layer.map.tileHeight);
    var imageBox = Box(Vector.blank(), size.multiplyByVector(tileSize));
    image = CanvasElement(width: imageBox.size.x, height: imageBox.size.y);

    drawLayerImage();
  }

  void drawTile(Tile tile, CanvasRenderingContext2D context) {
    var rectangle = tile.computeDrawRect();

    context.drawImageScaledFromSource(
        tileMapDrawer.tilesetsImages[tile.image],
        rectangle.left,
        rectangle.top,
        tile.width,
        tile.height,
        tile.x,
        tile.y,
        rectangle.width,
        rectangle.height);
  }

  void drawLayerImage() {
    var context = image.context2D;
    context.clearRect(0, 0, image.width, image.height);

    for (var tile in layer.tiles) {
      if (!tile.isEmpty) drawTile(tile, context);
    }
  }

  Vector get size => Vector(layer.width, layer.height);
}
