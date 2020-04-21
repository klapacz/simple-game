import '../traits/traits.dart';
import 'dart:html';

import '../camera.dart';
import 'entity.dart';

export 'player.dart';

class TextsIllustrator implements Drawable {
  Debugger entity;

  TextsIllustrator(this.entity);

  @override
  void draw(CanvasRenderingContext2D context, Camera camera, game) {
    context
      ..font = '30px VT323, monospace'
      ..fillStyle = '#efefef';

    entity.texts.asMap().forEach((i, text) {
      context.fillText(text(), 10, 40 + 40 * i);
    });
  }
}

class Debugger extends Entity {
  final texts = <Function>[];

  Debugger() {
    illustrators.add(TextsIllustrator(this));
  }
}
