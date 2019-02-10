import 'package:dart_actor/dart_actor.dart';

abstract class Store<T> extends AbstractActor {
  final List listeners = [];
  T state;
  String mountStatus;

  void setState(dynamic nextState) {
    this.state = nextState;
    this.listeners.forEach((listener) => listener(this.state));
  }

  Unsubscribe subscribe(void Function(dynamic nextState) listener) {
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
