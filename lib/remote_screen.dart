import 'package:flutter/material.dart';

import 'sliders.dart';
import 'globals.dart' as globals;

class RemoteScreen extends StatelessWidget {
  final GlobalKey navigatorKey;

  RemoteScreen({Key key, this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Navigator(
        key: navigatorKey,
        onGenerateRoute: (RouteSettings settings ) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              switch(settings.name) {
                case '/':
                  return RemoteDefault();
                default:
                  return Text('ERROR - this should never happen');
              }
            }
          );
        }
      )
    );
  }
}

class RemoteDefault extends StatelessWidget {
  const RemoteDefault({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  PingPongSlider(
                    title: 'Firing Speed',
                    unit: 'balls per minute',
                    max: globals.firingSpeedMax,
                    min: globals.firingSpeedMin,
                    onChanged: (value) {

                    }
                  ),
                  PingPongSlider(
                    title: 'Oscillation Speed',
                    unit: 'rotations per minute',
                    max: globals.oscillationSpeedMax,
                    min: globals.oscillationSpeedMin,
                    onChanged: (value) {

                    }
                  ),
                  PingPongSlider(
                    title: "Backspin",
                    max: globals.oscillationSpeedMax,
                    min: globals.oscillationSpeedMin,
                    onChanged: (value) {

                    }
                  ),
                  PingPongSlider(
                    title: "Topspin",
                    max: globals.oscillationSpeedMax,
                    min: globals.oscillationSpeedMin,
                    onChanged: (value) {

                    }
                  ),
                ]
              )
            )
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ResumeFiringButton(),
          )
        ],
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