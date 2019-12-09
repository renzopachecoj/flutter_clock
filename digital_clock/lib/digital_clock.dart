// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/weather_icons.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  wallpaper,
  background,
  clock_text,
  card_text,
}

final _lightTheme = {
  _Element.wallpaper: 'assets/lightThemeWallpaper.png',
  _Element.background: Colors.white70,
  _Element.clock_text: Colors.black,
  _Element.card_text: Colors.black,
};

final _darkTheme = {
  _Element.wallpaper: 'assets/darkThemeWallpaper.png',
  _Element.background: Colors.black38,
  _Element.clock_text: Colors.white,
  _Element.card_text: Colors.white,
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _condition = '';

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      setState(() {
        _temperature = widget.model.temperatureString;
        _condition = widget.model.weatherString;
      });
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);
    final day = DateFormat('dd').format(_dateTime);
    final month = DateFormat('MMM').format(_dateTime);

    final clockStyle = TextStyle(
      color: colors[_Element.clock_text],
      fontFamily: 'Google Sans',
      fontSize: 150,
      fontWeight: FontWeight.bold,
    );

    final clockStyleSmall = TextStyle(
      color: colors[_Element.clock_text],
      fontFamily: 'Google Sans',
      fontSize: 35,
      fontWeight: FontWeight.bold,
    );

    final cardStyle = TextStyle(
      color: colors[_Element.card_text],
      fontFamily: 'Google Sans',
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    const double MIN_PADDING = 2;
    const double MAX_PADDING = 5;

    final clockContainer = new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DefaultTextStyle(
          style: clockStyle,
          child: Text(hour),
        ),
        DefaultTextStyle(
          style: clockStyleSmall,
          child: Text("h"),
        ),
        Padding(
          padding: EdgeInsets.all(MAX_PADDING),
          child: AnimatedContainer(
            curve: Curves.bounceInOut,
            duration: Duration(milliseconds: 500),
            height: double.parse(second) * (clockStyle.fontSize / 60),
            width: double.parse(second) * (clockStyle.fontSize / 60),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: new LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: (Theme.of(context).brightness == Brightness.light)
                      ? [
                          Colors.pinkAccent,
                          Colors.orange,
                          Colors.yellow,
                        ]
                      : [
                          Colors.deepPurpleAccent,
                          Colors.teal,
                          Colors.cyan,
                        ]),
            ),
          ),
        ),
        DefaultTextStyle(
          style: clockStyle,
          child: Text(minute),
        ),
        DefaultTextStyle(
          style: clockStyleSmall,
          child: Text("m"),
        ),
      ],
    );

    final cardsContainer = new Container(
      child: Padding(
        padding: EdgeInsets.all(MIN_PADDING),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5.0,
              color: colors[_Element.background],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: EdgeInsets.all(MAX_PADDING),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(MAX_PADDING),
                        child: Icon(
                          getWeatherIcon(),
                          color: colors[_Element.card_text],
                          size: cardStyle.fontSize * 2,
                        )),
                    Padding(
                      padding: EdgeInsets.all(MAX_PADDING),
                      child: DefaultTextStyle(
                        style: cardStyle,
                        child: Text("Temperature: \n" + _temperature),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              color: colors[_Element.background],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: EdgeInsets.all(MAX_PADDING),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(MAX_PADDING),
                        child: Icon(
                          Icons.calendar_today,
                          color: colors[_Element.card_text],
                          size: cardStyle.fontSize * 2,
                        )),
                    Padding(
                      padding: EdgeInsets.all(MAX_PADDING),
                      child: DefaultTextStyle(
                        style: cardStyle,
                        child: Text("Today is: \n" + month + ", " + day),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Clock card is only a placeholder. Doesnt get any alarm info
            Card(
              elevation: 5.0,
              color: colors[_Element.background],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: EdgeInsets.all(MAX_PADDING),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(MAX_PADDING),
                        child: Icon(
                          Icons.alarm,
                          color: colors[_Element.card_text],
                          size: cardStyle.fontSize * 2,
                        )),
                    Padding(
                      padding: EdgeInsets.all(MAX_PADDING),
                      child: DefaultTextStyle(
                        style: cardStyle,
                        child: Text("Next alarm:\n5:00"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            colors[_Element.wallpaper],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              clockContainer,
              cardsContainer,
            ],
          ),
        ],
      ),
    );
  }

  IconData getWeatherIcon() {
    if (_condition == "cloudy")
      return WeatherIcons.weather_cloudy;
    else if (_condition == "foggy")
      return WeatherIcons.weather_fog;
    else if (_condition == "rainy")
      return WeatherIcons.weather_rainy;
    else if (_condition == "snowy")
      return WeatherIcons.weather_snowy;
    else if (_condition == "sunny")
      return Icons.wb_sunny;
    else if (_condition == "thunderstorm")
      return WeatherIcons.weather_lightning;
    else if (_condition == "windy") return WeatherIcons.weather_windy_variant;
    return Icons.question_answer;
  }
}
