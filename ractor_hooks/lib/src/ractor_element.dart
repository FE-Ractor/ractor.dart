import 'package:flutter/material.dart';
import 'package:ractor/ractor.dart';
import './ractor_widget.dart';

class RactorElement extends ComponentElement {
  RactorWidget _widget;
  Unsubscribe unsubscribe;
  int hookIndex = 0;
  List<Object> stateStack = [];
  List<void Function() Function()> mountHooksCallbacks = [];
  List<void Function()> unmountHooksCallbacks = [];
  bool _mounted = false;

  /// Creates an element that uses the given widget as its configuration.
  RactorElement(RactorWidget widget)
      : _widget = widget,
        super(widget);

  static RactorElement _currentContext;

  static RactorElement getCurrentContext() {
    return RactorElement._currentContext;
  }

  List<dynamic> useState<T>(T state) {
    try {
      var value = stateStack.elementAt(hookIndex);
      setState(nextState) {
        stateStack.replaceRange(hookIndex, hookIndex + 1, [nextState]);
      }

      return [value, setState];
    } catch (e) {
      stateStack.add(state);
      setState(nextState) {
        stateStack.replaceRange(hookIndex, hookIndex + 1, [nextState]);
      }

      hookIndex++;
      return [state, setState];
    }
  }

  void useMount(void Function() Function() mountCallback) {
    mountHooksCallbacks.add(mountCallback);
  }

  @override
  Widget build() {
    var widget = _widget.build();
    if (!_mounted) {
      _mounted = true;
      didBuild();
    }
    return widget;
  }

  /// cause of [mount] called before [build]. So create a method [didBuild] for react like didmount.
  void didBuild() {
    RactorElement._currentContext = this;
    mountHooksCallbacks
        .forEach((callback) => unmountHooksCallbacks.add(callback()));
    hookIndex = 0;
  }

  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    unmountHooksCallbacks.forEach((callback) => callback);
    super.unmount();
  }

  @override
  void update(Widget newWidget) {
    hookIndex = 0;
    super.update(newWidget);
  }
}
