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

    for (var objectGroup in game.map.data.objectGroups) {
      for (var object in objectGroup.tmxObjects) {
        if (object.type == 'snake') {
          snakes
              .add(Snake(Vector(object.x, object.y), object.x + object.width));
        }
      }
    }

    entities = [
      game.map.illustrator.background,
      ...snakes,
      player,
      game.graphicDebugger,
      game.map.illustrator.foreground
    ];
  }
}
