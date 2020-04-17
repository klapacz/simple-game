import 'dart:html';

import '../traits/traits.dart';
import '../box/box.dart';
import '../camera.dart';
import '../vector.dart';

import 'matrix.dart';
import 'layer.dart';
import 'tile.dart';

export 'tile.dart';

class TileResolver {
  ImageElement sheet;
}

class TilesMap extends Drawable {
  ImageElement sheet;

  CanvasElement tilesImage;
  Box imageBox;
  var layers = <Layer>[];

  Layer get collisionLayer =>
      layers.firstWhere((layer) => layer.name == 'collision');

  var tileSize = 16;
  Vector size;

  TilesMap(this.sheet, Map data) {
    size = Vector(data['width'], data['height']);

    for (var layerData in data['layers']) {
      layers.add(Layer(this, layerData));
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
