import 'package:frhooks/frhooks.dart';
import 'package:ractor/ractor.dart';
import 'package:ractor_hooks/ractor_hooks.dart';

S useStore<S extends Store>(S _store) {
  final currentSystem = useSystem();
  final currentContext = useContext();

  assert(currentSystem != null);
  assert(currentContext != null);

  final storeRef = currentSystem.get(S);

  Store store = storeRef != null
      ? storeRef.getInstance()
      : currentSystem.actorOf(_store).getInstance();
  store.mountStatus = store.mountStatus != null
      ? store.mountStatus
      : storeRef != null ? "global" : "local";
  store.context.become(_store.createReceive());

  useEffect(() {
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

  return store;
}
