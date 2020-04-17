import 'dart:html';

import '../traits/traits.dart';
import '../box/box.dart';
import '../camera.dart';
import '../vector.dart';
import 'matrix.dart';

class Tile extends Box {
  int number, x, y;

  Tile(this.x, this.y, this.number, size)
      : super(Vector(x, y) * size, Vector.same(size));
}

class TileResolver {
  ImageElement sheet;
}

class Layer {
  String name;
  ImageElement sheet;
  Matrix<Tile> tiles;

  CanvasElement tilesImage;
  Box imageBox;

  int tileSize;
  Vector size;

  Layer(this.tileSize, this.sheet, Map layerData) {
    name = layerData['name'];
    size = Vector(layerData['width'], layerData['height']);

    var rawTilesMatrix = Matrix.fromList(layerData['data'], size);

    tiles = Matrix.fromMatrix(rawTilesMatrix, (x, y, number) {
      return number != 0 ? Tile(x, y, number - 1, tileSize) : null;
    });

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

class Tiles extends Drawable {
  ImageElement sheet;

  CanvasElement tilesImage;
  Box imageBox;
  var layers = <Layer>[];

  Layer get collisionLayer =>
      layers.firstWhere((layer) => layer.name == 'collision');

  var tileSize = 16;
  Vector size;

  Tiles(this.sheet, Map data) {
    size = Vector(data['width'], data['height']);

    for (var layerData in data['layers']) {
      layers.add(Layer(tileSize, sheet, layerData));
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

// final tilesMatrix = Matrix([
//   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//   [0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0],
//   [0, 0, 0, 0, 3, 3, 3, 3, 0, 1, 1, 1, 0],
//   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
//   [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
//   [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
//   [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
//   [1, 1, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 1]
// ]);

// final types = {
//   3: {'color': '#fff', 'solid': false},
//   0: {'color': '#D1EEEE', 'solid': false},
//   1: {'color': '#000000', 'solid': true}, // block
//   4: {'color': '#00f', 'solid': true}, // collision
//   5: {'color': '#0f0', 'solid': true} //jump
// };

// class Tile extends Box {
//   Map<String, Object> type;
//   int x, y;

//   Tile(this.x, this.y, int size, this.type)
//       : super(Vector(x * size, y * size), Vector(size, size));
// }

// class Tiles extends Drawable {
//   Matrix<Tile> tiles;
//   Matrix<Tile> solidTiles;

//   CanvasElement tilesImage;
//   Box imageBox;

//   var size = 16;

//   Tiles(Matrix<int> rawTilesMatrix) {
//     tiles = Matrix.fromMatrix(
//         rawTilesMatrix, (x, y, type) => Tile(x, y, size, types[type]));

//     solidTiles = tiles.where((tile) => tile.type['solid']);

//     updateTilesImage();
//   }

//   void updateTilesImage() {
//     imageBox = Box(Vector.blank(), tiles.size * size);
//     tilesImage = CanvasElement(width: imageBox.size.x, height: imageBox.size.y);
//     var context = tilesImage.context2D;

//     tiles.forEach((Tile tile) {
//       context.fillStyle = tile.type['color'];
//       context.fillRect(
//           tile.position.x, tile.position.y, tile.size.x, tile.size.y);
//     });
//   }

//   Matrix<Tile> collidingTiles(Box box) {
//     var minY = (box.minY / size).floor(), maxY = (box.maxY / size).ceil();
//     var minX = (box.minX / size).floor(), maxX = (box.maxX / size).ceil();

//     return solidTiles.getPart(minX, minY, maxX, maxY);
//   }

//   @override
//   void draw(CanvasRenderingContext2D context, Camera camera) {
//     var toDraw = camera.transform(imageBox);

//     context.drawImageScaled(tilesImage, toDraw.position.x, toDraw.position.y,
//         toDraw.size.x, toDraw.size.y);
//   }
// }
