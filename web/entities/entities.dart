import '../box/box.dart';
import '../traits/traits.dart';
import '../vector.dart';

export 'player.dart';
export 'debugger.dart';

class Background extends ColorBox implements Updateable {
  Background(canvasSize, {color = '#efefef'})
      : super(Vector(0, 0), canvasSize, color, blockCamera: true);

  @override
  void update(deltTime, game) {
    size = game.canvasSize.cloned;
  }
}
