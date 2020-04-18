class Vector {
  num x, y;

  Vector(this.x, this.y);

  Vector.blank()
      : x = 0,
        y = 0;

  Vector.same(value)
      : x = value,
        y = value;

  Vector get cloned => Vector(x, y);
  Vector get rounded => Vector(x.round(), y.round());

  @override
  String toString() => 'v($x, $y)';

  Vector operator +(Vector vector) => Vector(x + vector.x, y + vector.y);
  Vector operator -(Vector vector) => Vector(x - vector.x, y - vector.y);

  Vector operator *(num number) => Vector(x * number, y * number);

  Vector multiplyByVector(Vector vector) => Vector(x * vector.x, y * vector.y);

  bool equal(Vector vector) => x == vector.x && y == vector.y;
}
