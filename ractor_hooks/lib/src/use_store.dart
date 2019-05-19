import 'package:dart_actor/dart_actor.dart';
import 'package:frhooks/frhooks.dart';
import 'package:ractor/ractor.dart';
import 'package:ractor_hooks/ractor_hooks.dart';

S useStore<S extends Store>() {
  final currentSystem = useSystem();
  final currentContext = useContext();

  assert(currentSystem != null);
  assert(currentContext != null);

  final storeRef = currentSystem.get(S);

  Store store = storeRef != null
      ? storeRef.getInstance()
      : currentSystem.actorOf(S as AbstractActor).getInstance();
  store.mountStatus = store.mountStatus != null
      ? store.mountStatus
      : storeRef != null ? "global" : "local";

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
