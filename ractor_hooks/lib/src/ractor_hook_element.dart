import 'package:flutter/material.dart';
import 'package:ractor/ractor.dart';
import './ractor_hook_widget.dart';

class RactorHookElement extends ComponentElement {
  RactorHookWidget _widget;
  Unsubscribe unsubscribe;
  int hookIndex = 0;
  List<Object> stateStack = [];
  List<void Function() Function()> mountHooksCallbacks = [];
  List<void Function()> unmountHooksCallbacks = [];

  /// Creates an element that uses the given widget as its configuration.
  RactorHookElement(RactorHookWidget widget)
      : _widget = widget,
        super(widget);

  static RactorHookElement _currentContext;

  static RactorHookElement getCurrentContext() {
    return RactorHookElement._currentContext;
  }

  /// If can't find element at [stateStack](Bad State: No element), it means it's new state, and should be append to [stateStack]
  List<dynamic> useState<T>(T state) {
    try {
      var value = stateStack.elementAt(hookIndex);
      setState(nextState) {
        stateStack.replaceRange(hookIndex, hookIndex + 1, [nextState]);
      }

      hookIndex++;
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
    RactorHookElement._currentContext = this;
    var widget = _widget.build();
    didUpdate();
    return widget;
  }

  /// cause of [mount] called before [build]. So create a method [didUpdate] for react like didUpdate.
  void didUpdate() {
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
