import 'package:flutter/material.dart';
import 'package:raylib/raylib.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isWindowOpen = false;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      if (!_isWindowOpen){
        createRaylibWindow();
      } else {
        print("Window already open");
      }
    });
  }
  
  @override
  void initState(){
    initLibrary(
      linux: 'lib/include/libraylib.so',
      windows: 'lib/include/raylib.dll',
    );
    super.initState();
  }

  // Creates a glfw window outset of flutter's context, still useful for passing data
  void createRaylibWindow() async{
    const screenWidth = 800;
    const screenHeight = 450;

    
    initWindow(
      screenWidth,
      screenHeight,
      'dart-raylib [core] example - 3d camera free',
    );
    _isWindowOpen = true;

    // Define the camera to look into our 3d world
    final camera = Camera(
      position: Vector3(10, 10, 10), // Camera position
      target: Vector3.zero(), // Camera looking at point
      up: Vector3(0, 1, 0), // Camera up vector (rotation towards target)
      fovy: 45, // Camera field-of-view Y
    );

    final cubePosition = Vector3.zero();

    setCameraMode(camera, CameraMode.free); // Set a free camera mode

    setTargetFPS(60);

    while (!windowShouldClose()) {
      await Future.delayed(const Duration(milliseconds: 0));
      updateCamera(camera);

      if (isKeyDown(KeyboardKey.z)) camera.target = Vector3.zero();

      beginDrawing();

      clearBackground(Color.rayWhite);

      beginMode3D(camera);

      drawCube(cubePosition, 2, 2, 2, Color.red);
      drawCubeWires(cubePosition, 2, 2, 2, Color.maroon);

      drawGrid(10, 1);

      endMode3D();

      drawRectangle(10, 10, 320, 133, fade(Color.skyBlue, .5));
      drawRectangleLines(10, 10, 320, 133, Color.blue);

      drawText('Free camera default controls:', 20, 20, 10, Color.black);
      drawText('- Mouse Wheel to Zoom in-out', 40, 40, 10, Color.darkGray);
      drawText('- Mouse Wheel Pressed to Pan', 40, 60, 10, Color.darkGray);
      drawText(
        '- Alt + Mouse Wheel Pressed to Rotate',
        40,
        80,
        10,
        Color.darkGray,
      );
      drawText(
        '- Alt + Ctrl + Mouse Wheel Pressed for Smooth Zoom',
        40,
        100,
        10,
        Color.darkGray,
      );
      drawText('- Z to zoom to (0, 0, 0)', 40, 120, 10, Color.darkGray);

      endDrawing();
    }

    closeWindow();
    _isWindowOpen = false;

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
