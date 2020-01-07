import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'sliders.dart';
import 'globals.dart' as globals;
import 'app_state.dart';

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
    AppState appState = AppState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Remote'),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          PopupMenuButton<PresetAction>(
            icon: Icon(Icons.more_vert),
            onSelected: (PresetAction action) async {
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
                            }),
                      ],
                    );
                  },
                );
              } else if (action == PresetAction.load) {
                List<RemotePreset> presets = await loadPresets();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RemotePresetList(
                      presets: presets,
                      updateRemoteCallback: updateRemote,
                    ),
                  ),
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
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Card(
              margin: EdgeInsets.all(12),
              child: new Padding(
                padding: EdgeInsets.all(12),
                child: new Column(
                  children: <Widget>[
                    PingPongSlider(
                      title: 'Firing Speed',
                      unit: 'balls per minute',
                      max: globals.firingSpeedMax,
                      min: globals.firingSpeedMin,
                      // key: firingSpeedSliderKey,
                      parameterName: 'firingSpeed',
                      onChanged: (value) {
                        appState.data["firingSpeed"] = value.floor();
                        if (globals.serverUrl != '') {
                          try {
                            http.get(Uri.http('${globals.serverUrl}',
                                '/api/v1/set-firing-speed/${appState.data["firingSpeed"]}'));
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
                      // key: oscillationSpeedSliderKey,
                      parameterName: 'oscillationSpeed',
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
                      // key: backspinSliderKey,
                      parameterName: 'backspin',
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
                      parameterName: 'topspin',
                      // key: topspinSliderKey,
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
                    appState.data['firingState'] ? "TURN OFF" : "TURN ON",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: appState.data['firingState']
                      ? globals.errorAccentColor
                      : globals.accentColor,
                  onPressed: () async {
                    // TODO: could go wrong if request fails
                    if (globals.serverUrl != '') {
                      try {
                        http.get(Uri.http('${globals.serverUrl}',
                            '/api/v1/toggle-firing-state'));
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

  void savePreset(String name) {
    AppState appState = AppState.of(context);

    if (globals.serverUrl != '') {
      try {
        http.get('http://${globals.serverUrl}/api/v1/add-preset?name=$name'
            '&firingSpeed=${appState.data["firingSpeed"]}&oscillationSpeed=${globals.currentOscillationSpeed}'
            '&topspin=${globals.currentTopspin}&backspin=${globals.currentBackspin}');
      } catch (error) {
        print('$error');
      }
    }
  }

  Future<List<RemotePreset>> loadPresets() async {
    if (globals.serverUrl != '') {
      try {
        http.Response response = await http.get(
            Uri.http('${globals.serverUrl}', '/api/v1/list-remote-presets'));

        Iterable list = jsonDecode(response.body);
        List<RemotePreset> presets =
            list.map((i) => RemotePreset.fromJson(i)).toList();

        return presets;
      } catch (error) {
        print('$error');
      }
    }
    return [];
  }

  void updateRemote(RemotePreset preset) async {
    if (globals.serverUrl != '') {
      try {
        http.get(Uri.http('${globals.serverUrl}', '/api/v1/set-machine-state-to-preset/${preset.uuid}'));

        AppState appState = AppState.of(context);

        this.setState(() {
          appState.data['firingSpeed'] = preset.firingSpeed;
          appState.data['oscillationSpeed'] = preset.oscillationSpeed;
          appState.data['topspin'] = preset.topspin;
          appState.data['backspin'] = preset.topspin;
        });

        print(appState.data);
      } catch (error) {
        print('$error');
      }
    }
  }
}

class RemotePreset {
  String uuid;
  String name;
  int firingSpeed;
  int oscillationSpeed;
  int topspin;
  int backspin;

  // RemotePreset({
  //   this.uuid,
  //   this.firingSpeed,
  //   this.oscillationSpeed,
  //   this.topspin,
  //   this.backspin,
  // });

  static RemotePreset fromJson(json) {
    RemotePreset preset = RemotePreset();

    preset.uuid = json[0];
    preset.name = json[1];
    preset.firingSpeed = json[2];
    preset.oscillationSpeed = json[3];
    preset.topspin = json[4];
    preset.backspin = json[5];

    return preset;
    //   uuid: json[0],
    //   firingSpeed: json[1],
    //   oscillationSpeed: json[2],
    //   topspin: json[3],
    //   backspin: json[4],
    // );
  }
}

class RemotePresetList extends StatefulWidget {
  List<RemotePreset> presets;
  Function updateRemoteCallback;

  RemotePresetList({
    this.presets,
    this.updateRemoteCallback,
    Key key,
  }) : super(key: key);

  @override
  _RemotePresetListState createState() => _RemotePresetListState();
}

class _RemotePresetListState extends State<RemotePresetList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Remote Presets',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: widget.presets.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(widget.presets[index].name),
            onTap: () {
              widget.updateRemoteCallback(widget.presets[index]);

              Navigator.of(context).pop();
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }
}
