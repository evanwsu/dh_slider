import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'indicator.dart';

///@author Evan
///@since 2021/1/12
///@describe:

/// 自定义Track
class DHSliderTrackShape extends SliderTrackShape {
  /// track背景图片[image]
  final ui.Image? image;

  /// track是否左对齐thumb中心
  /// true track左对齐thumb中心
  /// false track左对齐thumb左
  final bool alignThumbCenter;

  final List<String>? marks;

  /// 可用状态左侧mark样式
  final TextStyle? activeMarkStyle;

  /// 可用状态右侧mark样式
  final TextStyle? inactiveMarkStyle;

  /// 不可用状态左侧mark样式
  final TextStyle? disabledActiveMarkStyle;

  /// 不可用状态右侧mark样式
  final TextStyle? disabledInactiveMarkStyle;

  const DHSliderTrackShape({
    this.image,
    this.alignThumbCenter = true,
    this.marks,
    this.activeMarkStyle,
    this.inactiveMarkStyle,
    this.disabledActiveMarkStyle,
    this.disabledInactiveMarkStyle,
  }) : assert(marks == null || marks.length > 1);

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double thumbSize =
        sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx + thumbSize / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - thumbSize;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    if (image == null) {
      // 绘制背景不使用图片
      if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
        return;
      }

      final ColorTween activeTrackColorTween = ColorTween(
          begin: sliderTheme.disabledActiveTrackColor,
          end: sliderTheme.activeTrackColor);
      final ColorTween inactiveTrackColorTween = ColorTween(
          begin: sliderTheme.disabledInactiveTrackColor,
          end: sliderTheme.inactiveTrackColor);

      final Paint activePaint = Paint()
        ..color = activeTrackColorTween.evaluate(enableAnimation)!;
      final Paint inactivePaint = Paint()
        ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

      final Paint leftTrackPaint;
      final Paint rightTrackPaint;
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

      final leftTrackArcRect = Rect.fromLTWH(
          trackRect.left - (alignThumbCenter ? 0 : trackRect.height / 2),
          trackRect.top,
          trackRect.height,
          trackRect.height);
      final leftTrackSegment = Rect.fromLTRB(
          leftTrackArcRect.left + trackRect.height / 2,
          trackRect.top,
          thumbCenter.dx,
          trackRect.bottom);

      if (!leftTrackSegment.isEmpty)
        context.canvas.drawArc(
            leftTrackArcRect, math.pi / 2, math.pi, false, leftTrackPaint);

      if (!leftTrackSegment.isEmpty)
        context.canvas.drawRect(leftTrackSegment, leftTrackPaint);

      final Rect rightTrackArcRect = Rect.fromLTWH(
          trackRect.right -
              (alignThumbCenter ? trackRect.height : trackRect.height / 2),
          trackRect.top,
          trackRect.height,
          trackRect.height);

      final Rect rightTrackSegment = Rect.fromLTRB(
          thumbCenter.dx,
          trackRect.top,
          rightTrackArcRect.left + trackRect.height / 2,
          trackRect.bottom);

      if (!rightTrackSegment.isEmpty)
        context.canvas.drawArc(
            rightTrackArcRect, -math.pi / 2, math.pi, false, rightTrackPaint);

      if (!rightTrackSegment.isEmpty)
        context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
    } else {
      final Rect src = Rect.fromLTRB(
          0, 0, image!.width.toDouble(), image!.height.toDouble());
      Rect dst = trackRect;
      if (!alignThumbCenter) {
        final double thumbSize = sliderTheme.thumbShape!
            .getPreferredSize(isEnabled, isDiscrete)
            .width;

        dst = Rect.fromLTRB(trackRect.left - thumbSize / 2, trackRect.top,
            trackRect.right + thumbSize / 2, trackRect.bottom);
      }
      if (!src.isEmpty && !dst.isEmpty)
        context.canvas
            .drawImageRect(image!, src, dst, Paint()..isAntiAlias = true);
    }

    if (marks != null && marks!.isNotEmpty) {
      final markPainter = TextPainter(textDirection: textDirection);
      final length = marks!.length;
      double width = trackRect.width / (length - 1);
      for (int i = 0; i < length; i++) {
        // 偏差4ui效果更好些
        var x = width * i + trackRect.height / 2 - 4;
        var markStyle;
        if (x <= thumbCenter.dx) {
          markStyle = isEnabled ? activeMarkStyle : disabledActiveMarkStyle;
        } else {
          markStyle = isEnabled ? inactiveMarkStyle : disabledInactiveMarkStyle;
        }
        markPainter
          ..text = TextSpan(text: marks?[i], style: markStyle)
          ..layout();
        markPainter.paint(
            context.canvas,
            Offset(x - markPainter.width / 2,
                thumbCenter.dy - markPainter.height / 2));
      }
    }
  }
}

