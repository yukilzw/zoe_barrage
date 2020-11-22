import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'event.dart';

class VedioBg extends StatefulWidget {
  const VedioBg({Key key}) : super(key: key);

  @override
  VedioBgState createState() => VedioBgState();
}

class VedioBgState extends State<VedioBg> {
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  bool _playing;
  num inMilliseconds;

  void change() {
    if (_playing) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void initState() {
      super.initState();
      _controller = VideoPlayerController.asset('assets/yoona.mp4')
      ..setLooping(true)
      ..addListener(() {
          final bool isPlaying = _controller.value.isPlaying;
          var nowMilliseconds = _controller.value.position.inMilliseconds;
          if (inMilliseconds != nowMilliseconds) {
            inMilliseconds = nowMilliseconds;
            var splitTime = (nowMilliseconds / 500).round() * 500;
            eventBus.fire(ChangeMaskEvent(splitTime.toString())); 
          }
          _playing = isPlaying;
      });

      _initializeVideoPlayerFuture = _controller.initialize().then((_) { });
      _controller.play();
  }

   @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,   // 16 / 9,
            child: VideoPlayer(_controller),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}