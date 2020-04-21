import '../entities/entity.dart';
import '../vector.dart';
import '../game.dart';
import 'traits.dart';

class Jump implements Trait {
  Entity entity;

  bool isJumping = false;
  int time = 0, jumpTime = 0, onFloorTime = 0;
  Vector defaultJumpSpeed = Vector(0, -400);

  Jump(this.entity);

  @override
  Type get name => Jump;

  Move get move => entity.traits[Move];
  set move(Move newMove) => entity.traits[Move] = newMove;

  Vector get jump => isJumping ? defaultJumpSpeed : Vector(0, 0);

  void start() {
    if (isJumping == false && onFloorTime > 5) {
      isJumping = true;
      if (this is Gravity) {
        (this as Gravity).disabled = true;
      }
    }
  }

  void stop() {
    if (isJumping) {
      isJumping = false;
      jumpTime = time;
      if (this is Gravity) {
        (this as Gravity).disabled = false;
      }
    }
  }

  @override
  void update(num deltaTime, Game game) {
    if (isJumping == true) {
      jumpTime--;
    }

    move.by += jump;

    final tileCollider = move.colliders[TileCollider] as TileCollider;

    if (tileCollider.collisionDirections.contains(Directions.Bottom)) {
      onFloorTime++;
    } else {
      onFloorTime = 0;
    }

    if (jumpTime <= 0 ||
        tileCollider.collisionDirections.contains(Directions.Top)) {
      stop();
    }
  }
}
