import 'package:flutter/material.dart';
import 'package:ractor/ractor.dart';

class SystemProvider extends InheritedWidget {
  final System _system;

  SystemProvider({
    Key key,
    @required System system,
    List<Store Function()> stores = const [],
    @required Widget child,
  })  : assert(system != null),
        assert(child != null),
        _system = system,
        super(key: key, child: child) {
    SystemProvider._currentSystem = system;
    stores.forEach((store) => _system.actorOf(store()));
  }

  /// A method that can be called by descendant Widgets to retrieve the Store
  /// from the StoreProvider.
  ///
  /// Important: When using this method, pass through complete type information
  /// or Flutter will be unable to find the correct StoreProvider!
  ///
  /// ### Example
  ///
  /// ```
  /// class MyWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final system = SystemProvider.of(context);
  ///
  ///     return Text('something');
  ///   }
  /// }
  /// ```
  static System of(BuildContext context) {
    final type = _typeOf<SystemProvider>();
    final provider =
        context.inheritFromWidgetOfExactType(type) as SystemProvider;

    if (provider == null) throw Error;
    return provider._system;
  }

  static System _currentSystem;

  static System getCurrentSystem() {
    return SystemProvider._currentSystem;
  }

  // Workaround to capture generics
  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(SystemProvider oldWidget) =>
      _system != oldWidget._system;
}
