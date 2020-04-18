import '../game.dart';
import '../entities/entities.dart';
import '../vector.dart';

mixin EntitiesFactory {
  List entities;
  Player player;
  List<Snake> snakes;

  void setupEntities(Game game) {
    player = Player();

    game.camera.toFollow = player;
    game.graphicDebugger.player = player;

    snakes = [];

    for (var layer in game.data['levelData']['layers']) {
      if (layer['type'] == 'objectgroup') {
        for (var object in layer['objects']) {
          if (object['type'] == 'snake') {
            snakes.add(Snake(Vector(object['x'], object['y']),
                object['x'] + object['width']));
          }
        }
      }
    }

    entities = [
      Background(game.canvasSize, color: '#5d988d'),
      game.tilesMap,
      ...snakes,
      player,
      game.graphicDebugger
    ];
  }
}
