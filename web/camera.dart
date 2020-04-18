import 'box/box.dart';
import 'game.dart';
import 'vector.dart';

class Camera {
  Box toFollow;
  num scale = 2;
  Game game;

  Vector get size => game.canvasSize;

  Camera(this.game);

  Box transform(Box box) {
    final tranformedToFollow = toFollow.scaled(scale).rouned;

    final centerPlayerOnX = tranformedToFollow.position.x >
        size.x / 2 - tranformedToFollow.size.x / 2;

    final centerPlayerOnY = tranformedToFollow.position.y >
        size.y / 2 - tranformedToFollow.size.y / 2;

    final transformedMapSize = game.mapIllustrator.size * scale;

    final onMapEndY =
        tranformedToFollow.centerY > transformedMapSize.y - size.y / 2;
    final onMapEndX =
        tranformedToFollow.centerX > transformedMapSize.x - size.x / 2;

    if (box == toFollow) {
      if (onMapEndX) {
        tranformedToFollow.position.x += size.x - transformedMapSize.x;
      } else if (centerPlayerOnX) {
        tranformedToFollow.position.x =
            size.x / 2 - tranformedToFollow.size.x / 2;
      }

      if (onMapEndY) {
        tranformedToFollow.position.y += size.y - transformedMapSize.y;
      } else if (centerPlayerOnY) {
        tranformedToFollow.position.y =
            size.y / 2 - tranformedToFollow.size.y / 2;
      }

      return tranformedToFollow;
    } else {
      final transformedBox = box.scaled(scale).rouned;

      if (onMapEndX) {
        transformedBox.position.x += size.x - transformedMapSize.x;
      } else if (centerPlayerOnX) {
        transformedBox.position.x += size.x / 2 -
            tranformedToFollow.size.x / 2 -
            tranformedToFollow.position.x;
      }

      if (onMapEndY) {
        transformedBox.position.y += size.y - transformedMapSize.y;
      } else if (centerPlayerOnY) {
        transformedBox.position.y += size.y / 2 -
            tranformedToFollow.size.y / 2 -
            tranformedToFollow.position.y;
      }

      return transformedBox;
    }
  }
}
