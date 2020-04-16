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

import 'game.dart';

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
