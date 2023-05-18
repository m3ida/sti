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
      body: Builder(builder: (context) {
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
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.linear)),
                        child: AspectRatio(
                          aspectRatio: _aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
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
                        Expanded(
                          child: Slider(
                            value:
                                _controller.value.position.inSeconds.toDouble(),
                            min: 0.0,
                            max:
                                _controller.value.duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _controller
                                    .seekTo(Duration(seconds: value.toInt()));
                              });
                            },
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       _isFullScreen = !_isFullScreen;
                        //       if (_isFullScreen) {
                        //         SystemChrome.setPreferredOrientations([
                        //           DeviceOrientation.landscapeLeft,
                        //           DeviceOrientation.landscapeRight,
                        //         ]);
                        //         SystemChrome.setEnabledSystemUIOverlays([]);
                        //         _aspectRatio = MediaQuery.of(context).size.width /
                        //             MediaQuery.of(context).size.height;
                        //         _animationController.forward();
                        //       } else {
                        //         SystemChrome.setPreferredOrientations([
                        //           DeviceOrientation.portraitUp,
                        //           DeviceOrientation.portraitDown,
                        //         ]);
                        //         SystemChrome.setEnabledSystemUIOverlays(
                        //             [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                        //         _aspectRatio = 16 / 9;
                        //         _animationController.reverse();
                        //       }
                        //     });
                        //   },
                        //   icon: const Icon(Icons.fullscreen),
                        // )
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
    );
  }
}
