# Ractor.dart

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:ractor/ractor.dart';
import 'package:ractor_hooks/ractor_hooks.dart';

void main() => runApp(MyApp());
var system = System("test");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SystemProvider(
        system: system,
        child: CounterWidget(),
      ),
    );
  }
}

class CounterWidget extends RactorHookWidget {
  @override
  Widget build() {
    var state = useStore(CounterStore());
    var _system = useSystem();
    return Scaffold(
      appBar: AppBar(
        title: Text("counter demo"),
      ),
      body: Text(state.toString()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _system.broadcast(Increment()),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Increment {}

class CounterStore extends Store<int> {
  int state = 1;
  createReceive() {
    return this.receiveBuilder().match<Increment>((increment) {
      this.setState(this.state + 1);
    }).build();
  }
}
```
