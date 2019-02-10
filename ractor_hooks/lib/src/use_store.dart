import 'package:ractor/ractor.dart';
import './system_provider.dart';
import './ractor_hook_element.dart';

S useStore<S>(Store<S> _store) {
  var currentSystem = SystemProvider.getCurrentSystem();
  var currentContext = RactorHookElement.getCurrentContext();

  assert(currentSystem != null);
  assert(currentContext != null);

  var storeRef = currentSystem.get(_store.runtimeType);
  Store store = storeRef != null
      ? storeRef.getInstance()
      : currentSystem.actorOf(_store).getInstance();
  store.mountStatus = store.mountStatus != null
      ? store.mountStatus
      : storeRef != null ? "global" : "local";

  var _result = currentContext.useState(store.state);
  var state = _result[0];
  var setState = _result[1];

  currentContext.useMount(() {
    var dispose = store.subscribe((nextState) {
      if (nextState != state) {
        setState(nextState);
        currentContext.markNeedsBuild();
      }
    });
    return () {
      dispose();
      if (store.mountStatus == "local") {
        store.context.stop();
      }
    };
  });

  return state;
}
