import 'package:flutter/material.dart';

class PongKnob extends StatefulWidget {
  final String description;
  final double maxValue;
  final double minValue;
 
  PongKnob({this.description, this.maxValue, this.minValue});

  @override
  _PongKnobState createState() => _PongKnobState();
}

class _PongKnobState extends State<PongKnob> {
  double _sliderValue = 5;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${widget.description}: ${_sliderValue.floor()}'),
            Slider(
              activeColor: Colors.deepOrangeAccent,
              divisions: (widget.maxValue - widget.minValue).floor(),
              max: widget.maxValue,
              min: widget.minValue,
              onChanged: (newValue) {
                setState(() => _sliderValue = newValue);
              },
              label: _sliderValue.toString(),
              value: _sliderValue,
            )
          ],
        ),
      )
    );
  }
}