import 'dart:ui';

import 'package:flutter/material.dart';

///@author Evan
///@since 2021/1/13
///@describe:

class Indicator {
  /// 标签填充
  final double labelPadding;

  /// 底部三角形高度
  final double triangleHeight;

  /// 三角形在Y轴向上偏移高度
  final double offsetY;

  /// 圆角半径
  final double rectRadius;

  const Indicator({
    this.labelPadding = 8.0,
    this.triangleHeight = 8.0,
    this.offsetY = 14.0,
    this.rectRadius = 6.0,
  })  : assert(labelPadding != null),
        assert(triangleHeight != null),
        assert(offsetY != null),
        assert(rectRadius != null);
}

class IndicatorStyle {
  /// 背景颜色
  final Color backgroundColor;
  /// 边框颜色
  final Color strokeColor;
  /// 阴影颜色
  final Color shadowColor;
  /// z轴阴影高度
  final double elevation;
  /// 指示器上下反转
  /// 显示效果会因angle改变
  final bool reverse;
  /// 顺时针旋转角度, 弧度单位
  /// 默认.0 12点钟方向, 即正上方
  /// 一般来说滑条是水平方向滑动, 部分情况需要竖直滑动的滑条,
  /// 为了兼容不同方向的滑条，所以需要设置指示器旋转。
  final double angle;

  const IndicatorStyle({
    this.backgroundColor,
    this.strokeColor,
    this.shadowColor,
    this.elevation,
    this.reverse = false,
    this.angle = .0
  });
}
