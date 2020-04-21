import 'dart:math';

import 'package:tiled/tiled.dart';
import 'package:path/path.dart' as p;

import '../utilities/fetch.dart';
import '../vector.dart';
import 'tile_map_collider.dart';
import 'tile_map_illustrator.dart';

class TileMapProvider {
  static var tileMapSource = 'assets/flat.tmx'; // assets/level-1.tmx

  TileMapIllustrator illustrator;
  TileMapCollider collider;

  TileMap data;
  Map tilesetsImages;

  Vector size;

  TileMapProvider(Map fetched) {
    data = fetched['tileMap'];
    tilesetsImages = fetched['tilesetsImages'];

    _calculateTileMapSize();

    illustrator = TileMapIllustrator(this);
    collider = TileMapCollider(this);
  }

  Vector get tileSize => Vector(data.tileWidth, data.tileHeight);

  void _calculateTileMapSize() {
    var layers = data.layers;
    var tileSize = Vector(data.tileWidth, data.tileHeight);

    var widths = layers.map((layer) => layer.width);
    var heights = layers.map((layer) => layer.height);

    size = Vector(widths.reduce(max), heights.reduce(max))
        .multiplyByVector(tileSize);
  }

  static Future<Map> fetchData() async {
    var tmxString = await fetchString(tileMapSource);
    var fetched = {};

    var parser = TileMapParser();
    var tileMap = parser.parse(tmxString);

    final imagesToFetch = <dynamic, Future>{};

    for (var tileset in tileMap.tilesets) {
      for (var image in tileset.images) {
        var path = p.join(p.dirname(tileMapSource), image.source);

        imagesToFetch[image] = fetchImage(path);
      }
    }

    fetched['tilesetsImages'] = await fetchAllAs(imagesToFetch);
    fetched['tileMap'] = tileMap;

    return fetched;
  }

  static Future<TileMapProvider> provide() async {
    var data = await fetchData();

    return TileMapProvider(data);
  }
}
