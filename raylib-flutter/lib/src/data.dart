import 'package:raylib/raylib.dart';

class IsolatePayload {
  // WARNING: THIS IS NOT A FLUTTER COLOR
  // This is a raylib color
  bool windowShouldClose = false;

  IsolatePayload({required this.windowShouldClose});
}

class RaylibCommand {
  // Status of the raylib window
  final Color color;

  RaylibCommand({required this.color});
}