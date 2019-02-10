import 'package:ractor/ractor.dart';
import './ractor_system.dart';

System useSystem() {
  return SystemProvider.getCurrentSystem();
}
