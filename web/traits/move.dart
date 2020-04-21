import 'dart:core';
import 'dart:developer';

import '../box/box.dart';
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

  void _findColliding(mapCollider, Function(Collider, List<TileBox>) callback) {
    final collidingLayers = mapCollider.collidingTiles(entity);

    colliders.values.forEach((collider) {
      final collidingTiles = <TileBox>[];

      collidingLayers.forEach((layer, tiles) {
        collidingTiles.addAll(
          tiles.where(collider.test(layer)),
        );
      });

      callback(collider, collidingTiles);
    });
  }

  void moveAndCheckCollision(Game game) {
    final mapCollider = game.map.collider;

    if (by.x != 0) {
      entity.position.x += by.x;

      _findColliding(
        mapCollider,
        (collider, tiles) => collider.onX(game, tiles),
      );
    }

    if (by.y != 0) {
      entity.position.y += by.y;

      _findColliding(
        mapCollider,
        (collider, tiles) => collider.onY(game, tiles),
      );
    }

    if (by.x != 0 || by.y != 0) {
      _findColliding(
        mapCollider,
        (collider, tiles) => collider.both(game, tiles),
      );
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
