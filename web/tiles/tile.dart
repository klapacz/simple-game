import '../box/box.dart';
import '../vector.dart';

class Tile extends Box {
  int number, x, y;

  Tile(this.x, this.y, this.number, size)
      : super(Vector(x, y) * size, Vector.same(size));
}