/// 自定义Thumb
class DHThumbShape extends SliderComponentShape {
  /// 设置enabled状态thumb半径
  final double enabledThumbRadius;

  /// 设置disabled状态thumb半径
  final double _disabledThumbRadius;
  final ui.Image? image;
  final BorderSide borderSide;
  final String? label;
  final TextStyle? labelStyle;

  const DHThumbShape({
    required this.borderSide,
    this.image,
    this.label,
    this.labelStyle,
    this.enabledThumbRadius = 10.0,
    double? disabledThumbRadius,
  }) : _disabledThumbRadius = disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
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
          ..color = colorTween.evaluate(enableAnimation)!,
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
      // thumb use image
      Rect dst = Rect.fromCircle(center: center, radius: radius);
      Rect src = Rect.fromLTRB(
          0, 0, image!.width.toDouble(), image!.height.toDouble());
      context.canvas
          .drawImageRect(image!, src, dst, Paint()..isAntiAlias = true);
    }
    // draw a label in the center of the thumb
    if (label != null) {
      final painter = TextPainter(
          textDirection: textDirection,
          text: TextSpan(text: label, style: labelStyle))
        ..layout();
      painter.paint(
          context.canvas,
          Offset(
              center.dx - painter.width / 2, center.dy - painter.height / 2));
    }
  }
}

/// 自定义数值指示器形状 参考[RectangularSliderValueIndicatorShape]
class DHIndicatorShape extends SliderComponentShape {
  final DHIndicatorPathPainter _pathPainter;
  final IndicatorStyle? style;

  DHIndicatorShape(Indicator indicator, this.style)
      : this._pathPainter = DHIndicatorPathPainter(indicator);

  @override
  Size getPreferredSize(
    bool isEnabled,
    bool isDiscrete, {
    TextPainter? labelPainter,
    double? textScaleFactor,
  }) {
    assert(labelPainter != null);
    assert(textScaleFactor != null && textScaleFactor >= 0);
    return _pathPainter.getPreferredSize(labelPainter!, textScaleFactor!);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation.value;
    _pathPainter.paint(
      parentBox: parentBox,
      canvas: canvas,
      center: center,
      scale: scale,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      style: style,
    );
  }
}

class DHIndicatorPathPainter {
  static const double _minLabelWidth = 16.0;
  static const double _elevation = 2.0;

  Indicator indicator;

  DHIndicatorPathPainter(this.indicator);

  double getHorizontalShift({
    required RenderBox parentBox,
    required Offset center,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    required double scale,
  }) {
    assert(!sizeWithOverflow.isEmpty);

    const double edgePadding = 8.0;
    final double rectangleWidth =
        _upperRectangleWidth(labelPainter, scale, textScaleFactor);
    // 获取全局坐标
    final Offset globalCenter = parentBox.localToGlobal(center);

    // The rectangle must be shifted towards the center so that it minimizes the
    // chance of it rendering outside the bounds of the render box. If the shift
    // is negative, then the lobe is shifted from right to left, and if it is
    // positive, then the lobe is shifted from left to right.
    final double overflowLeft =
        math.max(0, rectangleWidth / 2 - globalCenter.dx + edgePadding);
    final double overflowRight = math.max(
        0,
        rectangleWidth / 2 -
            (sizeWithOverflow.width - globalCenter.dx - edgePadding));

    if (rectangleWidth < sizeWithOverflow.width) {
      return overflowLeft - overflowRight;
    } else if (overflowLeft - overflowRight > 0) {
      return overflowLeft - (edgePadding * textScaleFactor);
    } else {
      return -overflowRight + (edgePadding * textScaleFactor);
    }
  }

