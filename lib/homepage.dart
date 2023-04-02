import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sti_project/video.dart';
import 'package:sti_project/videocard.dart';
import 'player.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Video> _videos = [];

  Future<void> _loadVideos() async {
    final jsonStr = await rootBundle.loadString('assets/videos.json');
    final jsonList = jsonDecode(jsonStr);
    final List<Video> videos = (jsonList["videos"] as List<dynamic>)
        .map((e) => Video.fromJson(e))
        .toList();
    setState(() {
      _videos = videos;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox.expand(
        child: Builder(
          builder: (context) {
            if (_videos.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => const Divider(),
                      padding: const EdgeInsets.all(5),
                      itemCount: _videos.length,
                      itemBuilder: (context, index) {
                        final video = _videos[index];
                        return VideoCard(video: video);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
