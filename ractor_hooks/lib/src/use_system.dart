import 'package:flutter/foundation.dart';
import 'package:frhooks/frhooks.dart';
import 'package:ractor/ractor.dart';
import './system_provider.dart';

System useSystem() {
  final context = useContext();
  assert(() {
    if (context == null) {
      debugPrint(
          "Can't find context on this element tree, make sure SystemProvider is ancestor of your widget: ${context.widget.runtimeType.toString()}");
    }
    return true;
  }());
  return SystemProvider.of(context).system;
}
