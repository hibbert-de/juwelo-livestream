import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const String url =
    "https://sdn-global-live-streaming-packager-cache.3qsdn.com/7839/7839_264_live.m3u8?latency=low";

const String url2 =
    "https://sdn-global-live-streaming-packager-cache.3qsdn.com/7441/7441_264_live.m3u8?latency=low";

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
  VideoPlayerController? controller;
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        startTime = DateTime.now();
        controller!.addListener(listener);
        setState(() {
          controller!.play();
        });
      });
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
          child: controller == null
              ? const Placeholder()
              : Column(
                  children: [
                    AspectRatio(
                        aspectRatio: controller!.value.aspectRatio,
                        child: VideoPlayer(controller!)),
                    if (controller?.value.hasError ?? false)
                      Text(controller!.value.errorDescription ?? ''),
                    if (controller?.value.hasError ?? false)
                      Text(getDuration()),
                  ],
                )),
    );
  }

  void listener() {
    if (controller?.value.hasError ?? false) {
      setState(() {});
      print("player: ${controller?.value.errorDescription}");
    }
    print("player: ${controller!.value.position}");
    print("player: ${controller?.value.isPlaying}");
  }

  String getDuration() {
    if (startTime == null) {
      return 'no time';
    }
    final duration = DateTime.now().difference(startTime!);
    return 'Duration: ${duration.inMinutes} minutes';
  }
}
