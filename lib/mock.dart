import 'dart:math';

import 'package:flutter/material.dart';

class BarrageData {
  static final List<Icon> _icons = <Icon>[
    Icon(Icons.favorite, color: Color(0xFFF44336)),
    Icon(Icons.sentiment_dissatisfied, color: Colors.green),
    Icon(Icons.sentiment_satisfied_alt, color: Colors.yellow),
    Icon(Icons.flash_on, color: Colors.purple),
    Icon(Icons.border_color, color: Colors.orange),
    Icon(Icons.brightness_3, color: Colors.blue),
    Icon(Icons.attach_money, color: Color(0xFFD15FEE)),
    Icon(Icons.favorite_border, color: Color(0xFFF44336)),
    Icon(Icons.flare, color: Color(0xFF66FF33)),
  ];

  static const List<String> barrageMock = <String>[
    "表白我U",
    "IUIUIUIUIU",
    "보고 싶어~~",
    "(づ￣3￣)づ╭❤～",
    "把公屏打在漂亮上",
    "纯路人，请问这是仙女吗？？",
    "IUuuuuuuuuuuuu~",
    "喜欢听你唱歌",
    "什么时候开演唱会呀",
    "그게 사랑 일지 도 몰라"
    "missing you",
    "纳德鲁酒店~~",
    "哇。。！！",
    "嗓音超棒小姐姐",
    "人美歌甜"
  ];

  String get randomWord => barrageMock[Random().nextInt(barrageMock.length)];

  Icon get randomIcon => _icons[Random().nextInt(_icons.length)];

  Color randomTextColor() {
    return Random().nextInt(10) < 9 ? Colors.white : Colors.yellow;
  }

  BarrageData() {
    int count = 0;
    while(count < 9) {
      _icons.add(Icon(Icons.favorite, color: Colors.transparent));
      count++;
    }
  }
}