import 'package:flutter/material.dart';
import './ractor_element.dart';

abstract class RactorWidget extends Widget {
  const RactorWidget({Key key}) : super(key: key);

  @override
  RactorElement createElement() {
    return RactorElement(this);
  }

  Widget build();
}
