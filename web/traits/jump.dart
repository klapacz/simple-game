import 'movable.dart';
import '../vector.dart';
import '../game.dart';

mixin Jump on Movable {
  bool isJumping = false;
  final defaultJumpTime = 0;
  int jumpTime = 0;
  int onFloorTime = 0;
  var defaultJumpSpeed = Vector(0, -400);

  Vector get jump => isJumping ? defaultJumpSpeed : Vector(0, 0);

  void startJump() {
    if (isJumping == false && onFloorTime > 5) isJumping = true;
  }

  void stopJump() {
    isJumping = false;
    jumpTime = defaultJumpTime;
  }

  void updateJump(num deltaTime, Game game) {
    if (isJumping == true) {
      jumpTime--;
    }

    velocity += jump;

    if (collisionDirections.contains(Directions.Bottom)) {
      onFloorTime++;
    } else {
      onFloorTime = 0;
    }

    if (jumpTime <= 0 || collisionDirections.contains(Directions.Top)) {
      stopJump();
    }
  }
}
