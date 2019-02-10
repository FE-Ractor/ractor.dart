import 'package:flutter/material.dart';
import './ractor_hook_element.dart';

abstract class RactorHookWidget extends Widget {
  const RactorHookWidget({Key key}) : super(key: key);

  @override
  RactorHookElement createElement() {
    return RactorHookElement(this);
  }

  Widget build();
}
