import 'package:flutter/material.dart';
import 'package:ractor/ractor.dart';

class _SystemProviderWidget extends StatefulWidget {
  final Widget child;
  final System system;
  final List<Store> stores;

  const _SystemProviderWidget({
    Key key,
    @required this.system,
    this.stores = const [],
    @required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SystemProviderWidgetState();
  }
}

class _SystemProviderWidgetState extends State<_SystemProviderWidget> {
  @override
  void initState() {
    super.initState();
    widget.stores.forEach((store) {
      store.mountStatus = "global";
      widget.system.actorOf(store);
    });
  }

  /// store 是否全局取决于 SystemProvider 是否会被卸载。嵌套 SystemProvider 的情况有卸载 store 的需求。
  @override
  void dispose() {
    super.dispose();
    widget.stores.forEach((store) {
      widget.system.get(store.runtimeType).getContext().stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
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
            child: _SystemProviderWidget(
                system: system, child: child, stores: stores));

  static SystemProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(SystemProvider);
  }

  @override
  bool updateShouldNotify(SystemProvider oldWidget) =>
      system != oldWidget.system;
}
