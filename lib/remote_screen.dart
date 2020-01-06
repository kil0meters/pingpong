import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'sliders.dart';
import 'globals.dart' as globals;

class RemoteScreen extends StatefulWidget {
  const RemoteScreen({
    Key key,
  }) : super(key: key);

  @override
  _RemoteScreenState createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  int currentFiringSpeed = 0;
  int currentOscillationSpeed = 0;
  int currentTopspin = 0;
  int currentBackspin = 0;

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
                      onChanged: (value) async {
                        currentFiringSpeed = value.floor();
                        if (globals.isFiring) {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-firing-speed/$currentFiringSpeed'));
                          } catch (error) {
                            print('$error');
                          }
                        }
                      },
                    ),
                    PingPongSlider(
                      title: 'Oscillation Speed',
                      unit: 'rotations per minute',
                      max: globals.oscillationSpeedMax,
                      min: globals.oscillationSpeedMin,
                      onChanged: (value) async {
                        currentOscillationSpeed = value.floor();
                        if (globals.isFiring) {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-oscillation-speed/$currentOscillationSpeed'));
                          } catch (error) {
                            print('$error');
                          }
                        }
                      },
                    ),
                    PingPongSlider(
                      title: "Backspin",
                      max: globals.backspinMax,
                      min: globals.backspinMin,
                      onChanged: (value) async {
                        currentBackspin = value.floor();
                        if (globals.isFiring) {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-backspin/$currentBackspin'));
                          } catch (error) {
                            print('$error');
                          }
                        }
                      },
                    ),
                    PingPongSlider(
                      title: "Topspin",
                      max: globals.topspinMax,
                      min: globals.topspinMin,
                      onChanged: (value) async {
                        currentTopspin = value.floor();
                        if (globals.isFiring) {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-topspin/$currentTopspin'));
                          } catch (error) {
                            print('$error');
                          }
                        }
                      },
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
                child: RaisedButton(
                  child: Text(
                    globals.isFiring ? "TURN OFF" : "TURN ON",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: globals.isFiring
                      ? globals.errorAccentColor
                      : globals.accentColor,
                  onPressed: () async {
                    if (globals.isFiring) {
                      stopFiring();
                    } else {
                      startFiring();
                    }
                    setState(() {
                      globals.isFiring = !globals.isFiring;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startFiring() {
    try {
      http.get(Uri.http('${globals.serverUrl}',
          '/api/v1/set-firing-speed/$currentFiringSpeed'));
      http.get(Uri.http('${globals.serverUrl}',
          '/api/v1/set-oscillation-speed/$currentOscillationSpeed'));
      http.get(Uri.http(
          '${globals.serverUrl}', '/api/v1/set-topspin/$currentTopspin'));
      http.get(Uri.http(
          '${globals.serverUrl}', '/api/v1/set-backspin/$currentBackspin'));
    } catch (error) {
      print('$error');
    }
  }

  void stopFiring() {
    try {
      http.get(Uri.http('${globals.serverUrl}', '/api/v1/set-firing-speed/0'));
      http.get(
          Uri.http('${globals.serverUrl}', '/api/v1/set-oscillation-speed/0'));
      http.get(Uri.http('${globals.serverUrl}', '/api/v1/set-topspin/0'));
      http.get(Uri.http('${globals.serverUrl}', '/api/v1/set-backspin/0'));
    } catch (error) {
      print('$error');
    }
  }
}
