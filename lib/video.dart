import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'event.dart';

class VedioBg extends StatefulWidget {
  final Map cfg;
  const VedioBg({Key key, this.cfg}) : super(key: key);

  @override
  VedioBgState createState() => VedioBgState();
}

class VedioBgState extends State<VedioBg> {
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  bool _playing;
  num inMilliseconds = 0;
  Timer timer;
  int timerCount = 0;
  int plusmill = 0;

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
    _controller = VideoPlayerController.asset('py/live.mp4')
      ..setLooping(true)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        var nowMilliseconds = _controller.value.position.inMilliseconds;
        if ((inMilliseconds == 0 && nowMilliseconds > 0) ||
            nowMilliseconds < inMilliseconds) {
          timer?.cancel();
          var stepsTime = (nowMilliseconds / 50).round() * 50;
          timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
            stepsTime += 50;
            eventBus.fire(ChangeMaskEvent(stepsTime.toString()));
          });
        }
        inMilliseconds = nowMilliseconds;
        _playing = isPlaying;
      });

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {});
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
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
            aspectRatio: _controller.value.aspectRatio, // 16 / 9,
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
