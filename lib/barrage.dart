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
  List maskCfg;

  @override
  void initState() {
    super.initState();
    _controller = BarrageWallController.all(
      options: ChannelOptions(height: 24.0),
      channelCount: 17,
    );
    barrageDatas = BarrageData();

    eventBus.on<ChangeMaskEvent>().listen((event) {
      if (widget.cfg[event.time] == null) {
        print(event.time);
      }
      setState(() {
        maskCfg = widget.cfg[event.time];
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
      _timer = Timer.periodic(
          const Duration(milliseconds: 170), (_) => _addBarrage());
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
    num scale = MediaQuery.of(context).size.width / 720;
    return ClipPath(
      clipper: maskCfg != null ? TrianglePath(maskCfg, scale) : null,
      child: Container(
        color: Colors.transparent,
        child: _controller.buildView(),
      ),
    );
  }
}

class TrianglePath extends CustomClipper<Path> {
  List<dynamic> maskCfg;
  num scale;

  TrianglePath(this.maskCfg, this.scale);

  @override
  Path getClip(Size size) {
    var path = Path();
    maskCfg.forEach((maskEach) {
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
