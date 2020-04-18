import 'dart:html';
import 'dart:math';

import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../camera.dart';
import '../game.dart';
import '../traits/traits.dart';
import '../vector.dart';
import 'layer_illustrator.dart';
import 'tile_map_provider.dart';

class TileMapIllustrator implements Drawable {
  TileMap data;
  TileMapProvider map;
  CanvasElement _backgroundImage;
  CanvasElement _foregroundImage;

  Map tilesetsImages;

  Map<Layer, LayerIllustrator> layersIllustrators = {};

  TileMapIllustrator(this.map) {
    tilesetsImages = map.tilesetsImages;
    data = map.data;

    _createLayersIllustrators();

    _backgroundImage = CanvasElement(width: map.size.x, height: map.size.y);
    _foregroundImage = CanvasElement(width: map.size.x, height: map.size.y);
    drawMapImage();
  }

  void _createLayersIllustrators() {
    for (var layer in data.layers) {
      layersIllustrators[layer] = LayerIllustrator(layer, this);
    }
  }

  void drawMapImage() {
    var context = _backgroundImage.context2D;

    for (var layer in layersIllustrators.values) {
      context.drawImage(layer.image, 0, 0);
    }
  }

  @override
  void draw(CanvasRenderingContext2D context, Camera camera, Game game) {
    var toDraw = camera.transform(Box(Vector.blank(), map.size));

    context.drawImageScaled(_backgroundImage, toDraw.position.x,
        toDraw.position.y, toDraw.size.x, toDraw.size.y);
  }
}
