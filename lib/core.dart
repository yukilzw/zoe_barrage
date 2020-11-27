import 'package:flutter/material.dart';

class BarrageValue {
  const BarrageValue({
    this.isPlaying = false,
    this.scrollRate = 0.0,
  });

  /// 弹幕是否滚动
  /// default to false
  final bool isPlaying;

  /// 弹幕滚动比例 from 0.0 to 1.0
  /// 0.0 还未出现在屏幕
  /// 0.0 - 0.5 正在进入屏幕
  /// 0.5 完全进入屏幕
  /// 0.5 - 1.0 正在滚出屏幕
  /// 1.0 已完全滚出屏幕
  final double scrollRate;

  bool get completed => scrollRate == 1.0;

  /// 弹幕正在进入屏幕
  bool get scrollIn => scrollRate < 0.5;

  BarrageValue copy({
    bool isPlaying,
    double scrollRate,
  }) {
    return BarrageValue(
      isPlaying: isPlaying ?? this.isPlaying,
      scrollRate: scrollRate ?? this.scrollRate,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'isPlaying: $isPlaying, '
        'scrollRate: $scrollRate)';
  }
}

/// 控制单条弹幕
class BarrageController extends ValueNotifier<BarrageValue> {
  static const defaultDuration = Duration(seconds: 8);

  BarrageController({
    @required this.content,
    this.duration = defaultDuration,
  })  : assert(content != null),
        super(const BarrageValue());

  /// 弹幕内容
  final Widget content;

  /// 弹幕从开始进入屏幕到完全滚出屏幕花费的时间
  /// default to [defaultDuration]
  final Duration duration;

  /// 开始滚动
  void play() {
    value = value.copy(isPlaying: true);
  }

  /// 暂停滚动
  void pause() {
    value = value.copy(isPlaying: false);
  }

  void setScrollRate(double rate) {
    value = value.copy(scrollRate: rate.clamp(0.0, 1.0));
  }
}

/// 单条弹幕视图
class Barrage extends StatefulWidget {
  Barrage(this.barrageController, {Key key}) : super(key: key);

  final BarrageController barrageController;

  @override
  _BarrageState createState() => _BarrageState();
}

class _BarrageState extends State<Barrage> with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation<Offset> _offsetAnimation;

  _PlayPauseState _playPauseState;

  void _initAnimation() {
    final barrageController = widget.barrageController;

    _animationController = AnimationController(
      value: barrageController.value.scrollRate,
      duration: barrageController.duration,
      vsync: this,
    );

    _animationController.addListener(() {
      barrageController.setScrollRate(_animationController.value);
    });

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(_animationController);

    _playPauseState = _PlayPauseState(barrageController)
      ..init()
      ..addListener(() {
        _playPauseState.isPlaying ? _animationController.forward() : _animationController.stop(canceled: false);
      });

    if (_playPauseState.isPlaying) {
      _animationController.forward();
    }
  }

  void _disposeAnimation() {
    _animationController.dispose();
    _playPauseState.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(Barrage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeAnimation();
    _initAnimation();
  }

  @override
  void deactivate() {
    _disposeAnimation();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: SizedBox(
        width: double.infinity,
        child: widget.barrageController.content,
      ),
    );
  }
}

/// 用于监听弹幕滚动状态
class _PlayPauseState extends ValueNotifier<bool> {
  _PlayPauseState(this.controller) : super(controller.value.isPlaying) {
    _listener = () {
      value = controller.value.isPlaying;
    };
  }

  final BarrageController controller;

  VoidCallback _listener;

  bool get isPlaying => value;

  void init() {
    controller.addListener(_listener);
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    super.dispose();
  }
}

/// 单条弹幕信息
class BarrageItem {
  BarrageItem({
    @required this.content,
    this.speed = 1.0,
    this.start = true,
  })  : assert(content != null),
        assert(speed != null),
        assert(speed > 0.0);

  /// 弹幕内容
  final Widget content;

  /// 弹幕移动速度
  /// default to 1.0
  final double speed;

  /// See [ChannelController.add]
  /// if true 添加到弹道后自动开始滚动
  /// if false [ChannelController.playOne] 之后开始滚动
  /// default to true
  final bool start;

  @override
  String toString() {
    return '$runtimeType('
        'content: $content, '
        'speed: $speed, '
        'start: $start)';
  }
}

/// 弹道设置
class ChannelOptions {
  ChannelOptions({
    @required this.height,
    this.direction = ChannelDirection.rtl,
  })  : assert(height != null),
        assert(height >= 0.0);

  /// 弹道高度
  final double height;

  /// default to [ChannelDirection.rtl]
  final ChannelDirection direction;
}

enum ChannelDirection {
  /// Barrage scroll from right to left.
  rtl,

  /// Barrage scroll from left to right.
  ltr,
}

/// 控制单条弹道
class ChannelController extends ValueNotifier<Map<BarrageItem, BarrageController>> {
  ChannelController(this.options)
      : assert(options != null),
        super(const <BarrageItem, BarrageController>{});

  final ChannelOptions options;

  /// 是否空闲状态
  bool get isIdle {
    for (final entry in value.entries) {
      final barrageController = entry.value;
      if (barrageController.value.scrollIn) {
        // 此弹道还有弹幕未完全进入屏幕
        return false;
      }
    }
    // 若此弹道所有弹幕都已完全进入屏幕，则视为空闲
    // 此时可以添加新的弹幕进来
    return true;
  }

