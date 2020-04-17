import 'dart:html';

import '../game.dart';
import '../traits/traits.dart';
import '../box/box.dart';
import '../camera.dart';
import '../vector.dart';

import 'matrix.dart';
import 'layer.dart';
import 'tile.dart';

export 'tile.dart';

class TilesMap extends Drawable {
  ImageElement sheet;

  CanvasElement tilesImage;
  Box imageBox;
  var layers = <Layer>[];

  Layer get collisionLayer =>
      layers.firstWhere((layer) => layer.name == 'collision');

  List<Layer> get collisionLayers =>
      layers.where((layer) => layer.properties['collision'] == true).toList();

  var tileSize = 16;
  Vector size;

  TilesMap(this.sheet, Map data) {
    size = Vector(data['width'], data['height']);

    for (var layerData in data['layers']) {
      if (layerData['type'] == 'tilelayer') layers.add(Layer(this, layerData));
    }

    print(collisionLayers);
  }

  List<Tile> collidingTiles(Box box, [List<Layer> layers]) {
    layers ??= collisionLayers;

    var minY = (box.minY / tileSize).floor(),
        maxY = (box.maxY / tileSize).ceil();
    var minX = (box.minX / tileSize).floor(),
        maxX = (box.maxX / tileSize).ceil();

    return layers
        .map((layer) => layer.tiles.getPart(minX, minY, maxX, maxY).toList())
        .expand((i) => i)
        //
        .toList();
  }

  @override
  void draw(CanvasRenderingContext2D context, Camera camera, Game game) {
    for (var layer in layers) {
      var toDraw = camera.transform(layer.imageBox);

      context.drawImageScaled(layer.tilesImage, toDraw.position.x,
          toDraw.position.y, toDraw.size.x, toDraw.size.y);
    }
  }
}
