import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'sliders.dart';
import 'globals.dart' as globals;

enum PresetAction { save, load }

class RemoteScreen extends StatefulWidget {
  const RemoteScreen({
    Key key,
  }) : super(key: key);

  @override
  _RemoteScreenState createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  String presetName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote'),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          PopupMenuButton<PresetAction>(
            icon: Icon(Icons.more_vert),
            onSelected: (PresetAction action) {
              if (action == PresetAction.save) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Enter a name for the preset'),
                      content: TextField(
                        decoration: InputDecoration(hintText: "Preset Name"),
                        onChanged: (value) {
                          presetName = value;
                        },
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: new Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Save'),
                          onPressed: () {
                            savePreset(presetName);
                            Navigator.of(context).pop();
                          }
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<PresetAction>>[
              PopupMenuItem(
                child: Text('Load preset'),
                value: PresetAction.load,
              ),
              PopupMenuItem(
                child: Text('Save preset'),
                value: PresetAction.save,
              )
            ],
          ),
        ],
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
                      initialValue: globals.currentFiringSpeed.toDouble(),
                      onChanged: (value) {
                        globals.currentFiringSpeed = value.floor();
                        if (globals.serverUrl != '') {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-firing-speed/${globals.currentFiringSpeed}'));
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
                      initialValue: globals.currentOscillationSpeed.toDouble(),
                      onChanged: (value) async {
                        globals.currentOscillationSpeed = value.floor();
                        if (globals.serverUrl != '') {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-oscillation-speed/${globals.currentOscillationSpeed}'));
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
                      initialValue: globals.currentBackspin.toDouble(),
                      onChanged: (value) async {
                        globals.currentBackspin = value.floor();
                        if (globals.serverUrl != '') {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-backspin/${globals.currentBackspin}'));
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
                      initialValue: globals.currentTopspin.toDouble(),
                      onChanged: (value) async {
                        globals.currentTopspin = value.floor();
                        if (globals.serverUrl != '') {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-topspin/${globals.currentTopspin}'));
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
                    globals.firingState ? "TURN OFF" : "TURN ON",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: globals.firingState
                      ? globals.errorAccentColor
                      : globals.accentColor,
                  onPressed: () async { // TODO: could go wrong if request fails
                    if (globals.serverUrl != '') {
                      try {
                        http.get(Uri.http('${globals.serverUrl}', '/api/v1/toggle-firing-state'));
                      } catch (error) {
                        print("$error");
                      }
                    }
                    setState(() {
                      globals.firingState = !globals.firingState;
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

  void savePreset(name) {
    if (globals.serverUrl != '') {
      try {
        http.get('http://${globals.serverUrl}/api/v1/add-preset?name=$name'
                 '&firingSpeed=${globals.currentFiringSpeed}&oscillationSpeed=${globals.currentOscillationSpeed}'
                 '&topspin=${globals.currentTopspin}&backspin=${globals.currentBackspin}');
      } catch (error) {
        print('$error');
      }
    }
  }
}
