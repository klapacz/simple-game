import 'box/box.dart';

// bool aabb(Box a, Box b) =>
//     (a.minX < b.maxX && a.maxX > b.minX) &&
//     (a.minY < b.maxY && a.maxY > b.minY);

bool aabb(Box a, Box b) => !(a.minX >= b.maxX ||
    a.maxX <= b.minX ||
    a.minY >= b.maxY ||
    a.maxY <= b.minY);
