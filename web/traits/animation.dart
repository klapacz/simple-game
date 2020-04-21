import 'dart:html';

import '../entities/entity.dart';
import '../game.dart';
import '../vector.dart';
import 'traits.dart';

class Animation implements Trait, Drawable {
  Map<String, List<Rectangle>> animations;
  BoxEntity entity;

  String currentAnimation;
  int currentFrame = 0;
  num frameTime = 0;
  bool flipFrame = false;

  Animation(this.entity);

  @override
  Type get name => Animation;

  void changeFrame() {}

  @override
  void update(deltaTime, Game game) {
    changeFrame();
    frameTime += deltaTime;

    if (frameTime > 0.15) {
      currentFrame++;
      frameTime = 0;
    }

    if (currentFrame >= animations[currentAnimation].length) currentFrame = 0;
  }

  @override
  void draw(context, camera, game) {
    if (currentFrame == null) return;

    var toDraw = camera.transform(entity);

    final frame = animations[currentAnimation][currentFrame];
    final destSize = Vector(frame.width, frame.height) * camera.scale;

    if (!flipFrame) {
      context.drawImageScaledFromSource(
          game.data['characters'],
          frame.left,
          frame.top,
          frame.width,
          frame.height,
          toDraw.position.x,
          toDraw.position.y,
          destSize.x,
          destSize.y);
    } else {
      context.save();
      context.scale(-1, 1);
      context.drawImageScaledFromSource(
          game.data['characters'],
          frame.left,
          frame.top,
          frame.width,
          frame.height,
          -toDraw.position.x - toDraw.size.x,
          toDraw.position.y,
          destSize.x,
          destSize.y);
      context.restore();
    }
  }
}
