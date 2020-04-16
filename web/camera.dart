import 'box/box.dart';
import 'vector.dart';

class Camera {
  Box toFollow;
  Vector cameraSize;
  num scale;

  Camera(this.cameraSize, [this.scale = 1]);

  Box transform(Box box) {
    Box transformedBox, tranformedToFollow;

    transformedBox = box.scaled(scale).rouned;
    tranformedToFollow = toFollow.scaled(scale).rouned;

    if (box == toFollow) {
      transformedBox.position.x = tranformedToFollow.position.x >
              cameraSize.x / 2 - tranformedToFollow.size.x / 2
          ? cameraSize.x / 2 - tranformedToFollow.size.x / 2
          : tranformedToFollow.position.x;

      transformedBox.position.y =
          cameraSize.y / 2 - tranformedToFollow.size.y / 2;
    } else {
      transformedBox.position.x = tranformedToFollow.position.x >
              cameraSize.x / 2 - tranformedToFollow.size.x / 2
          ? (cameraSize.x / 2 -
                  tranformedToFollow.size.x / 2 +
                  transformedBox.position.x) -
              tranformedToFollow.position.x
          : transformedBox.position.x;

      transformedBox.position.y = (cameraSize.y / 2 -
              tranformedToFollow.size.y / 2 +
              transformedBox.position.y) -
          tranformedToFollow.position.y;
    }

    return transformedBox;
  }
}
