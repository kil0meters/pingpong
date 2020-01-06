import 'package:flutter/material.dart';

class PingPongSlider extends StatefulWidget {
  final String title;
  final String unit;
  final int max;
  final int min;
  final double initialValue;

  final Function(double) onChanged; 
 
  PingPongSlider({this.title, this.unit = "", this.max, this.min, this.initialValue, this.onChanged});

  @override
  _PingPongSliderState createState() => _PingPongSliderState(sliderValue: (initialValue == null ? 128 : initialValue));
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
          max: widget.max.toDouble(),
          min: widget.min.toDouble(),
          onChanged: (newValue) {
            setState(() {
              sliderValue = newValue;
            });
          },
          onChangeEnd: (newValue) {
            widget.onChanged(newValue);
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
  final int max;
  final int min;
  final Function(RangeValues) onChanged;

  PingPongRangeSlider({Key key, this.title, this.max, this.min, this.onChanged}) : super(key: key);

  @override
  _PingPongRangeSliderState createState() => _PingPongRangeSliderState(rangeStart: min, rangeEnd: max);
}

class _PingPongRangeSliderState extends State<PingPongRangeSlider> {
  int rangeStart;
  int rangeEnd;

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
            max: widget.max.toDouble(),
            min: widget.min.toDouble(),
            onChanged: (RangeValues values) {
              widget.onChanged(values);

              setState(() {
                rangeStart = values.start.floor();
                rangeEnd = values.end.floor();
              });
            },
            values: RangeValues(this.rangeStart.toDouble(), this.rangeEnd.toDouble())
          )
        ],
      ),
    );
  }
}