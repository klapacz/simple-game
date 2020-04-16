import 'dart:convert';
import 'dart:html';
import 'box/box.dart';
import 'camera.dart';
import 'keyboard.dart';
import 'tiles/matrix.dart';
import 'tiles/tiles.dart';
import 'timer.dart';
import 'entities/entities.dart';
import 'basic_interfaces.dart';
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

Future<ImageElement> fetchImage(url) async {
  final request = await HttpRequest.request(url, responseType: 'blob');
  final image = ImageElement(src: Url.createObjectUrl(request.response));

  await image.onLoad.first;

  return image;
}

Future<Map> fetchJson(url) async {
  final jsonString = await HttpRequest.getString(url);
  final jsonData = json.decode(jsonString) as Map;

  return jsonData;
}

void main() async {
  final response = await Future.wait(
      [fetchImage('assets/sheet.png'), fetchJson('assets/level-1.json')]);

  final image = response[0];
  final data = response[1];

  final game = Game('#output', image, data);
  final player = Player();

  game.camera.toFollow = player;
  game.debugger.player = player;

  void setScale(scale) {
    game.camera.scale = scale;
  }

  [1, 2, 4].forEach((index) => querySelector('.scale-$index')
      .onClick
      .listen((event) => setScale(index)));

  game.entities.addAll([
    Background(game.canvasSize, color: '#5d988d'),
    game.tiles,
    player,
    game.debugger
  ]);

  // game.debugger.texts.add(() => '${player.collisionDirections}');

  game.start((num deltaTime, Game game) {});
}
