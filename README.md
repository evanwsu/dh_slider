# dh_slider[![dh_slider](https://img.shields.io/badge/pub-1.0.1-brightgreen.svg)](https://pub.dev/packages/dh_slider)

A handy slider that supports color and image settings for thumb and track.



<img src="./images/screen_shot.jpg" width="40%">



## How to use

- Import dh_slider

```
import 'package:dh_slider/dh_slider.dart';
```

- Use color to set slider

```
DHSlider(
    thumbBorderSide: BorderSide.none,
    thumbColor: Colors.redAccent,
    trackHeight: 3,
    margin: EdgeInsets.only(left: 10, right: 10, top: 20),
    value: slider,
    onChanged: (double value){
      this.setState(() {
        slider = value;
      });
    })
```

- Use image to set slider

```
FutureBuilder(
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
      min: 0,
      max: 1,
    );
  }
```

To use image settings for track and thumb, use `DHSlider.image`.

- Add mark for slider

```
DHSliderTrackShape(
  alignThumbCenter: false,
  marks: ['0', '35', '70', '100'],
  activeMarkStyle: TextStyle(color: Colors.white, fontSize: 14),
  inactiveMarkStyle: TextStyle(color: Color(0xFF7F7F7F), fontSize: 12),
  disabledActiveMarkStyle: TextStyle(color: Colors.red, fontSize: 14),
  disabledInactiveMarkStyle: TextStyle(color: Colors.brown, fontSize: 12),
)
```

Customize `trackShape` parameters, set `marks` and `markStyle`.

- Add text for thumb

```
DHThumbShape(
    borderSide: BorderSide(width: 4, color: Color(0xFFFAAA00)),
    label: "value",
    enabledThumbRadius: 21,
    labelStyle: TextStyle(color: Colors.cyan, fontSize: 14))
```

Customize `thumbShape` parameters, set `label` and `labelStyle`.