import 'dart:html';

import '../box/box.dart';
import '../game.dart';
import '../traits/traits.dart';
import '../vector.dart';
import 'entity.dart';

class SnakeAnimation extends Animation {
  SnakeAnimation(entity) : super(entity);

  @override
  final animations = {
    'go': [
      Box(Vector(8, 114), Vector(18, 14)),
      Box(Vector(39, 114), Vector(18, 14)),
      Box(Vector(72, 114), Vector(18, 14)),
      Box(Vector(103, 114), Vector(18, 14)),
    ]
  };

  @override
  final currentAnimation = 'go';
}

class Snake extends BoxEntity {
  num arenaMin, arenaMax;
  num speed = 50;
  Animation animation;
  Move move;

  Snake(position, this.arenaMax) : super(position, Vector(16, 14)) {
    arenaMin = position.x;

    illustrators.add(animation = SnakeAnimation(this));

    addTrait(animation);
    addTrait(Gravity(this));
    addTrait(move = Move.withTileCollider(this));
  }

  @override
  void update(num deltaTime, Game game) {
    if (right > arenaMax || left < arenaMin) {
      speed = -speed;
      animation.flipFrame = !animation.flipFrame;
    }

    move.by.x += speed;

    super.update(deltaTime, game);
  }
}
