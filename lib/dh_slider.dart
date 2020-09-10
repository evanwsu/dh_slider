library dh_slider;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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

  /// 滑条thumb形状
  final SliderComponentShape thumbShape;

  /// 滑条轨道形状，默认圆角矩形
  final SliderTrackShape trackShape;

  /// 滑动开始回调
  final ValueChanged<double> onChangeStart;

  /// 滑动结束回调
  final ValueChanged<double> onChangeEnd;

  /// 滑动值改变回调
  final ValueChanged<double> onChanged;

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

  /// 是否在滑动控件内
  final bool inScroll;

  /// divisions
  final int divisions;

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
    BorderSide thumbBorderSide,
    @required this.value,
    this.disabled = false,
    this.min = 0.0,
    this.max = 1.0,
    this.onChangeStart,
    this.onChangeEnd,
    this.onChanged,
    this.width,
    this.height,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.divisions,
    this.inScroll = true
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
        super(key: key);

  /// 使用track 和 thumb 图片
  DHSlider.image(
      {Key key,
        double trackHeight,
        @required ui.Image trackImage,
        double enabledThumbRadius = 12.0,
        double disabledThumbRadius = 12.0,
        @required ui.Image thumbImage,
        @required double value,
        bool disabled = false,
        double min = 0.0,
        double max = 1.0,
        ValueChanged<double> onChangeStart,
        ValueChanged<double> onChangeEnd,
        ValueChanged<double> onChanged,
        double width,
        double height,
        Color backgroundColor,
        EdgeInsetsGeometry padding,
        EdgeInsetsGeometry margin,
        bool inScroll})
      : this(
      key: key,
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
      disabled: disabled,
      min: min,
      max: max,
      onChangeStart: onChangeStart,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
      value: value,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      inScroll: inScroll
  );

  @override
  Widget build(BuildContext context) {
    Widget slider = SliderTheme(
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
            valueIndicatorShape: SliderComponentShape.noThumb),
        child: inScroll ? FixSlider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChangeStart: onChangeStart,
          onChanged: disabled ? null : onChanged,
          onChangeEnd: onChangeEnd,)
            : Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChangeStart: onChangeStart,
          onChanged: disabled ? null : onChanged,
          onChangeEnd: onChangeEnd,
        ));
    return Container(
        width: width,
        height: height,
        color: backgroundColor,
        padding: padding,
        margin: margin,
        child: slider
    );
  }
}

/// 修复Slider滑动问题
class FixSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
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
      divisions: widget.divisions,
      value: widget.value,
      min: widget.min,
      max: widget.max,
      onChangeStart: (double value){
        if(lastOnChangeEnd == null ||
            DateTime.now().difference(lastOnChangeEnd) > duration){
          widget.onChangeStart?.call(value);
        }else{
          _timer?.cancel();
        }
      },
      onChanged: widget.onChanged,
      onChangeEnd: (double value){
        lastOnChangeEnd = DateTime.now();
        delayOnChangeEnd((){
          widget.onChangeEnd?.call(value);
        });
      },
    );
  }

  void delayOnChangeEnd(VoidCallback action){
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}


/// 自定义Track
class DHSliderTrackShape extends SliderTrackShape {
  final ui.Image image;

  const DHSliderTrackShape({this.image});

