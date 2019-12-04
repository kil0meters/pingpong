import 'package:flutter/material.dart';

import 'pong_knob.dart';

class RemotePage extends StatefulWidget {
  RemotePage({Key key}) : super(key: key);

  @override
  _RemotePageState createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Automatic Firing'),
              Switch(
                value: false,
                activeColor: Colors.deepOrangeAccent,
                onChanged: (isFiring) => {},
              ),
            ],
          ),
          PongKnob(description: "Firing Speed", maxValue: 10, minValue: 0),
          PongKnob(description: "Oscillation Frequency", maxValue: 10, minValue: 0),
          PongKnob(description: "Backspin", maxValue: 10, minValue: 0),
          PongKnob(description: "Topspin", maxValue: 10, minValue: 0),
        ],
      ),
    );
  }
}