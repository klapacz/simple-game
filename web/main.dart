import 'entities/entities.dart';

import 'game.dart';
import 'vector.dart';

void main() async {
  final game = Game();
  await game.setup();

  final player = Player();

  game.camera.toFollow = player;
  game.debugger.player = player;

  final snakes = [];

  for (var layer in game.data['levelData']['layers']) {
    print(layer);
    if (layer['name'] == 'snakes') {
      for (var object in layer['objects']) {
        if (object['type'] == 'snake') {
          snakes.add(Snake(
              Vector(object['x'], object['y']), object['x'] + object['width']));
        }
      }
    }
  }

  game.entities.addAll([
    Background(game.canvasSize, color: '#5d988d'),
    game.tilesMap,
    ...snakes,
    player,
    game.debugger
  ]);

  game.start();
}
