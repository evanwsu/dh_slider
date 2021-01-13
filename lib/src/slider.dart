import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'indicator.dart';
import 'shapes.dart';

///@author Evan
///@since 2020-03-09
///@describe: 滑动条控件
///
/// 设置thumb和track有两种形态
/// 第一种使用xxColor属性设置，具体使用见示例。
/// 第二种使用trackImage和thumbImage属性设置。
/// xxColor和xxImage设置方式互斥。
/// 使用xxImage属性设置,相对应的xxColor应该设置transparent, 具体情况可根据需求来定。
///
/// 使用xxColor方式，直接配置DHSlider部分即可，使用xxImage方式较xxColor特殊些，示例如下：
/// 1.获取ui.Image
///  Future<List<ui.Image>> getImageFuture(){
///    return Future.wait([
///      ImageLoader.loadImageByProvider(AssetImage(FanResourceUtil.getImagePath("slider_bck"))),
///      ImageLoader.loadImageByProvider(AssetImage(FanResourceUtil.getImagePath("thumb")))
///    ]);
///  }
///  2.使用FutureBuilder创建DHSlider。
/// 使用实例如下：
///    Widget dhSlider = FutureBuilder(
///      future: sliderFuture,
///      builder: (BuildContext context, AsyncSnapshot<List<ui.Image>> snapshot){
///      List<ui.Image> images = snapshot.data;
///      return DHSlider(
///          value: value,
///          trackHeight: 13,
///          width: double.infinity,
///          height: 40,
///          activeTrackColor: Colors.red,
///          inactiveTrackColor: Colors.yellow,
///          thumbColor: Colors.transparent,
///          disabledThumbColor: Colors.transparent,
///          disabled: disabled,
///          enabledThumbRadius: 17,
///          margin: EdgeInsets.symmetric(horizontal: 10),
///          thumbBorderSide: BorderSide(color: Colors.red, ),
///          trackImage: images?.first,
///          thumbImage: images?.last,
///          onChanged:  (value) {
///            this.setState(() {
///              this.value = value;
///            });
///          },
///          min: 1,
///          max: 100,
///        );
///

class DHSlider extends StatelessWidget {
  static const _indicatorTextStyle =
      TextStyle(color: Colors.black, fontSize: 14.0);

  /// 轨道高度
  final double trackHeight;

  /// 可用状态左侧轨道颜色
  final Color activeTrackColor;

  /// 可用状态右侧轨道颜色
  final Color inactiveTrackColor;

  /// 不可用状态左侧轨道颜色
  final Color disabledActiveTrackColor;

  /// 不可用状态右侧轨道颜色
  final Color disabledInactiveTrackColor;

  /// 可用状态thumb颜色
  final Color thumbColor;

  /// 不可用状态thumb 颜色
  final Color disabledThumbColor;

  /// 当前滑条值
  final double value;

  /// disabled true 时，控件不可用
  final bool disabled;

  /// 滑条最大值
  final double min;

  /// 滑条最小值
  final double max;

  /// 滑条thumb形状, 默认[DHThumbShape]
  final SliderComponentShape thumbShape;

  /// 滑条轨道形状，默认圆角矩形[DHSliderTrackShape]
  final SliderTrackShape trackShape;

  /// 滑条指示器形状，默认[DHIndicatorShape]
  final SliderComponentShape indicatorShape;

  /// 滑动开始回调
  final ValueChanged<double> onChangeStart;

  /// 滑动结束回调
  final ValueChanged<double> onChangeEnd;

  /// 滑动值改变回调
  final ValueChanged<double> onChanged;

  /// 是否在滑动控件内
  final bool inScroll;

  /// 滑条刻度分为具体份数
  final int divisions;

  /// slider气泡标签
  final String label;

  /// 焦点节点
  final FocusNode focusNode;

  /// 是否自动获取焦点
  final bool autoFocus;

  /// 设置显示器样式
  final ShowValueIndicator showValueIndicator;

  /// 指示器文本样式
  final TextStyle indicatorTextStyle;

  /// 控件宽度
  final double width;

  /// 控件高度
  final double height;

  /// 控件背景颜色
  final Color backgroundColor;

  /// 控件填充
  final EdgeInsetsGeometry padding;

  /// 控件边距
  final EdgeInsetsGeometry margin;

  DHSlider({
    Key key,
    SliderTrackShape trackShape,
    ui.Image trackImage,
    this.trackHeight,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.disabledActiveTrackColor,
    this.disabledInactiveTrackColor,
    this.thumbColor,
    this.disabledThumbColor,
    double enabledThumbRadius = 12.0,
    double disabledThumbRadius = 12.0,
    ui.Image thumbImage,
    SliderComponentShape thumbShape,
    SliderComponentShape indicatorShape,
    Indicator indicator,
    IndicatorStyle indicatorStyle,
    BorderSide thumbBorderSide,
    @required this.value,
    this.disabled = false,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.focusNode,
    this.autoFocus = false,
    this.showValueIndicator,
    this.indicatorTextStyle,
    this.onChangeStart,
    this.onChangeEnd,
    this.onChanged,
    this.width,
    this.height,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.inScroll = true,
  })  : assert(value != null),
        assert(min != null),
        assert(max != null),
        assert(min <= max),
        assert(value >= min && value <= max),
        assert(disabled != null),
        this.trackShape = trackShape ?? DHSliderTrackShape(image: trackImage),
        this.thumbShape = thumbShape ??
            DHThumbShape(
                enabledThumbRadius: enabledThumbRadius,
                disabledThumbRadius: disabledThumbRadius,
                borderSide: thumbBorderSide ?? BorderSide.none,
                image: thumbImage),
        this.indicatorShape =
            indicatorShape ?? DHIndicatorShape(indicator, indicatorStyle),
        super(key: key);

