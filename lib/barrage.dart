import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'mock.dart';
import 'core.dart';
import 'event.dart';

class BarrageInit extends StatefulWidget {
  final Map cfg;
  const BarrageInit({Key key, this.cfg}) : super(key: key);

  @override
  BarrageInitState createState() => BarrageInitState();
}

class BarrageInitState extends State<BarrageInit> {
  BarrageWallController _controller;
  BarrageData barrageDatas;
  Timer _timer;
  bool isPlaying = false;
  List curMaskData;

  @override
  void initState() {
    super.initState();
    _controller = BarrageWallController.all(
      options: ChannelOptions(height: 24.0),
      channelCount: 25,
    );
    barrageDatas = BarrageData();

    eventBus.on<ChangeMaskEvent>().listen((event) {
      setState(() {
        curMaskData = widget.cfg[event.time] ?? curMaskData;
      });
    });
    change();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void change() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _controller.play();
      // 投放弹幕CD时间
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => _addBarrage());
    } else {
      _controller.pause();
      _timer.cancel();
    }
  }

  int _addBarrage() {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        barrageDatas.randomIcon,
        const SizedBox(width: 8.0),
        Text(
          barrageDatas.randomWord,
          style: TextStyle(
            fontSize: 17.0,
            color: barrageDatas.randomTextColor(),
          ),
        ),
      ],
    );

    var item = BarrageItem(
      content: content,
      // 随机一个 0.5 到 1.5 之间的滚动速度
      speed: Random().nextDouble() + 0.5,
      start: isPlaying,
    );

    return _controller.add(item);
  }

  @override
  Widget build(BuildContext context) {
    num scale = MediaQuery.of(context).size.width / widget.cfg['frame_width'];
    return ClipPath(
      clipper: curMaskData != null ? TrianglePath(curMaskData, scale) : null,
      child: Container(
        color: Colors.transparent,
        child: _controller.buildView(),
      ),
    );
  }
}

class TrianglePath extends CustomClipper<Path> {
  List<dynamic> curMaskData;
  num scale;

  TrianglePath(this.curMaskData, this.scale);

  @override
  Path getClip(Size size) {
    var path = Path();
    curMaskData.forEach((maskEach) {
      for (var i = 0; i < maskEach.length; i++) {
        if (i == 0) {
          path.moveTo(maskEach[i][0] * scale, maskEach[i][1] * scale);
        } else {
          path.lineTo(maskEach[i][0] * scale, maskEach[i][1] * scale);
        }
      }
    });

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
