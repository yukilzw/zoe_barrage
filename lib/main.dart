import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'barrage.dart';
import 'video.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class MyApp extends StatelessWidget {
  static final String _title = 'mask barrage';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(flex: 1, child: Index()),
          ],
        ),
      ),
    );
  }
}

class Index extends StatefulWidget {
  const Index({Key key}) : super(key: key);

  @override
  IndexState createState() => IndexState();
}

class IndexState extends State<Index> with WidgetsBindingObserver {
  static final GlobalKey<BarrageInitState> barrageKey = GlobalKey();
  static final GlobalKey<VedioBgState> videoKey = GlobalKey();

  Map cfg;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future<String> loadString =
        DefaultAssetBundle.of(context).loadString("py/mask_data.json");

    loadString.then((String value) {
      setState(() {
        cfg = json.decode(value);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        break;
      default: break;
    }
  }

  @override
  Widget build(BuildContext context) {
    num statusHeight = MediaQueryData.fromWindow(window).padding.top;
    num videoHeight = MediaQuery.of(context).size.width * 16 / 9;

    return Container(
      color: Colors.black,
      child: cfg == null
          ? SizedBox()
          : Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Positioned(
                  top: statusHeight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: videoHeight,
                    child: VedioBg(
                      key: videoKey,
                      cfg: cfg,
                    ),
                  ),
                ),
                Positioned(
                  top: statusHeight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: videoHeight,
                    child: BarrageInit(
                      key: barrageKey,
                      cfg: cfg,
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     barrageKey.currentState.change();
                //     videoKey.currentState.change();
                //   },
                //   child: Container(color: Colors.transparent),
                // ),
              ],
            ),
    );
  }
}
