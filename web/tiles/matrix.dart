import 'dart:collection';

import '../vector.dart';

class Matrix<T> extends ListBase {
  List<List<T>> rows = [];

  Matrix(this.rows);

  Matrix.fromMatrix(Matrix matrix, T Function(int, int, dynamic) callback) {
    rows = [
      for (var y = 0; y < matrix.rows.length; y++)
        [
          for (var x = 0; x < matrix.rows[y].length; x++)
            callback(x, y, matrix.rows[y][x])
        ]
    ];
  }

  Matrix.fromList(List<T> list, int height, int width) {
    rows = [for (var i = 0; i < (list.length / width).ceil(); i++) []];

    for (var i = 0; i < list.length; i++) {
      rows[(i / width).floor()].add(list[i]);
    }
  }

  @override
  void forEach(Function(T) callback) {
    for (var y = 0; y < length; y++) {
      var row = this[y];

      for (var x = 0; x < width; x++) {
        if (row[x] != null) callback(row[x]);
      }
    }
  }

  @override
  Matrix<T> where(bool Function(T) test) {
    return Matrix([
      for (var y = 0; y < length; y++)
        [for (var x = 0; x < width; x++) test(this[y][x]) ? this[y][x] : null]
    ]);
  }

  Matrix<T> getPart(int minX, int minY, int maxX, int maxY) {
    return Matrix([
      for (var y = minY; y < maxY; y++)
        if (y >= 0 && y < length)
          [
            for (var x = minX; x < maxX; x++)
              if (x >= 0 && x < width) this[y][x]
          ]
    ]);
  }

  Vector get size => Vector(width, length);

  int get width => rows[0].length;

  set width(int newWidth) {
    for (var y = 0; y < length; y++) {
      this[y].length = newWidth;
    }
  }

  @override
  set length(int newLength) => rows.length = newLength;

  @override
  int get length => rows.length;

  @override
  List<T> operator [](int y) => rows[y];

  @override
  operator []=(int index, value) => rows[index] = value;
}
