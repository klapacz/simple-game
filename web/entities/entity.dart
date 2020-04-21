import 'dart:html';

import '../box/box.dart';
import '../camera.dart';
import '../game.dart';
import '../traits/traits.dart';

class Entity implements Updateable, Drawable {
  List<Drawable> illustrators = [];
  Map<Type, Trait> traits = {};

  void addTrait(Trait trait) => traits[trait.name] = trait;

  @override
  void update(num deltaTime, Game game) {
    traits.values.forEach((trait) => trait.update(deltaTime, game));
  }

  @override
  void draw(CanvasRenderingContext2D context, Camera camera, Game game) {
    illustrators
        .forEach((illustrator) => illustrator.draw(context, camera, game));
  }

  Trait operator [](Type trait) => (traits[trait]);
}

class BoxEntity extends Box with Entity {
  BoxEntity(position, size) : super(position, size);
}