  Size getPreferredSize(
    TextPainter labelPainter,
    double textScaleFactor,
  ) {
    return Size(
      _upperRectangleWidth(labelPainter, 1, textScaleFactor),
      labelPainter.height + indicator.labelPadding,
    );
  }

  void paint({
    required RenderBox parentBox,
    required Canvas canvas,
    required Offset center,
    required double scale,
    required TextPainter labelPainter,
    required double textScaleFactor,
    required Size sizeWithOverflow,
    IndicatorStyle? style,
  }) {
    if (scale == 0.0) {
      return;
    }
    assert(!sizeWithOverflow.isEmpty);

    bool reverse = style?.reverse ?? false;

    final double rectangleWidth =
        _upperRectangleWidth(labelPainter, scale, textScaleFactor);
    final double horizontalShift = (reverse ? -1 : 1) *
        getHorizontalShift(
          parentBox: parentBox,
          center: center,
          labelPainter: labelPainter,
          textScaleFactor: textScaleFactor,
          sizeWithOverflow: sizeWithOverflow,
          scale: scale,
        );
    // 三角箭头高度
    final _triangleHeight = indicator.triangleHeight;
    // 计算rect区域高度(label文本高度 + label上下padding)
    final double rectHeight = labelPainter.height + indicator.labelPadding;
    // 定义 rect区域坐标
    final Rect upperRect = Rect.fromLTWH(
      -rectangleWidth / 2 + horizontalShift,
      -_triangleHeight - rectHeight,
      rectangleWidth,
      rectHeight,
    );

    final Path trianglePath = Path()
      ..lineTo(-_triangleHeight, -_triangleHeight)
      ..lineTo(_triangleHeight, -_triangleHeight)
      ..close();
    final Paint fillPaint = Paint()
      ..color = style?.backgroundColor ?? Colors.white;
    final RRect upperRRect = RRect.fromRectAndRadius(
        upperRect, Radius.circular(indicator.rectRadius));
    trianglePath.addRRect(upperRRect);

    double radians = style?.angle ?? 0;

    canvas.save();
    // 旋转indicator
    canvas.translate(center.dx, center.dy);
    canvas.rotate(radians);
    canvas.translate(-center.dx, -center.dy);

    // 根据thumb位置来平移
    // offsetY表示三角箭头和slider的距离
    canvas.translate(center.dx, center.dy - indicator.offsetY);
    canvas.scale(scale, scale);

    // 阴影绘制
    Color? shadowColor = style?.shadowColor;
    if (shadowColor != null) {
      double elevation = style?.elevation ?? _elevation;
      canvas.drawShadow(trianglePath, shadowColor, elevation, true);
    }

    Color? strokeColor = style?.strokeColor;
    if (strokeColor != null) {
      final Paint strokePaint = Paint()
        ..color = strokeColor
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawPath(trianglePath, strokePaint);
    }
    canvas.drawPath(trianglePath, fillPaint);

    // The label text is centered within the value indicator.
    // 整个提示框高度
    final double bottomTipToUpperRectTranslateY =
        -indicator.triangleHeight - upperRect.height;
    canvas.translate(0, bottomTipToUpperRectTranslateY);
    final Offset targetOffset = Offset(horizontalShift, upperRect.height / 2);
    final Offset currentOffset =
        Offset(labelPainter.width / 2, labelPainter.height / 2);
    final Offset labelOffset = targetOffset - currentOffset;

    // 旋转内容
    if (reverse) {
      canvas.translate(targetOffset.dx, targetOffset.dy);
      canvas.rotate(math.pi);
      canvas.translate(-targetOffset.dx, -targetOffset.dy);
    }

    labelPainter.paint(canvas, labelOffset);

    canvas.restore();
  }

  double _upperRectangleWidth(
      TextPainter labelPainter, double scale, double textScaleFactor) {
    final double unscaledWidth =
        math.max(_minLabelWidth * textScaleFactor, labelPainter.width) +
            indicator.labelPadding * 2;
    return unscaledWidth * scale;
  }
}
