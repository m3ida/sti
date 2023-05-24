import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sti_project/video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Video video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late AnimationController _animationController;
  bool _isFullScreen = false;
  double _aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.sources);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });

    Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      if (mounted && _controller.value.isPlaying) {
        setState(() {});
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: Text(widget.video.title),
            ),
      body: SingleChildScrollView(
        child: Builder(builder: (context) {
          if (!_controller.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }
          return FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Column(
                    children: [
                      LayoutBuilder(builder: (context, constraints) {
                        return RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.linear),
                          ),
                          child: Container(
                            height: _isFullScreen
                                ? MediaQuery.of(context).size.height
                                : null,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            color: Colors.black,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Stack(
                                children: [
                                  VideoPlayer(_controller),
                                  Positioned(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              setState(() {
                                                if (_controller
                                                    .value.isPlaying) {
                                                  _controller.pause();
                                                } else {
                                                  _controller.play();
                                                }
                                              });
                                            },
                                            onDoubleTap: () {
                                              final newPos = _controller
                                                      .value.position -
                                                  const Duration(seconds: 10);
                                              _controller.seekTo(newPos);
                                            },
                                            child: Container(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              setState(() {
                                                if (_controller
                                                    .value.isPlaying) {
                                                  _controller.pause();
                                                } else {
                                                  _controller.play();
                                                }
                                              });
                                            },
                                            onDoubleTap: () {
                                              final newPos = _controller
                                                      .value.position +
                                                  const Duration(seconds: 10);
                                              _controller.seekTo(newPos);
                                            },
                                            child: Container(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          ),
                          Text(_controller.value.position
                              .toString()
                              .substring(0, 7)),
                          const Text('/'),
                          Text(_controller.value.duration
                              .toString()
                              .substring(0, 7)),
                          Expanded(
                            child: Slider(
                              value: _controller.value.position.inSeconds
                                  .toDouble(),
                              min: 0.0,
                              max: _controller.value.duration.inSeconds
                                  .toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  _controller
                                      .seekTo(Duration(seconds: value.toInt()));
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isFullScreen = !_isFullScreen;
                                if (_isFullScreen) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeLeft,
                                    DeviceOrientation.landscapeRight,
                                  ]);
                                  // SystemChrome.setEnabledSystemUIOverlays([]);
                                  SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.immersive);
                                  _aspectRatio =
                                      MediaQuery.of(context).size.width /
                                          MediaQuery.of(context).size.height;
                                  _animationController.forward();
                                } else {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                    DeviceOrientation.portraitDown,
                                  ]);
                                  SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.manual,
                                      overlays: [
                                        SystemUiOverlay.top,
                                        SystemUiOverlay.bottom
                                      ]);

                                  _aspectRatio = 16 / 9;
                                  _animationController.reverse();
                                }
                              });
                            },
                            icon: const Icon(Icons.fullscreen),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(widget.video.description),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
