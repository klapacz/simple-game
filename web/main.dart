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

  game.entities.addAll([
    Background(game.canvasSize, color: '#5d988d'),
    game.tilesMap,
    player,
    game.debugger
  ]);

  game.start((num deltaTime, Game game) {
    for (var i = 1; i < 10; i++) {
      if (game.keyboard.isClickedKey('$i')) game.camera.scale = i;
    }
  });
}
