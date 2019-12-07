// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/weather_icons.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
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
      color: colors[_Element.text],
      fontFamily: 'Google Sans',
      fontSize: 110,
      fontWeight: FontWeight.bold,
    );

    final cardStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Google Sans',
      fontSize: 20,
      fontWeight: FontWeight.w100,
    );

    const double MIN_PADDING = 2;
    const double MAX_PADDING = 4;

    final clockContainer = new Container(
      child: Stack(
        children: <Widget>[
          if (Theme.of(context).brightness == Brightness.light)
            (Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: (double.parse(second) * 250) / 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: new LinearGradient(
                      colors: [
                        Colors.pinkAccent,
                        Colors.yellow.withAlpha(200),
                      ],
                    ),
                  ),
                ),
              ),
            ))
          else
            (Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: (double.parse(second) * 250) / 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: new LinearGradient(
                      colors: [
                        Colors.deepPurple,
                        Colors.teal,
                        Colors.cyanAccent,
                      ],
                    ),
                  ),
                ),
              ),
            )),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border:
                    new Border.all(color: colors[_Element.text], width: 1.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(MAX_PADDING),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: clockStyle,
                      child: Text(hour),
                    ),
                    DefaultTextStyle(
                      style: clockStyle,
                      child: Text(minute),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final cardsContainer = new Container(
      child: Padding(
        padding: EdgeInsets.all(MIN_PADDING),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 2.0,
              color: colors[_Element.background],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(MAX_PADDING),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (_condition == "sunny")
                      (Padding(
                          padding: EdgeInsets.all(MAX_PADDING),
                          child: Icon(
                            WeatherIcons.weather_sunny,
                            color: Colors.lightBlueAccent,
                          )))
                    else if (_condition == "snowy")
                      (Padding(
                          padding: EdgeInsets.all(MAX_PADDING),
                          child: Icon(
                            WeatherIcons.weather_snowy,
                            color: Colors.lightBlueAccent,
                          )))
                    else if (_condition == "cloudy")
                      (Padding(
                          padding: EdgeInsets.all(MAX_PADDING),
                          child: Icon(
                            WeatherIcons.weather_cloudy,
                            color: Colors.lightBlueAccent,
                          )))
                    else if (_condition == "foggy")
                      (Padding(
                          padding: EdgeInsets.all(MAX_PADDING),
                          child: Icon(
                            WeatherIcons.weather_fog,
                            color: Colors.lightBlueAccent,
                          )))
                    else if (_condition == "rainy")
                      (Padding(
                          padding: EdgeInsets.all(MAX_PADDING),
                          child: Icon(
                            WeatherIcons.weather_rainy,
                            color: Colors.lightBlueAccent,
                          )))
                    else if (_condition == "thunderstorm")
                      (Padding(
                          padding: EdgeInsets.all(MAX_PADDING),
                          child: Icon(
                            WeatherIcons.weather_lightning,
                            color: Colors.lightBlueAccent,
                          )))
                    else if (_condition == "windy")
                      (Padding(
                          padding: EdgeInsets.all(MAX_PADDING),
                          child: Icon(
                            WeatherIcons.weather_windy_variant,
                            color: Colors.lightBlueAccent,
                          ))),
                    Padding(
                      padding: EdgeInsets.all(MAX_PADDING),
                      child: DefaultTextStyle(
                        style: cardStyle,
                        child: Text(_temperature),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 2.0,
              color: colors[_Element.background],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.lightGreen, width: 1.0),
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
                          color: Colors.lightGreen,
                        )),
                    Padding(
                      padding: EdgeInsets.all(MAX_PADDING),
                      child: DefaultTextStyle(
                        style: cardStyle,
                        child: Text(day),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(MAX_PADDING),
                      child: DefaultTextStyle(
                        style: cardStyle,
                        child: Text(month),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 2.0,
              color: colors[_Element.background],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: new BorderSide(color: Colors.pinkAccent, width: 1.0),
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
                          color: Colors.pinkAccent,
                        )),
                    Padding(
                      padding: EdgeInsets.all(MAX_PADDING),
                      child: DefaultTextStyle(
                        style: cardStyle,
                        child: Text("5:00"),
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
      backgroundColor: colors[_Element.background],
      body: Card(
        elevation: 2.0,
        color: colors[_Element.background],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: colors[_Element.background], width: 1.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(MIN_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              clockContainer,
              cardsContainer,
            ],
          ),
        ),
      ),
    );
  }
}
