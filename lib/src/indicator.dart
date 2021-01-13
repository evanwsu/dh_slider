import 'dart:ui';

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
  final Color backgroundColor;
  final Color strokeColor;
  final Color shadowColor;
  final double elevation;

  const IndicatorStyle({
    this.backgroundColor,
    this.strokeColor,
    this.shadowColor,
    this.elevation,
  });
}
