import 'package:flutter/material.dart';
import 'barrage.dart';
import 'video.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String _title = 'barrage vidoe';
  static final GlobalKey<BarrageInitState> barrageKey = GlobalKey();
  static final GlobalKey<VedioBgState> videoKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    VedioBg(
                      key: videoKey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 198),
                      child:  BarrageInit(
                        key: barrageKey
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        barrageKey.currentState.change();
                        videoKey.currentState.change();
                      },
                      child: Container(
                        color: Colors.transparent
                      )
                    ),
                  ],
                ),
              ),
            ),                                      
          ],
        ),
      ),
    );
  }
}