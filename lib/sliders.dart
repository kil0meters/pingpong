import 'package:flutter/material.dart';

import 'app_state.dart';

class PingPongSlider extends StatefulWidget {
  final String title;
  final String unit;
  final String parameterName;
  final int initialValue;
  final int max;
  final int min;

  final Function(double) onChanged; 
 
  PingPongSlider({
    this.title,
    this.unit = "",
    this.max,
    this.min,
    this.initialValue = 0,
    this.parameterName,
    this.onChanged,
  }) : super(key: ObjectKey(title));

  @override
  _PingPongSliderState createState() => _PingPongSliderState();
}

class _PingPongSliderState extends State<PingPongSlider> {
  double sliderValue = 100.0;

  _PingPongSliderState({Key key});

  // only call AppState when it's requested
  @override
  void didChangeDependencies() {
    AppState appState = AppState.of(context);
    // print(appState.data);
    sliderValue = appState.data[widget.parameterName].toDouble();
    super.didChangeDependencies();
  }

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

