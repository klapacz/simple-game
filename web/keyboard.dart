import 'dart:html';

class Keyboard {
  final clicked = <String, bool>{};

  Keyboard() {
    window.onKeyDown.listen((event) => clicked[event.key] = true);
    window.onKeyUp.listen((event) => clicked[event.key] = false);
  }

  bool isClickedKey(String key, {ignoreUppercase = true}) =>
      (clicked.containsKey(key) && clicked[key]) ||
      (ignoreUppercase &&
          clicked.containsKey(key.toUpperCase()) &&
          clicked[key.toUpperCase()]);
}
