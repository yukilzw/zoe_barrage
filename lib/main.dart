import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'barrage.dart';
import 'video.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class MyApp extends StatelessWidget {
  static final String _title = 'barrage vidoe';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Index()
            ),
          ],
        ),
      ),
    );
  }
}

class Index extends StatelessWidget {
  static final GlobalKey<BarrageInitState> barrageKey = GlobalKey();
  static final GlobalKey<VedioBgState> videoKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    num statusHeight = MediaQueryData.fromWindow(window).padding.top;
    num videoHeight = MediaQuery.of(context).size.width * 16 / 9;

    return Container(
      color: Colors.black,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          
          Positioned(
            top: statusHeight,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: videoHeight,
              child: VedioBg(
                key: videoKey,
              ),
            ),
          ),
          Positioned(
            top: statusHeight,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: videoHeight,
              child: BarrageInit(
                key: barrageKey
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              barrageKey.currentState.change();
              videoKey.currentState.change();
            },
            child: Container(color: Colors.transparent)
          ),
        ],
      ),
    );
  }
}
