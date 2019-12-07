import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';

import 'globals.dart' as globals;
import 'sliders.dart';

class Drill {
  const Drill(this.title, this.description, this.firingSpeed, this.oscillationFrequency, this.topspin, this.backspin);
  final String title;
  final String description;
  final int firingSpeed;
  final int oscillationFrequency;
  final int topspin;
  final int backspin;
}

class DrillScreen extends StatelessWidget {
  final GlobalKey navigatorKey;

  DrillScreen({Key key, this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
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
            PingPongRangeSlider(title: "Firing Speed", max: globals.firingSpeedMax, min: globals.firingSpeedMin),
            PingPongRangeSlider(title: "Oscillation Speed", max: globals.oscillationSpeedMax, min: globals.oscillationSpeedMin),
            PingPongRangeSlider(title: "Topspin", max: globals.topspinMax, min: globals.topspinMin),
            PingPongRangeSlider(title: "Backspin", max: globals.backspinMax, min: globals.topspinMin),
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
      body: Container(
        padding: EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: drills.length,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final _parentKey = GlobalKey();
            return Card(
              key: _parentKey,
              elevation: 8,
              child: ListTile(
                // key: _parentKey,
                title: Text(drills[index].title),
                subtitle: Text(drills[index].description),
                onTap: () => _handleTap(context, _parentKey),
              ),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/editor');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void _handleTap(BuildContext context, GlobalKey parentKey) {
    Navigator.of(context).push(MorpheusPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            'test',
            style: TextStyle(
              color: Colors.black,
            )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/editor');
          },
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          backgroundColor: Colors.blueAccent,
        ),
      ),
      parentKey: parentKey,
    ));
  }
}