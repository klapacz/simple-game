import 'traits.dart';

mixin Gravity on Movable {
  var gravity = 150;
  var disabledGravity = false;

  void updateGravity() {
    if (!disabledGravity) velocity.y += gravity;
  }
}
