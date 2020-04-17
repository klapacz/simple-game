import 'traits.dart';

mixin Gravity on Movable {
  var gravity = 150;

  void updateGravity() {
    velocity.y += gravity;
  }
}
