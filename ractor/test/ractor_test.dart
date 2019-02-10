import 'package:dart_actor/src/actor_receive.dart';
import 'package:ractor/ractor.dart';
import 'package:test/test.dart';

class Test extends Store<int> {
  int state = 1;
  @override
  ActorReceive createReceive() {
    return this.receiveBuilder().build();
  }
}

void main() {
  test('subscribe', () {
    var testStore = Test();
    testStore.subscribe((state) {
      expect(state, 1);
    });
  });

  test('setState', () {
    var testStore = Test();
    testStore.setState(2);
    expect(testStore.state, 2);
  });
}
