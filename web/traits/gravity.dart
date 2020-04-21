import '../entities/entity.dart';
import '../game.dart';
import 'traits.dart';

class Gravity implements Trait {
  var value = 150;
  var disabled = false;

  BoxEntity entity;

  Gravity(this.entity);

  @override
  Type get name => Gravity;
  Move get move => (entity.traits[Move] as Move);

  @override
  void update(num deltaTime, Game game) {
    if (!disabled) move.by.y += value;
  }
}
