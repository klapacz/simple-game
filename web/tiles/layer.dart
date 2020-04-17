import 'dart:html';

import '../box/box.dart';
import '../vector.dart';

import 'matrix.dart';
import 'layer.dart';
import 'tile.dart';
import 'tiles.dart';

export 'tile.dart';

class Layer {
  String name;
  Matrix<Tile> tiles;

  CanvasElement tilesImage;
  Box imageBox;

  Vector size;

  TilesMap tilesMap;
  ImageElement get sheet => tilesMap.sheet;
  int get tileSize => tilesMap.tileSize;

  final properties = {};

  Layer(this.tilesMap, Map layerData) {
    name = layerData['name'];
    size = Vector(layerData['width'], layerData['height']);

    // create matrix

    var rawTilesMatrix = Matrix.fromList(layerData['data'], size);

    tiles = Matrix.fromMatrix(rawTilesMatrix, (x, y, number) {
      return number != 0 ? Tile(x, y, number - 1, tileSize) : null;
    });

    // set properties
    if (layerData['properties'] != null) {
      for (var property in layerData['properties']) {
        properties[property['name']] = property['value'];
      }

      print(properties);
    }

    updateTilesImage();
  }

  void updateTilesImage() {
    imageBox = Box(Vector.blank(), tiles.size * tileSize);
    tilesImage = CanvasElement(width: imageBox.size.x, height: imageBox.size.y);
    var context = tilesImage.context2D;

    tiles.forEach((Tile tile) {
      var y = (tile.number * tileSize / sheet.width).floor();
      var x = (tile.number * tileSize - sheet.width * y);

      y *= tileSize;

      context.drawImageScaledFromSource(sheet, x, y, tileSize, tileSize,
          tile.minX, tile.minY, tileSize, tileSize);
    });
  }

  Matrix<Tile> collidingTiles(Box box) {
    var minY = (box.minY / tileSize).floor(),
        maxY = (box.maxY / tileSize).ceil();
    var minX = (box.minX / tileSize).floor(),
        maxX = (box.maxX / tileSize).ceil();

    return tiles.getPart(minX, minY, maxX, maxY);
  }
}
