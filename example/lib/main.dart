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
    sliderFuture = getImageFuture(AssetImage("images/slider_bck.png"));
  }

  @override
  Widget build(BuildContext context) {
    var dhSlider = DHSlider(
        inScroll: true,
        thumbBorderSide: BorderSide.none,
        thumbColor: Colors.redAccent,
        trackHeight: 3,
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
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
        onChangeStart: (double value) {
          this.setState(() {
            slider = value;
          });
          print("onChangeStart: $value");
        },
        onChanged: (double value) {
          this.setState(() {
            slider = value;
          });
          print("onChanged: $value");
        });

    Widget fbSlider = FutureBuilder(
      future: sliderFuture,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        return DHSlider(
          value: slider,
          trackImage: snapshot.data,
          trackHeight: 13,
          activeTrackColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          disabledActiveTrackColor: Colors.transparent,
          disabledInactiveTrackColor: Colors.transparent,
          thumbColor: Colors.white,
          disabledThumbColor: Colors.white,
          enabledThumbRadius: 12,
          margin: EdgeInsets.only(left: 10, right: 10, top: 30),
          thumbBorderSide: BorderSide(
            width: 0.6,
            color: Colors.red,
          ),
          onChanged: (value) {
            this.setState(() => slider = value);
          },
          onChangeStart: (value) {
            this.setState(() => slider = value);
          },
          onChangeEnd: (value) {
            this.setState(() => slider = value);
          },
          min: 0,
          max: 1,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[dhSlider, fbSlider],
      ),
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
