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
    "纯二次元lsp，请问这是路人吗",
    "摇起来家人们",
    "不会真的有人不喜欢黑si吧",
    "这波啊~这波是没人顶得住啊",
    "大大大大。。",
    "求求换一套衣服吧~~",
    "66666666",
    "？？？？",
    "即刻开启护眼模式",
    "贤者模式，素然无味",
    "想看真人版的cos",
    "冲冲冲冲冲冲！",
    "给在座的死宅们安排的明明白白",
    "把害怕打在共屏上",
    "双手打字..以示清白",
    "电动马达扭起来~",
    "这腿不错",
    "我好了兄弟们"
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