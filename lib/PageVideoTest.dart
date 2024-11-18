import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
const String url =
    "https://sdn-global-live-streaming-packager-cache.3qsdn.com/7839/7839_264_live.m3u8?latency=low";

const String tvBild =
    "https://sdn-global-live-streaming-packager-cache.3qsdn.com/7441/7441_264_live.m3u8?latency=low";

const String url3 =
    "https://sdn-global-live-streaming-packager-cache.3qsdn.com/102519/102519_264_live.m3u8?latency=low";
const String url_es = "https://sdn-global-live-streaming-packager-cache.3qsdn.com/96793/96793_264_live.m3u8?latency=low";
const String url_fr = "https://sdn-global-live-streaming-packager-cache.3qsdn.com/84793/84793_264_live.m3u8?latency=low";
class PageVideoTest extends StatefulWidget {
  const PageVideoTest({super.key});

  @override
  State<PageVideoTest> createState() => _PageVideoTestState();
}

class _PageVideoTestState extends State<PageVideoTest> {
  @override
  Widget build(BuildContext context) {
    const bool cleanFeed = true;
    const bool tvFeed = false;
    return const Column(
      children: [
        if (cleanFeed)
          Expanded(
            child: MyHomePage(
              url: tvBild,
            ),
          ),
        if (tvFeed)
          Expanded(
              child: MyHomePage(
                url: tvBild,
              )),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.url});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String url;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController? controller;
  ChewieController? chewieController;
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
        child: chewieController == null
            ? InkWell(onTap: () => setState(() {}), child: const Placeholder())
            : Column(
          children: [
            AspectRatio(
              aspectRatio: chewieController?.aspectRatio ?? 16 / 9,
              child: Chewie(
                controller: chewieController!,
              ),
            ),
            if (controller?.value.hasError ?? false)
              Text(controller!.value.errorDescription ?? ''),
            if (controller?.value.hasError ?? false) Text(getDuration()),
          ],
        ));
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

  Future<void> initPlayer() async {
    try {
      controller = VideoPlayerController.networkUrl(Uri.parse(widget.url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      await controller!.initialize();

      chewieController = ChewieController(
        videoPlayerController: controller!,
        autoPlay: true,
        looping: false,
        showOptions: false,
        showControlsOnInitialize: false,
      );
      setState(() {});
      chewieController!.play();
    } catch (e) {
      print(e);
    }
  }
}