  @override
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double thumbSize =
        sliderTheme.thumbShape.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx + thumbSize / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - thumbSize;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {RenderBox parentBox,
        SliderThemeData sliderTheme,
        Animation<double> enableAnimation,
        TextDirection textDirection,
        Offset thumbCenter,
        bool isDiscrete = false,
        bool isEnabled = false}) {
    if (image == null) {
      if (sliderTheme.trackHeight <= 0) {
        return;
      }

      final ColorTween activeTrackColorTween = ColorTween(
          begin: sliderTheme.disabledActiveTrackColor,
          end: sliderTheme.activeTrackColor);
      final ColorTween inactiveTrackColorTween = ColorTween(
          begin: sliderTheme.disabledInactiveTrackColor,
          end: sliderTheme.inactiveTrackColor);
      final Paint activePaint = Paint()
        ..color = activeTrackColorTween.evaluate(enableAnimation);
      final Paint inactivePaint = Paint()
        ..color = inactiveTrackColorTween.evaluate(enableAnimation);
      Paint leftTrackPaint;
      Paint rightTrackPaint;
      switch (textDirection) {
        case TextDirection.ltr:
          leftTrackPaint = activePaint;
          rightTrackPaint = inactivePaint;
          break;
        case TextDirection.rtl:
          leftTrackPaint = inactivePaint;
          rightTrackPaint = activePaint;
          break;
      }

      final Rect trackRect = getPreferredRect(
        parentBox: parentBox,
        offset: offset,
        sliderTheme: sliderTheme,
        isEnabled: isEnabled,
        isDiscrete: isDiscrete,
      );

      final Rect leftTrackArcRect = Rect.fromLTWH(
          trackRect.left, trackRect.top, trackRect.height, trackRect.height);

      final Size thumbSize =
      sliderTheme.thumbShape.getPreferredSize(isEnabled, isDiscrete);
      final Rect leftTrackSegment = Rect.fromLTRB(
          trackRect.left + trackRect.height / 2,
          trackRect.top,
          thumbCenter.dx - thumbSize.width / 2,
          trackRect.bottom);

      if (!leftTrackSegment.isEmpty)
        context.canvas.drawArc(
            leftTrackArcRect, math.pi / 2, math.pi, false, leftTrackPaint);

      if (!leftTrackSegment.isEmpty)
        context.canvas.drawRect(leftTrackSegment, leftTrackPaint);

      final Rect rightTrackArcRect = Rect.fromLTWH(
          trackRect.right - trackRect.height,
          trackRect.top,
          trackRect.height,
          trackRect.height);

      final Rect rightTrackSegment = Rect.fromLTRB(
          thumbCenter.dx + thumbSize.width / 2,
          trackRect.top,
          trackRect.right - trackRect.height / 2,
          trackRect.bottom);

      if (!rightTrackSegment.isEmpty)
        context.canvas.drawArc(
            rightTrackArcRect, -math.pi / 2, math.pi, false, rightTrackPaint);

      if (!rightTrackSegment.isEmpty)
        context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
    } else {
      final Rect dst = getPreferredRect(
        parentBox: parentBox,
        offset: offset,
        sliderTheme: sliderTheme,
        isEnabled: isEnabled,
        isDiscrete: isDiscrete,
      );
      Rect src =
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble());
      if (!src.isEmpty && !dst.isEmpty)
        context.canvas
            .drawImageRect(image, src, dst, Paint()..isAntiAlias = true);
    }
  }
}

/// 自定义Thumb
class DHThumbShape extends SliderComponentShape {
  const DHThumbShape(
      {this.enabledThumbRadius = 10.0,
        this.disabledThumbRadius,
        this.image,
        this.borderSide})
      : assert(borderSide != null);

  final double enabledThumbRadius;
  final double disabledThumbRadius;
  final ui.Image image;
  final BorderSide borderSide;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double> activationAnimation,
        @required Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        @required SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
        double textScaleFactor,
        Size sizeWithOverflow,
      }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    double radius = radiusTween.evaluate(enableAnimation);

    if (image == null) {
      final ColorTween colorTween = ColorTween(
        begin: sliderTheme.disabledThumbColor,
        end: sliderTheme.thumbColor,
      );

      Paint paint = Paint()..isAntiAlias = true;
      context.canvas.drawCircle(
        center,
        radius,
        paint
          ..style = PaintingStyle.fill
          ..color = colorTween.evaluate(enableAnimation),
      );
      // 绘制边框
      if (borderSide.style != BorderStyle.none) {
        context.canvas.drawCircle(
            center,
            radius,
            paint
              ..style = PaintingStyle.stroke
              ..color = borderSide.color
              ..strokeWidth = borderSide.width);
      }
    } else {
      Rect dst = Rect.fromCircle(center: center, radius: radius);
      Rect src =
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble());
      context.canvas
          .drawImageRect(image, src, dst, Paint()..isAntiAlias = true);
    }
  }
}
