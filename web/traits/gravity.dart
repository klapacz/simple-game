import 'traits.dart';

mixin Gravity on Movable {
  var gravity = 100;

  void updateGravity() {
    velocity.y += gravity;
  }
}
