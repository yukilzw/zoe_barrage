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
    "表白我允儿",
    "允允允允允允允允允允儿",
    "보고 싶어~~",
    "(づ￣3￣)づ╭❤～",
    "把漂亮打在公屏上",
    "纯路人，请问这是仙女吗？？",
    "Yooooooooooona~",
    "喜欢看你跳舞",
    "什么时候开演唱会呀",
    "그게 사랑 일지 도 몰라",
    "missing you",
    "林大俊~~",
    "哇。。😯！！",
    "林允儿=永远滴神😊"
    "炒鸡好看的小姐姐",
    "跳的真好噢..很🉑️",
    "新剧马上就要开播了，支持啊",
    "又要上热搜了吗"
  ];

  String get randomWord => barrageMock[Random().nextInt(barrageMock.length)];

  Icon get randomIcon => _icons[Random().nextInt(_icons.length)];

  Color randomTextColor() {
    return Random().nextInt(10) < 9 ? Colors.white : Colors.yellow;
  }

  BarrageData() {
    int count = 0;
    while (count < 9) {
      _icons.add(Icon(Icons.favorite, color: Colors.transparent));
      count++;
    }
  }
}
