import 'entities/entities.dart';

import 'game.dart';
import 'vector.dart';

void main() async {
  final game = Game();
  await game.setup();
}
