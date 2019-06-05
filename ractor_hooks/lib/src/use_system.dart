import 'package:flutter/foundation.dart';
import 'package:frhooks/frhooks.dart';
import 'package:ractor/ractor.dart';
import './system_provider.dart';

System useSystem() {
  final context = useContext();
  final _systemProvider = SystemProvider.of(context);
  assert(() {
    if (_systemProvider == null) {
      debugPrint(
          "Can't find context on this element tree, make sure SystemProvider is ancestor of your widget: ${context.widget}");
          return false;
    }
    return true;
  }());
  final system = _systemProvider.system;
  assert(system != null);
  return system;
}
