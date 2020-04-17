import 'dart:html';

class Timer {
  num deltaTime, accumulatedTime = 0, lastTime = 0;
  Function(num) update;
  Function draw;

  int fps = 0;

  Timer(this.update, this.draw, {this.deltaTime = 1 / 60}) {
    enqueue();
  }

  void updateProxy(time) {
    accumulatedTime += (time - lastTime) / 1000;
    fps = (1 / accumulatedTime).round();

    if (accumulatedTime > 1) {
      accumulatedTime = 1;
    }

    while (accumulatedTime > deltaTime) {
      update(deltaTime);
      accumulatedTime -= deltaTime;
    }

    lastTime = time;

    draw();

    enqueue();
  }

  void enqueue() {
    window.animationFrame.then(updateProxy);
  }
}
