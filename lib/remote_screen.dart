import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pingpong/networking.dart';

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
      body: SingleChildScrollView(
        child: appState.data['isLoading'] ? Text('loading') : Column(
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
                      parameterName: 'firingSpeed',
                      onChanged: (value) {
                        appState.setFiringSpeed(value.floor());
                        serverRequest(context, appState.getServerUrl(),
                            '/api/v1/set-firing-speed/${appState.data["firingSpeed"]}');
                      },
                    ),
                    PingPongSlider(
                      title: 'Oscillation Speed',
                      unit: 'rotations per minute',
                      max: globals.oscillationSpeedMax,
                      min: globals.oscillationSpeedMin,
                      initialValue: appState.data['firingSpeed'] == 0 ? 100 : 100,
                      parameterName: 'oscillationSpeed',
                      onChanged: (value) {
                        appState.setOscillationSpeed(value.floor());
                        serverRequest(context, appState.getServerUrl(),
                            '/api/v1/set-oscillation-speed/${appState.data["oscillationSpeed"]}');
                      },
                    ),
                    PingPongSlider(
                      title: "Topspin",
                      max: globals.topspinMax,
                      min: globals.topspinMin,
                      parameterName: 'topspin',
                      onChanged: (value) {
                        appState.setTopspin(value.floor());
                        serverRequest(context, appState.getServerUrl(),
                            '/api/v1/set-topspin/${appState.data["topspin"]}');
                      },
                    ),
                    PingPongSlider(
                      title: "Backspin",
                      max: globals.backspinMax,
                      min: globals.backspinMin,
                      parameterName: 'backspin',
                      onChanged: (value) {
                        appState.setBackspin(value.floor());
                        serverRequest(context, appState.getServerUrl(),
                            '/api/v1/set-backspin/${appState.data["backspin"]}');
                      },
                    )
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
                  onPressed: () {
                    // TODO: could go wrong if request fails
                    serverRequest(context, appState.getServerUrl(),
                        '/api/v1/toggle-firing-state');
                    setState(() {
                      appState.setFiringState(!appState.data['firingState']);
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

    if (appState.getServerUrl() != '') {
      try {
        http.get(
            'http://${appState.getServerUrl()}/api/v1/add-preset?name=$name'
            '&firingSpeed=${appState.data["firingSpeed"]}&oscillationSpeed=${appState.data["oscillationSpeed"]}'
            '&topspin=${appState.data["topspin"]}&backspin=${appState.data["backspin"]}');
      } catch (error) {
        Scaffold.of(context).showSnackBar(
          errorSnackBar('Could not find server'),
        );
      }
    }
  }

  Future<List<RemotePreset>> loadPresets() async {
    AppState appState = AppState.of(context);

    if (appState.getServerUrl() != '') {
      try {
        http.Response response = await http.get(Uri.http(
            '${appState.getServerUrl()}', '/api/v1/list-remote-presets'));

        Iterable list = jsonDecode(response.body);
        List<RemotePreset> presets =
            list.map((i) => RemotePreset.fromJson(i)).toList();

        return presets;
      } catch (error) {
        Scaffold.of(context).showSnackBar(
          errorSnackBar('Could not find server'),
        );
      }
    }
    return [];
  }

  void updateRemote(RemotePreset preset) {
    AppState appState = AppState.of(context);
    serverRequest(context, appState.getServerUrl(), '/api/v1/set-machine-state-to-preset/${preset.uuid}');

    appState.data['firingSpeed'] = preset.firingSpeed;
    appState.data['oscillationSpeed'] = preset.oscillationSpeed;
    appState.data['topspin'] = preset.topspin;
    appState.data['backspin'] = preset.backspin;
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
  final List<RemotePreset> presets;
  final Function updateRemoteCallback;

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
