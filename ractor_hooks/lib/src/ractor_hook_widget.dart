import 'package:flutter/material.dart';
import 'package:flutter_hooks2/flutter_hooks2.dart';

abstract class RactorHookWidget extends HookWidget {
  const RactorHookWidget({Key key}) : super(key: key);

  Widget build();
}
