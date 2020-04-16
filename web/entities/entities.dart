import '../box/box.dart';
import '../vector.dart';

export 'player.dart';
export 'debugger.dart';

class Background extends ColorBox {
  Background(canvasSize, {color = '#efefef'})
      : super(Vector(0, 0), canvasSize, color, blockCamera: true);
}
