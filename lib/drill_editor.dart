import 'package:flutter/material.dart';

import 'globals.dart' as globals;

class Drill {
  const Drill(this.title, this.description, this.firingSpeed, this.oscillationFrequency, this.topspin, this.backspin);
  final String title;
  final String description;
  final int firingSpeed;
  final int oscillationFrequency;
  final int topspin;
  final int backspin;
}

class DrillEditorSlider extends StatefulWidget {
  final String title;
  final double max;
  final double min;

  DrillEditorSlider({Key key, this.title, this.max, this.min}) : super(key: key);

  @override
  _DrillEditorSliderState createState() => _DrillEditorSliderState(rangeStart: min, rangeEnd: max);
}

class _DrillEditorSliderState extends State<DrillEditorSlider> {
  double rangeStart;
  double rangeEnd;

  _DrillEditorSliderState({Key key, this.rangeStart, this.rangeEnd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${widget.title}: ${this.rangeStart.floor()}-${this.rangeEnd.floor()}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          RangeSlider(
            max: widget.max,
            min: widget.min,
            onChanged: (RangeValues values) {
              setState(() {
                rangeStart = values.start;
                rangeEnd = values.end;
              });
            },
            values: RangeValues(this.rangeStart, this.rangeEnd)
          )
        ],
      ),
    );
  }
}

class DrillPage extends StatefulWidget {
  DrillPage({Key key}) : super(key: key);

  @override
  _DrillPageState createState() => _DrillPageState();
}

class _DrillPageState extends State<DrillPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case '/':
                return DrillList();
              case '/editor':
                return DrillEditorAutomatic();
              default: 
                return Text('ERROR - This should never happen');
            }
          }
        );
      }
    );
  }
}

class DrillEditorAutomatic extends StatelessWidget {
  DrillEditorAutomatic({Key key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor (Automatic)'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DrillEditorSlider(title: "Firing Speed", max: globals.firingSpeedMax, min: globals.firingSpeedMin),
            DrillEditorSlider(title: "Oscillation Speed", max: globals.oscillationSpeedMax, min: globals.oscillationSpeedMin),
            DrillEditorSlider(title: "Topspin", max: globals.topspinMax, min: globals.topspinMin),
            DrillEditorSlider(title: "Backspin", max: globals.backspinMax, min: globals.topspinMin),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Column(

                children: <Widget>[
                  Text(
                    'Selection Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  DrillEditorDropdown()
                ]
              )
            )
          ],
        )
      )
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
      }
    );
  }
}

class DrillList extends StatefulWidget {
  DrillList({Key key}) : super(key: key);

  @override
  _DrillListState createState() => _DrillListState();
}

class _DrillListState extends State<DrillList> {
  final drills = [
    Drill("Die", "Fast firing, no oscillation", 70, 0, 0, 0),
    Drill("Lie", "Slow firing, lots of oscillation", 5, 100, 0, 0),
    Drill("Kind", "Lots of back spin, medium firing", 20, 30, 0, 100),
    Drill("Mind", "Lots of top spin, medium firing", 20, 30, 100, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drills'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: drills.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        drills[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Text(
                        drills[index].description,
                        style: TextStyle(

                        )
                      ),
                    ],
                  ),
                  FlatButton(
                    onPressed: () {
                      // 
                    },
                    shape: CircleBorder(),
                    color: Colors.transparent,
                    child: Icon(
                      Icons.edit,
                      color: Colors.black54,
                    )
                  )
                ]
              )
            )
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/editor');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}