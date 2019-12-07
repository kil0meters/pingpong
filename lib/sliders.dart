import 'package:flutter/material.dart';

import 'globals.dart' as globals;

class PingPongSlider extends StatefulWidget {
  final String title;
  final String unit;
  final double max;
  final double min;

  final Function(double) onChanged; 
 
  PingPongSlider({this.title, this.unit = "", this.max, this.min, this.onChanged});

  @override
  _PingPongSliderState createState() => _PingPongSliderState(sliderValue: (max + min)/2);
}

class _PingPongSliderState extends State<PingPongSlider> {
  double sliderValue;

  _PingPongSliderState({Key key, this.sliderValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${widget.title}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
            ),
            Text(
              '${sliderValue.floor()} ${widget.unit}',
              style: TextStyle(
                color: Colors.black87,
              )
            )
          ],
        ),
        Slider(
          max: widget.max,
          min: widget.min,
          onChanged: (newValue) {
            widget.onChanged(newValue);

            setState(() {
              sliderValue = newValue;
            });
          },
          label: sliderValue.toString(),
          value: sliderValue,
        )
      ],
    );
  }
}

class PingPongRangeSlider extends StatefulWidget {
  final String title;
  final double max;
  final double min;
  final Function(RangeValues) onChanged;

  PingPongRangeSlider({Key key, this.title, this.max, this.min, this.onChanged}) : super(key: key);

  @override
  _PingPongRangeSliderState createState() => _PingPongRangeSliderState(rangeStart: min, rangeEnd: max);
}

class _PingPongRangeSliderState extends State<PingPongRangeSlider> {
  double rangeStart;
  double rangeEnd;

  _PingPongRangeSliderState({Key key, this.rangeStart, this.rangeEnd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${widget.title}', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${this.rangeStart.floor()}-${this.rangeEnd.floor()}',
                style: TextStyle(
                  color: Colors.black87,
                )
              )
            ],
          ),
          RangeSlider(
            max: widget.max,
            min: widget.min,
            onChanged: (RangeValues values) {
              widget.onChanged(values);

              setState(() {
                rangeStart = values.start;
                rangeEnd = values.end;
              });
            },
            values: RangeValues(this.rangeStart, this.rangeEnd)
          )
        ],
      ),
    );
  }
}