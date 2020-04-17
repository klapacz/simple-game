import 'dart:html';
import 'camera.dart';
import 'keyboard.dart';
import 'tiles/tiles.dart';
import 'timer.dart';
import 'entities/entities.dart';
import 'traits/traits.dart';
import 'traits/movable.dart';
import 'vector.dart';

class Game {
  Keyboard keyboard;
  Camera camera;
  TilesMap tilesMap;
  Debugger debugger;
  Timer timer;

  List entities = [];

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  Vector canvasSize;

  void updateCanvasSizeAndSetContext(Vector newCanvasSize) {
    canvasSize = newCanvasSize;

    canvas.width = canvasSize.x;
    canvas.height = canvasSize.y;

    context = canvas.context2D;
    context.imageSmoothingEnabled = false;
  }

  Game(canvasSelector, scheet, data) {
    setupCanvas(canvasSelector, Vector(500, 400));
    keyboard = Keyboard();
    camera = Camera(this);
    tilesMap = TilesMap(scheet, data);

    setupDebugger();
  }

  void setupCanvas(canvasSelector, Vector defaultSize) {
    canvas = querySelector(canvasSelector);

    canvas.onFullscreenChange.listen((event) {
      if (document.fullscreenElement == canvas) {
        updateCanvasSizeAndSetContext(
            Vector(document.body.clientWidth, document.body.clientHeight));
      } else {
        updateCanvasSizeAndSetContext(defaultSize);
      }
    });

    updateCanvasSizeAndSetContext(defaultSize);
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

      if (keyboard.isClickedKey('f')) {
        canvas.requestFullscreen();
      }

      entities.forEach((entity) {
        if (entity is Drawable) entity.draw(context, camera);

        if (entity is Updateable) {
          entity.update(deltaTime, this);
        }

        if (entity is Jump) entity.updateJump(deltaTime, this);

        if (entity is Movable) entity.updateMove(deltaTime, this);
      });
    });
  }
}
