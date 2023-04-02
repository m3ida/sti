import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sti_project/video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Video video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  var log = Logger();

  @override
  void initState() {
    super.initState();
    log.e(widget.video.sources);
    _controller = VideoPlayerController.network(widget.video.sources);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });

    //Update Slider value when video is playing
    Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      if (mounted && _controller.value.isPlaying) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: Column(children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
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
                  Text(_controller.value.position.toString().substring(0, 7)),
                  Expanded(
                    child: Slider(
                      value: _controller.value.position.inSeconds.toDouble(),
                      min: 0.0,
                      max: _controller.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      log.e("teste");
                    },
                    icon: const Icon(Icons.fullscreen),
                  )
                ],
              )
            ]));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
