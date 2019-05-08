import 'package:frhooks/frhooks.dart';
import 'package:ractor/ractor.dart';
import 'package:ractor_hooks/ractor_hooks.dart';

S useStore<S>(Store<S> _store) {
  var currentSystem = useSystem();

  assert(currentSystem != null);

  var storeRef = currentSystem.get(_store.runtimeType);
  Store store = storeRef != null
      ? storeRef.getInstance()
      : currentSystem.actorOf(_store).getInstance();
  store.mountStatus = store.mountStatus != null
      ? store.mountStatus
      : storeRef != null ? "global" : "local";

  StateContainer stateContainer = useState(store.state);

  useEffect(() {
    var dispose = store.subscribe((nextState) {
      if (nextState != stateContainer.state) {
        stateContainer.setState(nextState);
      }
    });
    return () {
      dispose();
      if (store.mountStatus == "local") {
        store.context.stop();
      }
    };
  }, []);

  return stateContainer.state;
}