  /// 使用track 和 thumb 图片
  DHSlider.image({
    Key key,
    double trackHeight,
    @required ui.Image trackImage,
    double enabledThumbRadius = 12.0,
    double disabledThumbRadius = 12.0,
    @required ui.Image thumbImage,
    @required double value,
    bool disabled = false,
    double min = 0.0,
    double max = 1.0,
    int divisions,
    String label,
    FocusNode focusNode,
    bool autoFocus = false,
    SliderComponentShape indicatorShape,
    Indicator indicator,
    IndicatorStyle indicatorStyle,
    ShowValueIndicator showValueIndicator,
    TextStyle indicatorTextStyle,
    ValueChanged<double> onChangeStart,
    ValueChanged<double> onChangeEnd,
    ValueChanged<double> onChanged,
    double width,
    double height,
    Color backgroundColor,
    EdgeInsetsGeometry padding,
    EdgeInsetsGeometry margin,
    bool inScroll,
  }) : this(
          key: key,
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: label,
          focusNode: focusNode,
          autoFocus: autoFocus,
          onChangeStart: onChangeStart,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
          trackImage: trackImage,
          trackHeight: trackHeight,
          activeTrackColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          disabledActiveTrackColor: Colors.transparent,
          disabledInactiveTrackColor: Colors.transparent,
          thumbImage: thumbImage,
          thumbColor: Colors.transparent,
          disabledThumbColor: Colors.transparent,
          enabledThumbRadius: enabledThumbRadius,
          disabledThumbRadius: disabledThumbRadius,
          indicatorShape: indicatorShape,
          indicator: indicator,
          indicatorStyle: indicatorStyle,
          showValueIndicator: showValueIndicator,
          indicatorTextStyle: indicatorTextStyle,
          disabled: disabled,
          width: width,
          height: height,
          backgroundColor: backgroundColor,
          padding: padding,
          margin: margin,
          inScroll: inScroll,
        );

  @override
  Widget build(BuildContext context) {
    Widget slider = inScroll
        ? FixSlider(
            value: value,
            min: min,
            max: max,
            label: label,
            focusNode: focusNode,
            autoFocus: autoFocus,
            divisions: divisions,
            onChangeStart: onChangeStart,
            onChanged: disabled ? null : onChanged,
            onChangeEnd: onChangeEnd,
          )
        : Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            focusNode: focusNode,
            autofocus: autoFocus,
            onChangeStart: onChangeStart,
            onChanged: disabled ? null : onChanged,
            onChangeEnd: onChangeEnd,
          );
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      padding: padding,
      margin: margin,
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: trackHeight,
          trackShape: trackShape,
          activeTrackColor: activeTrackColor,
          inactiveTrackColor: inactiveTrackColor,
          disabledActiveTrackColor: disabledActiveTrackColor,
          disabledInactiveTrackColor: disabledInactiveTrackColor,
          thumbColor: thumbColor,
          disabledThumbColor: disabledThumbColor,
          thumbShape: thumbShape,
          overlayShape: SliderComponentShape.noOverlay,
          tickMarkShape: SliderTickMarkShape.noTickMark,
          valueIndicatorShape: indicatorShape,
          showValueIndicator: showValueIndicator,
          valueIndicatorTextStyle: indicatorTextStyle ?? _indicatorTextStyle,
        ),
        child: slider,
      ),
    );
  }
}

/// 修复Slider滑动问题
class FixSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;

  /// 焦点节点
  final FocusNode focusNode;

  /// 是否自动获取焦点
  final bool autoFocus;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final ValueChanged<double> onChanged;

  FixSlider({
    @required this.value,
    this.min,
    this.max,
    this.onChangeStart,
    this.onChanged,
    this.onChangeEnd,
    this.divisions,
    this.label,
    this.focusNode,
    this.autoFocus,
  });

  @override
  _FixSliderState createState() => _FixSliderState();
}

class _FixSliderState extends State<FixSlider> {
  static const duration = Duration(milliseconds: 100);
  DateTime lastOnChangeEnd;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: widget.value,
      min: widget.min,
      max: widget.max,
      label: widget.label,
      divisions: widget.divisions,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      onChangeStart: (double value) {
        if (lastOnChangeEnd == null ||
            DateTime.now().difference(lastOnChangeEnd) > duration) {
          widget.onChangeStart?.call(value);
        } else {
          _timer?.cancel();
        }
      },
      onChanged: widget.onChanged,
      onChangeEnd: (double value) {
        lastOnChangeEnd = DateTime.now();
        delayOnChangeEnd(() => widget.onChangeEnd?.call(value));
      },
    );
  }

  void delayOnChangeEnd(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
