import 'package:tiled/tiled.dart';

import '../box/box.dart';
import '../vector.dart';
import 'tile_map_provider.dart';

class TileMapCollider {
  TileMap data;
  TileMapProvider map;
  Map<Layer, List<List<Box>>> tilesAsBoxes = {};

  TileMapCollider(this.map) {
    data = map.data;

    for (var layer in data.layers) {
      tilesAsBoxes[layer] = [
        for (var i = 0; i < layer.height; i++) List(layer.width)
      ];
    }
  }

  // List<Layer> get collisionLayers => data.layers
  //     .where((layer) =>
  //         layer.properties.containsKey('collision') &&
  //         layer.properties['collision'] == true)
  //     .toList();

  // List<Layer> get ladderLayers => data.layers
  //     .where((layer) =>
  //         layer.properties.containsKey('ladder') &&
  //         layer.properties['ladder'] == true)
  //     .toList();

  Map<Layer, List<TileBox>> collidingTiles(Box box, [List<Layer> layers]) {
    layers ??= data.layers;

    var minY = (box.top / data.tileHeight).floor(),
        maxY = (box.bottom / data.tileHeight).ceil();
    var minX = (box.left / data.tileWidth).floor(),
        maxX = (box.right / data.tileWidth).ceil();

    return getLayersPart(layers, minX, minY, maxX, maxY);
  }

  Map<Layer, List<TileBox>> getLayersPart(
    List<Layer> layers,
    int minX,
    int minY,
    int maxX,
    int maxY,
  ) {
    var result = <Layer, List<TileBox>>{};

    for (var layer in layers) {
      for (var y = minY; y < maxY; y++) {
        if (y >= 0 && y < layer.height) {
          result[layer] = [];

          for (var x = minX; x < maxX; x++) {
            if (x >= 0 && x < layer.width && layer.tileMatrix[y][x] != 0) {
              final gid = layer.tileMatrix[y][x];

              result[layer].add(
                getTileAsBox(layer, gid, x, y),
              );
            }
          }
        }
      }
    }

    return result;
  }

  Box getTileAsBox(Layer layer, int gid, int x, int y) {
    if (tilesAsBoxes[layer][y][x] == null) {
      final tile = data.getTileByGID(gid);
      final size = map.tileSize;
      final tilePosition = Vector(x, y);
      final position = tilePosition.multiplyByVector(size);

      tilesAsBoxes[layer][y][x] = TileBox(
        position,
        size,
        tilePostion: tilePosition,
        tile: tile,
      );
    }

    return tilesAsBoxes[layer][y][x];
  }
}
