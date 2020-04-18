import 'dart:developer';

import 'package:tiled/tiled.dart';

import 'camera.dart';
import 'keyboard.dart';
import 'tiles/tiles.dart';
import 'timer.dart';
import 'entities/entities.dart';
import 'traits/traits.dart';
import 'traits/movable.dart';
import 'utilities/canvas.dart';
import 'utilities/entities_factory.dart';
import 'vector.dart';

import 'utilities/fetch.dart';

class Game with CanvasUtilities, EntitiesFactory {
  Keyboard keyboard;
  Camera camera;
  TilesMap tilesMap;
  Debugger graphicDebugger;
  Timer timer;

  Map data;

  void setup() async {
    data = await fetchAllAs({
      'sheet': fetchImage('assets/sheet.png'),
      'characters': fetchImage('assets/characters.png'),
      'levelData': fetchJson('assets/level-1.json'),
      // 'levelData': fetchJson('assets/flat.json'),
      'tmxString': fetchString('assets/level-1.tmx'),
      'tsxString': fetchString('assets/forest.tsx'),
    });

    var parser = TileMapParser();
    var map = parser.parse(data['tmxString']);

    for (var layer in map.layers) {
      print(layer);
    }

    setupCanvas('#output', Vector(500, 400));
    keyboard = Keyboard();
    camera = Camera(this);
    tilesMap = TilesMap(data['sheet'], data['levelData']);

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
