import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VedioBg extends StatefulWidget {
  const VedioBg({Key key}) : super(key: key);

  @override
  VedioBgState createState() => VedioBgState();
}

class VedioBgState extends State<VedioBg> {
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  bool _playing;

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
      _controller = VideoPlayerController.asset('assets/phuthon.mp4')
      ..setLooping(true)
      // 播放状态
      ..addListener(() {
          final bool isPlaying = _controller.value.isPlaying;
          _playing = isPlaying;
      });
      // 在初始化完成后必须更新界面
      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
          // setState(() {});
      });
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
        print(snapshot.connectionState);
        if (snapshot.hasError) print(snapshot.error);
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            // aspectRatio: 16 / 9,
            aspectRatio: _controller.value.aspectRatio,
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