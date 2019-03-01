import 'package:flutter/material.dart';
import 'package:ractor/ractor.dart';

class SystemProvider extends InheritedWidget {
  final System _system;

  SystemProvider({
    Key key,
    @required System system,
    List<Store> stores = const [],
    @required Widget child,
  })  : assert(system != null),
        assert(child != null),
        _system = system,
        super(key: key, child: child) {
    SystemProvider.currentSystem = system;
    stores.forEach((store) {
      store.mountStatus = "global";
      _system.actorOf(store);
    });
  }

  static System currentSystem;

  @override
  bool updateShouldNotify(SystemProvider oldWidget) =>
      _system != oldWidget._system;
}
