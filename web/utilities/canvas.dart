import 'dart:html';

import '../vector.dart';

mixin CanvasUtilities {
  CanvasElement canvas;
  CanvasRenderingContext2D context;

  Vector canvasSize;

  void updateCanvasSizeAndSetContext(Vector newCanvasSize) {
    canvasSize = newCanvasSize;

    canvas.width = canvasSize.x;
    canvas.height = canvasSize.y;

    context = canvas.context2D;
    context.imageSmoothingEnabled = false;
  }

  void setupCanvas(canvasSelector, Vector defaultSize) {
    canvas = querySelector(canvasSelector);

    canvas.onFullscreenChange.listen((event) {
      if (document.fullscreenElement == canvas) {
        updateCanvasSizeAndSetContext(
            Vector(document.body.clientWidth, document.body.clientHeight));
      } else {
        updateCanvasSizeAndSetContext(defaultSize);
      }
    });

    updateCanvasSizeAndSetContext(defaultSize);
  }
}
