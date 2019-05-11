# Ractor

A fresh and funny state management package. Power by `dart-actor`.


# Usage

Racor.dart consist of three main ideas. Thay are `System`, `Store` and `Event`.

## System
Every logic app should have an event system to broadcast and catch event.
```dart
import 'package:ractor/ractor.dart';

var system = System("cardcard");
```

## Event
IMO, everything should trigger event. Such as click button, select a photo. Event should indicate what user have done. You can create a event by class.

```dart
class SetCoverImage {
  File cover;

  SetCoverImage(cover);
}
```

## Store
Store is a unit to store state and catch event. After store catched related events, you can transform event to new state or do nothing.

```dart
import 'dart:io';

import 'package:ractor/ractor.dart';

class DraftStore extends Store {
  File cover;

  createReceive() {
    return receiveBuilder().match<SetCoverImage>((setCoverImage) {
      // we catched SetCoverImage, setCoverImage.cover is our new state right now.
      setState(() {
        cover = setCoverImage.cover;
      });
    }).build();
  }
}
```

# How to use ractor with flutter

Highly recommend `ractor_hooks` to connect ractor store and fluter widget.

## SystemProvider

Just like `Provider` in `react-redux`. `SystemProvider` should be your root widget, and provide system and stores to it.

```dart
import 'package:flutter/material.dart';
import 'package:ractor_hooks/ractor_hooks.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SystemProvider(
      child: MaterialApp(),
      system: system,
      stores: [LoggerStore(), DraftStore()],
    );
  }
}
```

## useStore

`SystemProvider` is a simple dependencies injection. The Instance of the Stores that you provided have been preserved into `SystemProvider`, so must take it by token. `useStore` can help us to take it.

```dart
class MyWidget extends RactorHookWidget {
  build {
    final draftStore = useStore(DraftStore);
    return Image.file(draftStore.cover);
  }
}
```