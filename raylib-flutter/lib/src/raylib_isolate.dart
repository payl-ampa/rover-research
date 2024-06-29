import 'package:raylib_flutter/src/data.dart';
import 'package:typed_isolate/typed_isolate.dart';

import 'package:raylib/raylib.dart';


class RaylibIsolate extends IsolateChild<IsolatePayload, RaylibCommand>{

  Color cubecolor = Color.red;

  RaylibIsolate() : super(id: 'raylib-isolate');

  @override
  void run(){

    initLibrary(
      linux: 'lib/include/libraylib.so',
      windows: 'lib/include/raylib.dll',
    );

    const screenWidth = 800;
    const screenHeight = 450;

    initWindow(
      screenWidth,
      screenHeight,
      'flutter-raylib [core] initial testing',
    );

    // Define the camera to look into our 3d world
    final camera = Camera(
      position: Vector3(10, 20, 20), // Camera position
      target: Vector3.zero(), // Camera looking at point
      up: Vector3(0, 1, 0), // Camera up vector (rotation towards target)
      fovy: 45, // Camera field-of-view Y
    );

    final cubePosition = Vector3.zero();

    setCameraMode(camera, CameraMode.orbital);
    setTargetFPS(60);

    // This really needs to be in its own thread
    while(!windowShouldClose()) {

      updateCamera(camera);

      if (isKeyDown(KeyboardKey.z)) camera.target = Vector3.zero();

      beginDrawing();

      clearBackground(Color.rayWhite);

      beginMode3D(camera);

      drawCube(cubePosition, 2, 2, 2, cubecolor);
      drawCubeWires(cubePosition, 2, 2, 2, Color.maroon);

      drawGrid(10, 1);

      endMode3D();

      drawRectangle(10, 10, 320, 133, fade(Color.skyBlue, .5));
      drawRectangleLines(10, 10, 320, 133, Color.blue);

      drawText('Orbital camera:', 20, 20, 10, Color.black);
      drawText('- Mouse Wheel to Zoom in-out', 20, 40, 10, Color.darkGray);
      drawText('Updates:', 20, 60, 10, Color.black);
      drawText('- Passing data is now more complicated', 20, 80, 10, Color.darkGray);
      drawText('- Added multithreading', 20, 120, 10, Color.darkGray);

      endDrawing();
      // windowShouldClose = false
      send(IsolatePayload(windowShouldClose: false));
    } 

    closeWindow();
    send(IsolatePayload(windowShouldClose: true));
  }

  @override
  void onData(RaylibCommand data){
    cubecolor = data.color;
    print("Received data from parent: $data");
  }
}