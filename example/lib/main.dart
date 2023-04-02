import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:dh_slider/dh_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DHSlider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SliderPage(title: 'DHSlider'),
    );
  }
}

class SliderPage extends StatefulWidget {
  SliderPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double slider = 0.0;

  Future<ui.Image>? sliderFuture;

  @override
  void initState() {
    super.initState();
    sliderFuture = getImageFuture(
        AssetImage("images/slider_bck.png"),
       AssetImage("images/.png"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: <Widget>[
          _getIndicatorSlider(),
          _getTrackImageSlider(),
          _getCustomSlider(),
        ],
      ),
    );
  }

  /// thumb显示气泡指示器样式
  Widget _getIndicatorSlider() {
    return DHSlider(
        thumbBorderSide: BorderSide.none,
        thumbColor: Colors.redAccent,
        trackHeight: 4,
        margin: EdgeInsets.only(left: 10, right: 10, top: 80),
        value: slider,
        label: "$slider",
        indicator: Indicator(rectRadius: 10, labelPadding: 18),
        indicatorStyle: IndicatorStyle(
            backgroundColor: Colors.red,
            shadowColor: Colors.black,
            elevation: 12.0,
            reverse: true,
            angle: pi),
        showValueIndicator: ShowValueIndicator.always,
        onChangeEnd: (double value) {
          print("onChangeEnd: $value");
          this.setState(() {
            slider = value;
          });
        },
        onChanged: (double value) {
          this.setState(() {
            slider = value;
          });
          print("onChanged: $value");
        });
  }

  /// track 是图片背景样式
  Widget _getTrackImageSlider() {
    return FutureBuilder(
      future: sliderFuture,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        return DHSlider(
          value: slider,
          trackHeight: 12,
          trackShape: DHSliderTrackShape(image: snapshot.data),
          activeTrackColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          disabledActiveTrackColor: Colors.transparent,
          disabledInactiveTrackColor: Colors.transparent,
          thumbColor: Colors.yellowAccent.withOpacity(0.2),
          disabledThumbColor: Colors.white,
          enabledThumbRadius: 12,
          margin: EdgeInsets.only(left: 10, right: 10, top: 80),
          thumbBorderSide: BorderSide(
            width: 0.6,
            color: Colors.red,
          ),
          onChanged: (value) {
            print("onChange: $value");
            this.setState(() => slider = value);
          },
          onChangeEnd: (value) {
            print("onChangeEnd: $value");
            this.setState(() => slider = value);
          },
          min: 0,
          max: 1,
        );
      },
    );
  }

  /// 自定义样式
  Widget _getCustomSlider() {
    return DHSlider(
      margin: const EdgeInsets.only(top: 80),
      value: slider,
      trackHeight: 46,
      activeTrackColor: Color(0xFFFAAA00),
      inactiveTrackColor: Color(0xFFF1F1F1),
      thumbColor: Colors.white,
      disabledThumbColor: Colors.yellow,
      thumbShape: DHThumbShape(
          borderSide: BorderSide(width: 4, color: Color(0xFFFAAA00)),
          label: "${(slider * 100).toInt()}",
          enabledThumbRadius: 21,
          labelStyle: TextStyle(color: Colors.cyan, fontSize: 14)),
      trackShape: DHSliderTrackShape(
        alignThumbCenter: false,
        marks: ['0', '35', '70', '100'],
        activeMarkStyle: TextStyle(color: Colors.white, fontSize: 14),
        inactiveMarkStyle: TextStyle(color: Color(0xFF7F7F7F), fontSize: 12),
        disabledActiveMarkStyle: TextStyle(color: Colors.red, fontSize: 14),
        disabledInactiveMarkStyle: TextStyle(color: Colors.brown, fontSize: 12),
      ),
      onChanged: (value) {
        this.setState(() => slider = value);
      },
      onChangeEnd: (value) {
        this.setState(() => slider = value);
      },
      min: 0.0,
      max: 1.0,
    );
  }

  Future<ui.Image> getImageFuture(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) {
    //new Completer
    Completer<ui.Image> completer = Completer<ui.Image>();
    ImageStreamListener? listener;
    //获取图片流
    ImageStream stream = provider.resolve(config);
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      //stream 流监听
      final ui.Image image = frame.image;
      //完成事件
      completer.complete(image);
      //移除监听
      stream.removeListener(listener!);
    });
    //添加监听
    stream.addListener(listener);
    //返回image
    return completer.future;
  }
}
