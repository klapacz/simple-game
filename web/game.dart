import 'dart:html';
import 'dart:math';

import 'package:tiled/tiled.dart';

import 'camera.dart';
import 'keyboard.dart';
import 'tiles/tile_map_collider.dart';
import 'tiles/tile_map_illustrator.dart';
import 'timer.dart';
import 'entities/entities.dart';
import 'traits/traits.dart';
import 'traits/movable.dart';
import 'utilities/canvas.dart';
import 'utilities/entities_factory.dart';
import 'vector.dart';

import 'package:path/path.dart' as p;

import 'utilities/fetch.dart';

Vector getTileMapSize(TileMap tileMap) {
  var layers = tileMap.layers;
  var tileSize = Vector(tileMap.tileWidth, tileMap.tileHeight);

  var widths = layers.map((layer) => layer.width);
  var heights = layers.map((layer) => layer.height);

  var mapSize = Vector(widths.reduce(max), heights.reduce(max))
      .multiplyByVector(tileSize);

  return mapSize;
}

class Game with CanvasUtilities, EntitiesFactory {
  Keyboard keyboard;
  Camera camera;
  Debugger graphicDebugger;
  Timer timer;

  TileMapCollider mapCollider;
  TileMapIllustrator mapIllustrator;

  @override
  CanvasRenderingContext2D context;

  Map data;

  void setup() async {
    var tileMapSource = 'assets/level-1.tmx';

    data = await fetchAllAs({
      'characters': fetchImage('assets/characters.png'),
      'tmxString': fetchString(tileMapSource),
    });

    var parser = TileMapParser();
    var map = parser.parse(data['tmxString']);

    for (var value in map.properties.values) {
      print('$value, ${value.runtimeType}');
    }

    Map<dynamic, Future> imagesToFetch = {};

    for (var tileset in map.tilesets) {
      for (var image in tileset.images) {
        var path = p.join(p.dirname(tileMapSource), image.source);

        imagesToFetch[image] = fetchImage(path);
      }
    }

    var images = await fetchAllAs(imagesToFetch);
    mapIllustrator = TileMapIllustrator(map, this, images);

    mapCollider = TileMapCollider(map);

    print(mapCollider.getLayersPart(map.layers, 0, 0, 2, 2));

    setupCanvas('#output', Vector(500, 400));
    keyboard = Keyboard();
    camera = Camera(this);

    setupDebugger();

    setupEntities(this);

    start();
  }

  void setupDebugger() {
    graphicDebugger = Debugger();

    graphicDebugger.game = this;

    graphicDebugger.texts.addAll([
      () => 'simple game (${timer.fps} FPS)',
    ]);
  }

  void update(deltaTime) {
    if (keyboard.isClickedKey('f')) {
      canvas.requestFullscreen();
    }

    for (var i = 1; i < 10; i++) {
      if (keyboard.isClickedKey('$i')) camera.scale = i;
    }

    for (var entity in entities) {
      if (entity is Updateable) {
        entity.update(deltaTime, this);
      }

      if (entity is Animation) entity.updateAnimation(deltaTime, this);
      if (entity is Jump) entity.updateJump(deltaTime, this);
      if (entity is Gravity) entity.updateGravity();
      if (entity is Movable) entity.updateMovable(deltaTime, this);
    }
  }

  void draw() {
    for (var entity in entities) {
      if (entity is Drawable) entity.draw(context, camera, this);
    }
  }

  void start() {
    timer = Timer(update, draw);
  }
}
