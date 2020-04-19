import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../vector.dart';
import 'tile_map_provider.dart';

class TileMapCollider {
  TileMap data;
  Map<Layer, List<List<Box>>> tilesAsBoxes = {};

  TileMapCollider(TileMapProvider mapProvider) {
    data = mapProvider.data;

    for (var layer in data.layers) {
      tilesAsBoxes[layer] = [
        for (var i = 0; i < layer.height; i++) List(layer.width)
      ];
    }
  }

  List<Layer> get collisionLayers =>
      [data.layers.firstWhere((layer) => layer.name == 'collision')];

  List<TileBox> collidingTiles(Box box, [List<Layer> layers]) {
    layers ??= collisionLayers;

    var minY = (box.top / data.tileHeight).floor(),
        maxY = (box.bottom / data.tileHeight).ceil();
    var minX = (box.left / data.tileWidth).floor(),
        maxX = (box.right / data.tileWidth).ceil();

    return getLayersPart(layers, minX, minY, maxX, maxY);
  }

  List<TileBox> getLayersPart(
      List<Layer> layers, int minX, int minY, int maxX, int maxY) {
    var result = <TileBox>[];

    for (var layer in layers) {
      for (var y = minY; y < maxY; y++) {
        if (y >= 0 && y < layer.height) {
          for (var x = minX; x < maxX; x++) {
            if (x >= 0 && x < layer.width && layer.tileMatrix[y][x] != 0) {
              result.add(getTileAsBox(layer, x, y));
            }
          }
        }
      }
    }

    return result;
  }

  Box getTileAsBox(Layer layer, int x, int y) {
    return tilesAsBoxes[layer][y][x] ??= TileBox(
      Vector(x * data.tileWidth, y * data.tileHeight),
      Vector(data.tileWidth, data.tileHeight),
      layer: layer,
      tilePostion: Vector(x, y),
    );
  }
}
