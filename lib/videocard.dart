import 'package:flutter/material.dart';
import 'package:sti_project/player.dart';
import 'package:sti_project/video.dart';

class VideoCard extends StatelessWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(video: video),
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
                image: NetworkImage(video.thumb),
                fit: BoxFit.cover,
                height: 80,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(video.title.length > 30
                      ? '${video.title.substring(0, 30)}...'
                      : video.title),
                  Text(
                    video.description.length > 100
                        ? '${video.description.substring(0, 100)}...'
                        : video.description,
                    overflow: TextOverflow.clip,
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
