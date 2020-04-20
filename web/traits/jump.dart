import 'movable.dart';
import '../vector.dart';
import '../game.dart';
import 'traits.dart';

mixin Jump on Movable {
  bool isJumping = false;
  final defaultJumpTime = 0;
  int jumpTime = 0;
  int onFloorTime = 0;
  var defaultJumpSpeed = Vector(0, -250);

  Vector get jump => isJumping ? defaultJumpSpeed : Vector(0, 0);

  void startJump() {
    if (isJumping == false && onFloorTime > 5) {
      print('jumpIsStarted');
      isJumping = true;
      if (this is Gravity) {
        (this as Gravity).disabledGravity = true;
      }
    }
  }

  void stopJump() {
    isJumping = false;
    jumpTime = defaultJumpTime;
    if (this is Gravity) {
      (this as Gravity).disabledGravity = false;
    }
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

    if (isJumping &&
        (jumpTime <= 0 || collisionDirections.contains(Directions.Top))) {
      stopJump();
    }
  }
}
