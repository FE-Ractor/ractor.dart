import 'dart:async';

import 'package:dart_actor/dart_actor.dart';

class _RactorError implements Exception {
  String message;
  _RactorError(this.message);
}

abstract class Store extends AbstractActor {
  final List listeners = [];

  /// indicate whether this Store is "global", or "local".
  String mountStatus;

  /// ```dart
  /// setState(() {
  ///  count++
  /// });
  /// ```
  void setState(void Function() fn) {
    assert(fn != null);
    final dynamic result = fn() as dynamic;
    assert(() {
      if (result is Future) {
        throw _RactorError('setState() callback argument returned a Future.\n'
            'The setState() method on $this was called with a closure or method that '
            'returned a Future. Maybe it is marked as "async".\n');
      }
      return true;
    }());
    this.listeners.forEach((listener) => listener());
  }

  Unsubscribe subscribe(void Function() listener) {
    this.listeners.add(listener);
    return () {
      var index = this.listeners.indexOf(listener);
      this.listeners.removeAt(index);
    };
  }

  void dispose() {
    this.listeners.clear();
  }
}

typedef Unsubscribe = void Function();
