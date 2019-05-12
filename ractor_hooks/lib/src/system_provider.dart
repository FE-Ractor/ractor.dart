import 'package:flutter/material.dart';
import 'package:frhooks/frhooks.dart';
import 'package:ractor/ractor.dart';
import 'package:ractor_hooks/ractor_hooks.dart';

class _SystemProviderWidget extends RactorHookWidget {
  final Widget child;
  final List<Store> stores;

  const _SystemProviderWidget({
    Key key,
    this.stores = const [],
    @required this.child,
  }) : super(key: key);

  static System currentSystem;

  Widget build(BuildContext context) {
    final system = useSystem();

    useEffect(() {
      stores.forEach((store) {
        store.mountStatus = "global";
        system.actorOf(store);
      });
    }, []);

    return this.child;
  }
}

class SystemProvider extends InheritedWidget {
  final System system;

  SystemProvider({
    Key key,
    @required this.system,
    List<Store> stores = const [],
    @required Widget child,
  })  : assert(system != null),
        assert(child != null),
        super(
            key: key,
            child: _SystemProviderWidget(child: child, stores: stores));

  static SystemProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(SystemProvider);
  }

  @override
  bool updateShouldNotify(SystemProvider oldWidget) =>
      system != oldWidget.system;
}
