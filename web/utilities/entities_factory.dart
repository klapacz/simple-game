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

    print(game.mapIllustrator);

    for (var objectGroup in game.mapIllustrator.map.objectGroups) {
      for (var object in objectGroup.tmxObjects) {
        if (object.type == 'snake') {
          snakes
              .add(Snake(Vector(object.x, object.y), object.x + object.width));
        }
      }
    }

    entities = [
      Background(game.canvasSize, color: '#5d988d'),
      game.mapIllustrator,
      ...snakes,
      player,
      game.graphicDebugger
    ];
  }
}
