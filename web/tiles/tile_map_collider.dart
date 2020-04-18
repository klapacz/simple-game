import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../vector.dart';

class TileMapCollider {
  TileMap map;
  Map<Layer, List<List<Box>>> tilesAsBoxes = {};

  List<Layer> get collisionLayers =>
      [map.layers.firstWhere((layer) => layer.name == 'collision')];

  TileMapCollider(this.map) {
    for (var layer in map.layers) {
      tilesAsBoxes[layer] = [
        for (var i = 0; i < layer.height; i++) List(layer.width)
      ];
    }
  }

  List<Box> collidingTiles(Box box, [List<Layer> layers]) {
    layers ??= collisionLayers;

    var minY = (box.minY / map.tileHeight).floor(),
        maxY = (box.maxY / map.tileHeight).ceil();
    var minX = (box.minX / map.tileWidth).floor(),
        maxX = (box.maxX / map.tileWidth).ceil();

    return getLayersPart(layers, minX, minY, maxX, maxY);
  }

  List<Box> getLayersPart(
      List<Layer> layers, int minX, int minY, int maxX, int maxY) {
    var result = <Box>[];
    var debug = [];

    for (var layer in layers) {
      for (var y = minY; y < maxY; y++) {
        if (y >= 0 && y < layer.height) {
          for (var x = minX; x < maxX; x++) {
            if (x >= 0 && x < layer.width && layer.tileMatrix[y][x] != 0) {
              result.add(getTileAsBox(layer, x, y));
              debug.add(layer.tileMatrix[y][x]);
            }
          }
        }
      }
    }

    return result;
  }

  Box getTileAsBox(Layer layer, int x, int y) {
    return tilesAsBoxes[layer][y][x] ??= Box(
        Vector(x * map.tileWidth, y * map.tileHeight),
        Vector(map.tileWidth, map.tileHeight));
  }
}
