import 'dart:core';

import '../colliders/colliders.dart';
import '../entities/entity.dart';
import '../game.dart';
import '../vector.dart';

import 'traits.dart';

export '../colliders/colliders.dart';

class Move implements Trait {
  BoxEntity entity;

  Vector by = Vector.blank();
  Vector lastVelocity = Vector.blank();
  Map<Type, Collider> colliders = {};

  Move(this.entity);

  factory Move.withTileCollider(BoxEntity entity) {
    final move = Move(entity);

    move.addCollider(TileCollider(move, entity));

    return move;
  }

  Collider addCollider(collider) {
    return colliders[collider.name] = collider;
  }

  @override
  Type get name => Move;

  void moveAndCheckCollision(game) {
    if (by.x != 0) {
      entity.position.x += by.x;

      colliders.values
          .forEach((collider) => collider.onX(game, game.map.collider));
    }

    if (by.y != 0) {
      entity.position.y += by.y;

      colliders.values
          .forEach((collider) => collider.onY(game, game.map.collider));
    }

    if (by.x != 0 || by.y != 0) {
      colliders.values
          .forEach((collider) => collider.both(game, game.map.collider));
    }
  }

  @override
  void update(num deltaTime, Game game) {
    by.x *= deltaTime;
    by.y *= deltaTime;

    moveAndCheckCollision(game);

    lastVelocity = by.cloned;
    by.x = 0;
    by.y = 0;
  }
}
