import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pingpong/drill_screen.dart';

import 'globals.dart' as globals;
import 'sliders.dart';
import 'main.dart';

class DrillEditorAutomatic extends StatelessWidget {
  DrillEditorAutomatic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Drill editingDrill = new Drill(title: "title", description: "description");

    return Scaffold(
      appBar: AppBar(
        title: Text('Drill Editor (Automatic)'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                    onChanged: (String value) {
                      editingDrill.title = value;
                    },
                  ),
                  SizedBox(height: 12), //
                  TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                      onChanged: (String value) {
                        editingDrill.description = value;
                      }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Text(
                'Value Ranges',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: <Widget>[
                    PingPongRangeSlider(
                      title: "Firing Speed",
                      max: globals.firingSpeedMax,
                      min: globals.firingSpeedMin,
                      onChanged: (RangeValues values) async {
                        editingDrill.firingSpeedMin = values.start;
                        editingDrill.firingSpeedMax = values.end;
                      },
                    ),
                    PingPongRangeSlider(
                      title: "Oscillation Speed",
                      max: globals.oscillationSpeedMax,
                      min: globals.oscillationSpeedMin,
                      onChanged: (RangeValues values) async {
                        editingDrill.oscillationSpeedMin = values.start;
                        editingDrill.oscillationSpeedMax = values.end;
                      },
                    ),
                    PingPongRangeSlider(
                      title: "Topspin",
                      max: globals.topspinMax,
                      min: globals.topspinMin,
                      onChanged: (RangeValues values) async {
                        editingDrill.topspinMin = values.start;
                        editingDrill.topspinMax = values.end;
                      },
                    ),
                    PingPongRangeSlider(
                        title: "Backspin",
                        max: globals.backspinMax,
                        min: globals.topspinMin,
                        onChanged: (RangeValues values) async {
                          editingDrill.backspinMin = values.start;
                          editingDrill.backspinMax = values.end;
                        }),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Selection Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    DrillEditorDropdown()
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 72,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: globals.accentColor,
        onPressed: () {
          PingPongRoot.of(context).addDrill(Drill.copy(editingDrill));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class DrillEditorManual extends StatelessWidget {
  const DrillEditorManual({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drill Editor (Manual)'),
        backgroundColor: Colors.cyan,
      ),
      body: DrillSequenceEditor(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: globals.accentColor,
        child: Icon(Icons.save),
        onPressed: () {},
      ),
    );
  }
}

class DrillSequenceEditor extends StatefulWidget {
  const DrillSequenceEditor({
    Key key,
  }) : super(key: key);

  @override
  _DrillSequenceEditorState createState() => _DrillSequenceEditorState();
}

class _DrillSequenceEditorState extends State<DrillSequenceEditor> {
  List<DrillSingleShotPanel> shots = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                  SizedBox(height: 12), //
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                  ),
                ],
              ),
            ),
          ] +
          shots.map<Widget>((shot) => shot).toList() +
          <Widget>[
            Padding(
              padding: EdgeInsets.all(12),
              child: FlatButton(
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  setState(() {
                    shots.add(DrillSingleShotPanel(index: shots.length + 1));
                  });
                },
                child: DottedBorder(
                  padding: EdgeInsets.all(12),
                  // radius: Radius.circular(10),
                  strokeWidth: 3,
                  dashPattern: [16, 8],
                  strokeCap: StrokeCap.round,
                  color: Colors.black38,
                  radius: Radius.circular(10),
                  borderType: BorderType.RRect,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 36,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
          ],
    );
  }
}

class DrillSingleShotPanel extends StatefulWidget {
  final int index;

  const DrillSingleShotPanel({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  _DrillSingleShotPanelState createState() => _DrillSingleShotPanelState();
}

class _DrillSingleShotPanelState extends State<DrillSingleShotPanel> {
  double firingSpeed = (globals.firingSpeedMax + globals.firingSpeedMin) / 2;
  double oscillationSpeed =
      (globals.oscillationSpeedMax + globals.oscillationSpeedMin) / 2;
  double topspin = (globals.topspinMax + globals.topspinMin) / 2;
  double backspin = (globals.backspinMax + globals.backspinMin) / 2;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: ExpandablePanel(
          header: Text('Shot #${widget.index}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          headerAlignment: ExpandablePanelHeaderAlignment.top,
          collapsed: Text(
              'Firing Speed: ${firingSpeed.floor()}, Oscillation Speed: ${oscillationSpeed.floor()}, Backspin: ${backspin.floor()}, Topspin: ${topspin.floor()}'),
          expanded: Column(
            children: <Widget>[
              PingPongSlider(
                  title: 'Firing Speed',
                  unit: 'balls per minute',
                  max: globals.firingSpeedMax,
                  min: globals.firingSpeedMin,
                  onChanged: (value) {
                    setState(() {
                      firingSpeed = value;
                    });
                  }),
              PingPongSlider(
                  title: 'Oscillation Speed',
                  unit: 'rotations per minute',
                  max: globals.oscillationSpeedMax,
                  min: globals.oscillationSpeedMin,
                  onChanged: (value) {
                    setState(() {
                      oscillationSpeed = value;
                    });
                  }),
              PingPongSlider(
                  title: "Backspin",
                  max: globals.oscillationSpeedMax,
                  min: globals.oscillationSpeedMin,
                  onChanged: (value) {
                    setState(() {
                      backspin = value;
                    });
                  }),
              PingPongSlider(
                  title: "Topspin",
                  max: globals.oscillationSpeedMax,
                  min: globals.oscillationSpeedMin,
                  onChanged: (value) {
                    setState(() {
                      topspin = value;
                    });
                  }),
            ],
          ),
          tapHeaderToExpand: true,
        ),
      ),
    );
  }
}

class DrillEditorDropdown extends StatefulWidget {
  const DrillEditorDropdown({
    Key key,
  }) : super(key: key);

  @override
  _DrillEditorDropdownState createState() => _DrillEditorDropdownState();
}

class _DrillEditorDropdownState extends State<DrillEditorDropdown> {
  String selectedValue = 'Random';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: selectedValue,
        items: <String>['Random', 'Random Noise', 'Linear'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String value) {
          setState(() {
            selectedValue = value;
          });
        });
  }
}
