import 'package:flutter/material.dart';

import 'sliders.dart';
import 'globals.dart' as globals;

class RemoteScreen extends StatelessWidget {
  RemoteScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PingPongSlider(
              title: 'Firing Speed',
              unit: 'balls per minute',
              max: globals.firingSpeedMax,
              min: globals.firingSpeedMin
            ),
            PingPongSlider(
              title: 'Oscillation Speed',
              unit: 'rotations per minute',
              max: globals.oscillationSpeedMax,
              min: globals.oscillationSpeedMin,
            ),
            PingPongSlider(
              title: "Backspin",
              max: globals.oscillationSpeedMax,
              min: globals.oscillationSpeedMin
            ),
            PingPongSlider(
              title: "Topspin",
              max: globals.oscillationSpeedMax,
              min: globals.oscillationSpeedMin
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ResumeFiringButton(),
            )
          ],
        ),
      ),
    );
  }
}

class ResumeFiringButton extends StatefulWidget {
  const ResumeFiringButton({
    Key key,
  }) : super(key: key);

  @override
  _ResumeFiringButtonState createState() => _ResumeFiringButtonState(); 
}

class _ResumeFiringButtonState extends State<ResumeFiringButton> {
  bool isOn = false;
  String label = 'TURN ON';
  MaterialColor buttonColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        )
      ),
      color: buttonColor, 
      onPressed: () {
        setState(() {
          if (!isOn) {
            label = 'TURN OFF';
            buttonColor = Colors.red;
          }
          else {
            label = 'TURN ON';
            buttonColor = Colors.blue;
          }

          isOn = !isOn;
        });
      }
    );
  }
}