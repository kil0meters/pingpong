import 'package:flutter/material.dart';

import 'sliders.dart';
import 'globals.dart' as globals;

class RemoteScreen extends StatelessWidget {
  const RemoteScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Remote'),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: <Widget>[
                    PingPongSlider(
                      title: 'Firing Speed',
                      unit: 'balls per minute',
                      max: globals.firingSpeedMax,
                      min: globals.firingSpeedMin,
                      onChanged: (value) {},
                    ),
                    PingPongSlider(
                      title: 'Oscillation Speed',
                      unit: 'rotations per minute',
                      max: globals.oscillationSpeedMax,
                      min: globals.oscillationSpeedMin,
                      onChanged: (value) {},
                    ),
                    PingPongSlider(
                      title: "Backspin",
                      max: globals.oscillationSpeedMax,
                      min: globals.oscillationSpeedMin,
                      onChanged: (value) {},
                    ),
                    PingPongSlider(
                      title: "Topspin",
                      max: globals.oscillationSpeedMax,
                      min: globals.oscillationSpeedMin,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ResumeFiringButton(),
              ),
            ),
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
  Color buttonColor = globals.accentColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text(label,
            style: TextStyle(
              color: Colors.white,
            )),
        color: buttonColor,
        onPressed: () {
          setState(() {
            if (!isOn) {
              label = 'TURN OFF';
              buttonColor = globals.errorAccentColor;
            } else {
              label = 'TURN ON';
              buttonColor = globals.accentColor;
            }

            isOn = !isOn;
          });
        });
  }
}
