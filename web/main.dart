import 'entities/entities.dart';

import 'game.dart';

void main() async {
  // final response = await Future.wait([
  //   fetchImage('assets/sheet.png'),
  //   fetchImage('assets/characters.png'),
  //   fetchJson('assets/level-1.json')
  // ]);

  // ImageElement sheet = response[0];
  // ImageElement characters = response[1];
  // Map data = response[2];

  final game = Game();
  await game.setup();

  final player = Player();

  game.camera.toFollow = player;
  game.debugger.player = player;

  game.entities.addAll([
    Background(game.canvasSize, color: '#5d988d'),
    game.tilesMap,
    player,
    game.debugger
  ]);

  game.start();
}
