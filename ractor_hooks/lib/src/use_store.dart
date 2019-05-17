import 'package:frhooks/frhooks.dart';
import 'package:ractor/ractor.dart';
import 'package:ractor_hooks/ractor_hooks.dart';

S useStore<S extends Store>(S Function() createStore) {
  final currentSystem = useSystem();
  final currentContext = useContext();

  assert(currentSystem != null);
  assert(currentContext != null);

  final _store = useMemo(createStore);

  useEffect(() {
    final storeRef = currentSystem.get(_store.runtimeType);
    Store store = storeRef != null
        ? storeRef.getInstance()
        : currentSystem.actorOf(_store).getInstance();
    store.mountStatus = store.mountStatus != null
        ? store.mountStatus
        : storeRef != null ? "global" : "local";

    final dispose = store.subscribe(() {
      currentContext.markNeedsBuild();
    });
    return () {
      dispose();
      if (store.mountStatus == "local") {
        store.context.stop();
      }
    };
  }, []);

  return _store;
}
