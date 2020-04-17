import '../box/box.dart';
import '../game.dart';

mixin Animation {
  Map<String, List<Box>> animations;

  String currentAnimation;
  int currentFrame = 0;
  num frameTime = 0;
  bool flipFrame = false;

  void changeFrame() {}

  void updateAnimation(deltaTime, Game game) {
    changeFrame();
    frameTime += deltaTime;

    if (frameTime > 0.15) {
      currentFrame++;
      frameTime = 0;
    }

    if (currentFrame >= animations[currentAnimation].length) currentFrame = 0;
  }

  void drawFrame(context, camera, game) {
    if (currentFrame == null) return;

    var toDraw = camera.transform(this);

    final frame = animations[currentAnimation][currentFrame];
    final destSize = frame.size * camera.scale;

    if (!flipFrame) {
      context.drawImageScaledFromSource(
          game.data['characters'],
          frame.position.x,
          frame.position.y,
          frame.size.x,
          frame.size.y,
          toDraw.position.x,
          toDraw.position.y,
          destSize.x,
          destSize.y);
    } else {
      context.save();
      context.scale(-1, 1);
      context.drawImageScaledFromSource(
          game.data['characters'],
          frame.position.x,
          frame.position.y,
          frame.size.x,
          frame.size.y,
          -toDraw.position.x - toDraw.size.x,
          toDraw.position.y,
          destSize.x,
          destSize.y);
      context.restore();
    }
  }
}
