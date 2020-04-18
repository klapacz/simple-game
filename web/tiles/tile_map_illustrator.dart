import 'dart:html';
import 'dart:math';

import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../camera.dart';
import '../game.dart';
import '../traits/traits.dart';
import '../vector.dart';
import 'layer_illustrator.dart';

class TileMapIllustrator implements Drawable {
  TileMap map;
  Game game;
  CanvasElement _image;
  Vector size;

  Map tilesetsImages;

  Map<Layer, LayerIllustrator> layersIllustrators = {};

  TileMapIllustrator(this.map, this.game, this.tilesetsImages) {
    _calculateTileMapSize();
    _createLayersIllustrators();

    _image = CanvasElement(width: size.x, height: size.y);
    drawMapImage();
  }

  void _createLayersIllustrators() {
    for (var layer in map.layers) {
      layersIllustrators[layer] = LayerIllustrator(layer, this);
    }
  }

  void _calculateTileMapSize() {
    var layers = map.layers;
    var tileSize = Vector(map.tileWidth, map.tileHeight);

    var widths = layers.map((layer) => layer.width);
    var heights = layers.map((layer) => layer.height);

    size = Vector(widths.reduce(max), heights.reduce(max))
        .multiplyByVector(tileSize);
  }

  void drawMapImage() {
    var context = _image.context2D;

    for (var layer in layersIllustrators.values) {
      context.drawImage(layer.image, 0, 0);
    }
  }

  @override
  void draw(CanvasRenderingContext2D context, Camera camera, Game game) {
    var toDraw = camera.transform(Box(Vector.blank(), size));

    context.drawImageScaled(_image, toDraw.position.x, toDraw.position.y,
        toDraw.size.x, toDraw.size.y);
  }
}
