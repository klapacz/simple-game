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

enum DrawTypes { Background, Foreground }

class Illustrator extends Drawable {
  TileMapIllustrator tileMapIllustrator;
  DrawTypes drawType;

  Illustrator(
    this.tileMapIllustrator,
    this.drawType,
  );

  @override
  void draw(CanvasRenderingContext2D context, Camera camera, Game game) {
    final toDraw =
        camera.transform(Box(Vector.blank(), tileMapIllustrator.map.size));

    var image;

    if (drawType == DrawTypes.Background) {
      image = tileMapIllustrator.backgroundImage;
    }

    if (drawType == DrawTypes.Foreground) {
      image = tileMapIllustrator.foregroundImage;
    }

    context.drawImageScaled(image, toDraw.position.x, toDraw.position.y,
        toDraw.size.x, toDraw.size.y);
  }
}

class TileMapIllustrator {
  TileMap data;
  TileMapProvider map;
  CanvasElement backgroundImage;
  CanvasElement foregroundImage;

  Map tilesetsImages;

  Map<Layer, LayerIllustrator> layersIllustrators = {};

  TileMapIllustrator(this.map) {
    tilesetsImages = map.tilesetsImages;
    data = map.data;

    _createLayersIllustrators();

    backgroundImage = CanvasElement(width: map.size.x, height: map.size.y);
    foregroundImage = CanvasElement(width: map.size.x, height: map.size.y);
    drawMapImage();
  }

  void _createLayersIllustrators() {
    for (var layer in data.layers) {
      layersIllustrators[layer] = LayerIllustrator(layer, this);
    }
  }

  void updateLayerImage(Layer layer) {
    layersIllustrators[layer]..drawLayerImage();

    drawMapImage();
  }

  void drawMapImage() {
    if (data.properties.containsKey('background')) {
      final backgroundColor = data.properties['background'];
      final mapSize = map.size.multiplyByVector(map.tileSize);

      backgroundImage.context2D
        ..fillStyle = backgroundColor
        ..fillRect(0, 0, mapSize.x, mapSize.y);
    }

    print(data.properties);

    layersIllustrators.forEach((layer, illustrator) {
      var context = backgroundImage.context2D;

      if (layer.properties.containsKey('foreground') &&
          layer.properties['foreground'] == true) {
        context = foregroundImage.context2D;
      }

      context.drawImage(illustrator.image, 0, 0);
    });
  }

  Illustrator get background => Illustrator(this, DrawTypes.Background);
  Illustrator get foreground => Illustrator(this, DrawTypes.Foreground);
}