  /// 弹道中最后一条弹幕滚动比例 from 0.0 to 1.0
  /// See [BarrageValue.scrollRate]
  double get lastItemScrollRate {
    double minScrollRate = 1.0;
    for (final entry in value.entries) {
      final barrageController = entry.value;
      final scrollRate = barrageController.value.scrollRate;
      if (scrollRate < minScrollRate) {
        minScrollRate = scrollRate;
      }
    }
    return minScrollRate;
  }

  /// 向弹道添加一条弹幕
  void add(BarrageItem item) {
    final micros = BarrageController.defaultDuration.inMicroseconds;
    final controller = BarrageController(
      content: item.content,
      duration: Duration(microseconds: micros ~/ item.speed),
    );

    if (item.start) {
      controller.play();
    }

    controller.addListener(() {
      if (controller.value.completed) {
        // 当滚动完成，从弹道移除
        remove(item);
      }
    });

    value = Map.of(value)..[item] = controller;
  }

  void remove(BarrageItem item) {
    // value = Map.of(value)..remove(item)?.dispose();
    value = Map.of(value)..remove(item);
  }

  void clear() {
    /*value.forEach((_, v) {
      v.dispose();
    });*/
    value = const <BarrageItem, BarrageController>{};
  }

  /// 暂停此弹道所有弹幕
  void pause() {
    value.forEach((_, barrageController) {
      barrageController.pause();
    });
  }

  void play() {
    value.forEach((_, barrageController) {
      barrageController.play();
    });
  }

  void playOne(BarrageItem item) {
    value[item]?.play();
  }

  /// 暂停单条弹幕
  void pauseOne(BarrageItem item) {
    value[item]?.pause();
  }

/*@override
  void dispose() {
    value.forEach((_, v) {
      v.dispose();
    });
    super.dispose();
  }*/
}

/// 单条弹道
class BarrageChannel extends StatefulWidget {
  const BarrageChannel(this.controller, {Key key}) : super(key: key);

  final ChannelController controller;

  @override
  _BarrageChannelState createState() => _BarrageChannelState();
}

class _BarrageChannelState extends State<BarrageChannel> {
  _BarrageChannelState() {
    _listener = () {
      setState(() {});
    };
  }

  VoidCallback _listener;

  ChannelController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_listener);
  }

  @override
  void didUpdateWidget(BarrageChannel oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_listener);
    _controller.addListener(_listener);
  }

  @override
  void deactivate() {
    _controller.removeListener(_listener);
    super.deactivate();
  }

  List<Widget> get _barrages => _controller.value.values.map((e) => Barrage(e)).toList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _controller.options.height,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: _barrages,
      ),
    );
  }
}

/// 弹幕墙，可包含多条 [BarrageChannel]
class BarrageWall extends StatelessWidget {
  const BarrageWall({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final BarrageWallController controller;

  @override
  Widget build(BuildContext context) => controller.buildView();
}

class BarrageWallController {
  BarrageWallController.options(List<ChannelOptions> options)
      : assert(options != null),
        _channels = options.map((e) => ChannelController(e)).toList(growable: false);

  BarrageWallController.all({
    @required ChannelOptions options,
    @required int channelCount,
  })  : assert(options != null),
        assert(channelCount != null),
        assert(channelCount >= 0),
        _channels = List.generate(
          channelCount,
          (index) => ChannelController(options),
          growable: false,
        );

  final List<ChannelController> _channels;

  /// 自动调度，添加到最空闲弹道
  /// Returns the index of channel in [_channels]
  int add(BarrageItem item) {
    final channel = _resolveOptimalChannel();
    channel?.add(item);
    return channel == null ? -1 : _channels.indexOf(channel);
  }

  ChannelController _resolveOptimalChannel() {
    for (final channel in _channels) {
      if (channel.isIdle) {
        return channel;
      }
    }

    ChannelController result;
    for (final channel in _channels) {
      if (result == null || channel.lastItemScrollRate > result.lastItemScrollRate) {
        result = channel;
      }
    }
    return result;
  }

  /// 添加到指定弹道
  void addTo(BarrageItem item, int index) {
    assert(index >= 0);
    assert(() {
      if (index >= _channels.length) {
        throw RangeError.index(index, _channels, "index", null, _channels.length);
      }
      return true;
    }());
    _channels[index].add(item);
  }

  /// 移除某条弹幕
  void removeFrom(BarrageItem item, int index) {
    if (index < 0 || index >= _channels.length) {
      return;
    }
    _channels[index].remove(item);
  }

  void clear() {
    _channels.forEach((channel) {
      channel.clear();
    });
  }

  /// 清空某条弹道
  void clearOne(int index) {
    if (index < 0 || index >= _channels.length) {
      return;
    }
    _channels[index].clear();
  }

  /// 暂停所有弹道
  void pause() {
    _channels.forEach((channel) {
      channel.pause();
    });
  }

  void play() {
    _channels.forEach((channel) {
      channel.play();
    });
  }

  /// 暂停某条弹道
  void pauseOne(int index) {
    if (index < 0 || index >= _channels.length) {
      return;
    }
    _channels[index].pause();
  }

  void playOne(int index) {
    if (index < 0 || index >= _channels.length) {
      return;
    }
    _channels[index].play();
  }

  /// 暂停某条弹幕
  void pauseItem(BarrageItem item, int index) {
    if (index < 0 || index >= _channels.length) {
      return;
    }
    _channels[index].pauseOne(item);
  }

  void playItem(BarrageItem item, int index) {
    if (index < 0 || index >= _channels.length) {
      return;
    }
    _channels[index].playOne(item);
  }

  /*void dispose() {
    _channels.forEach((channel) {
      channel.dispose();
    });
  }*/

  List<Widget> get _barrageChannels => _channels.map((e) => BarrageChannel(e)).toList();

  Widget buildView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _barrageChannels,
    );
  }
}
