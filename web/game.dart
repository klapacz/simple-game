import 'dart:convert';
import 'dart:html';
import 'box/box.dart';
import 'camera.dart';
import 'keyboard.dart';
import 'tiles/matrix.dart';
import 'tiles/tiles.dart';
import 'timer.dart';
import 'entities/entities.dart';
import 'traits/traits.dart';
import 'traits/movable.dart';
import 'vector.dart';

class Game {
  Keyboard keyboard;
  Camera camera;
  Tiles tiles;
  Debugger debugger;
  Timer timer;

  List entities = [];

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  Vector canvasSize = Vector(500, 400);

  Game(canvasSelector, scheet, data) {
    setupCanvas(canvasSelector);
    keyboard = Keyboard();
    camera = Camera(canvasSize, 2);
    tiles = Tiles(scheet, data);

    setupDebugger();
  }

  void setupCanvas(canvasSelector) {
    canvas = querySelector(canvasSelector);

    canvas
      ..width = canvasSize.x
      ..height = canvasSize.y;

    context = canvas.context2D;
    context.imageSmoothingEnabled = false;
  }

  void setupDebugger() {
    debugger = Debugger();

    debugger.game = this;

    debugger.texts.addAll([
      () => 'simple game (${timer.fps} FPS)',
    ]);
  }

  void start(Function(num, Game) globalUpdate) {
    timer = Timer((deltaTime) {
      globalUpdate(deltaTime, this);

      entities.forEach((entity) {
        if (entity is Drawable) entity.draw(context, camera);
        if (entity is Updateable) {
          entity.update(deltaTime, this);
        }

        if (entity is Movable) entity.updateMove(deltaTime, this);
      });
    });
  }
}
