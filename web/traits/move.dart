import 'dart:core';

import '../box/box.dart';
import '../colliders/colliders.dart';
import '../entities/entity.dart';
import '../game.dart';
import '../vector.dart';

import 'traits.dart';

export '../colliders/colliders.dart';

enum Directions { Left, Right, Top, Bottom, Platform }

class Move implements Trait {
  BoxEntity entity;

  Vector by = Vector.blank();
  Vector lastVelocity = Vector.blank();

  Map<Type, Collider> colliders = {};
  Set<Directions> collisionDirections = {};

  Move(this.entity);

  factory Move.withTileCollider(BoxEntity entity) {
    final move = Move(entity);

    move.addCollider(TileCollider(move, entity));
    move.addCollider(PlatformCollider(move, entity));

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

      if (collidingTiles.isNotEmpty) {
        callback(collider, collidingTiles);
      } else {
        collider.nothing(this);
      }
    });
  }

  void moveAndCheckCollision(Game game) {
    final mapCollider = game.map.collider;

    collisionDirections.clear();

    if (by.x != 0) {
      entity.position.x += by.x;

      _findColliding(
        mapCollider,
        (collider, tiles) => collider.onX(this, tiles),
      );
    }

    if (by.y != 0) {
      entity.position.y += by.y;

      _findColliding(
        mapCollider,
        (collider, tiles) => collider.onY(this, tiles),
      );
    }

    if (by.x != 0 || by.y != 0) {
      _findColliding(
        mapCollider,
        (collider, tiles) => collider.both(this, tiles),
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
