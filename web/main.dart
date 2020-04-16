import 'dart:html';
import 'entities/entities.dart';
import 'fetch.dart';

import 'game.dart';

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
