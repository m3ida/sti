import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sti_project/player.dart';
import 'package:sti_project/video.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.sources);
    //  _initializeVideoPlayerFuture = _controller.initialize();
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(video: widget.video),
          ),
        );
      },
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image(
                image: NetworkImage(widget.video.thumb),
                fit: BoxFit.cover,
                height: 80,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.video.title.length > 30
                          ? '${widget.video.title.substring(0, 30)}...'
                          : widget.video.title),
                      Text(
                        widget.video.description.length > 100
                            ? '${widget.video.description.substring(0, 100)}...'
                            : widget.video.description,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                  Text(
                    _controller.value.duration.toString().substring(0, 7),
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
