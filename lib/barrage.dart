import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'mock.dart';
import 'core.dart';

class BarrageInit extends StatefulWidget {
  const BarrageInit({ Key key }) : super(key: key);

  @override
  BarrageInitState createState() => BarrageInitState();
}

class BarrageInitState extends State<BarrageInit> {
  BarrageWallController _controller;
  BarrageData barrageDatas;
  Timer _timer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = BarrageWallController.all(
      options: ChannelOptions(height: 24.0),
      channelCount: 13,
    );
    barrageDatas = BarrageData();
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
      // 每间隔 300 毫秒添加一条弹幕
      _timer = Timer.periodic(
          const Duration(milliseconds: 300), (_) => _addBarrage());
    } else {
      _controller.pause();
      _timer.cancel();
    }
  }

  int _addBarrage() {
    print(BarrageData);
    print(barrageDatas.randomIcon);
    print(12);
    print(454);
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: _controller.buildView(),
        ),
      ],
    );
  }
}

