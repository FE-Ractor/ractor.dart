import 'package:dart_actor/src/actor_receive.dart';
import 'package:ractor/ractor.dart';
import 'package:test/test.dart';

class Test extends Store {
  int count = 1;

  @override
  ActorReceive createReceive() {
    return this.receiveBuilder().build();
  }
}

void main() {
  test('subscribe', () {
    var testStore = Test();
    testStore.subscribe(() {
      expect(testStore.count, 1);
    });
  });

  test('setState', () {
    var testStore = Test();
    testStore.setState(() {
      testStore.count++;
    });
    expect(testStore.count, 2);
  });
}
