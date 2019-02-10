import 'package:dart_actor/dart_actor.dart';

class System extends ActorSystem {
  System(String name) : super(name);

  dispatch(Object message) {
    broadcast(message);
  }
}
