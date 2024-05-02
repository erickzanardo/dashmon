import 'package:dashmon/dashmon.dart';

void main(List<String> args) {
  print('Starting Dashmon...');
  final dashmon = Dashmon(args);
  dashmon.start();
}
