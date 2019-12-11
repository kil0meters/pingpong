import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:morpheus/morpheus.dart';

import 'globals.dart' as globals;
import 'drill_editor.dart';
import 'main.dart';

class Drill {
  Drill(
    this.title,
    this.description,
    this.firingSpeedMin,
    this.firingSpeedMax,
    this.oscillationSpeedMin,
    this.oscillationSpeedMax,
    this.topspinMin,
    this.topspinMax,
    this.backspinMin,
    this.backspinMax,
  );

  String title;
  String description;

  int firingSpeedMax;
  int firingSpeedMin;
  int oscillationSpeedMax;
  int oscillationSpeedMin;
  int topspinMax;
  int topspinMin;
  int backspinMax;
  int backspinMin;
}

class DrillScreen extends StatelessWidget {
  DrillScreen({Key key}) : super(key: key);

  // drills = <Drill>[
  //   Drill("Die", "Fast firing, no oscillation", 60, 70, 0, 0, 0, 0, 0, 0),
  //   Drill("Lie", "Slow firing, lots of oscillation", 5, 10, 80, 100, 0, 20, 0,
  //       20),
  //   Drill("Kind", "Lots of back spin, medium firing", 20, 60, 30, 50, 0, 0, 90,
  //       100),
  //   Drill("Mind", "Lots of top spin, medium firing", 20, 60, 30, 50, 90, 100, 0,
  //       0),
  //   Drill(
  //       "Randomonium",
  //       "What is this, some kind of lottery?\n\n"
  //           "This is probably useless for actual training but it seems fun I guess.",
  //       5,
  //       70,
  //       0,
  //       100,
  //       0,
  //       100,
  //       0,
  //       100),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drills'),
        backgroundColor: Colors.green,
      ),
      body: Container(
          child: ListView(
        padding: EdgeInsets.all(12),
        children: PingPongRoot.of(context).drills.map<Widget>((drill) {
          final GlobalKey _parentKey = GlobalKey();
          return Card(
            key: _parentKey,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
            elevation: 1,
            child: ListTile(
              // key: _parentKey,
              title: Text(drill.title),
              subtitle: Text(
                drill.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => _handleTap(context, _parentKey, drill),
            ),
          );
        }).toList(),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDrillTypeDialog(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: globals.accentColor,
      ),
    );
  }

  void _showDrillTypeDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Drill Type'),
            content: Text('Choose the type of drill you want'),
            actions: <Widget>[
              FlatButton(
                child: Text('Manual'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DrillEditorManual(),
                    ),
                  );
                },
              ),
              FlatButton(
                child: Text('Automatic'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DrillEditorAutomatic(),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  void _handleTap(BuildContext context, GlobalKey parentKey, Drill drill) {
    Navigator.of(context).push(MorpheusPageRoute(
      builder: (context) => new DrillViewer(drill: drill),
      parentKey: parentKey,
    ));
  }
}

class DrillViewer extends StatelessWidget {
  final Drill drill;

  const DrillViewer({
    Key key,
    this.drill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          drill.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Text('Edit'),
              )
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CarouselSlider(
            height: 256.0,
            items: <Widget>[
              ListViewCard(
                title: 'Firing Speed',
                subtitle: 'How fast the machine fires',
                valueMax: drill.firingSpeedMax,
                valueMin: drill.firingSpeedMin,
                rangeMax: globals.firingSpeedMax,
                rangeMin: globals.firingSpeedMin,
              ),
              ListViewCard(
                title: 'Oscillation Speed',
                subtitle: 'How fast the machine moves horizontally',
                valueMax: drill.oscillationSpeedMax,
                valueMin: drill.oscillationSpeedMin,
                rangeMax: globals.oscillationSpeedMax,
                rangeMin: globals.oscillationSpeedMin,
              ),
              ListViewCard(
                title: 'Topspin',
                subtitle: 'How much topspin each ball will have',
                valueMax: drill.topspinMax,
                valueMin: drill.topspinMin,
                rangeMax: globals.oscillationSpeedMax,
                rangeMin: globals.oscillationSpeedMin,
              ),
              ListViewCard(
                title: 'Backspin',
                subtitle: 'How much backspin each abll will have',
                valueMax: drill.backspinMax,
                valueMin: drill.backspinMin,
                rangeMax: globals.oscillationSpeedMax,
                rangeMin: globals.oscillationSpeedMin,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  drill.description,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: RaisedButton(
                color: globals.accentColor,
                child: Text(
                  'START DRILL',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListViewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int valueMax;
  final int valueMin;
  final double rangeMax;
  final double rangeMin;

  const ListViewCard({
    Key key,
    this.title,
    this.subtitle,
    this.valueMax,
    this.valueMin,
    this.rangeMax,
    this.rangeMin,
  }) : super(key: key);

  // color form: 0xRRGGBBAA

  Color _getColorFromValue(int value) {
    double intensityWeight = (rangeMax - value) / rangeMax;

    int red = ((1 - intensityWeight) * 255).floor();
    int green = globals.accentColor.green;
    int blue = ((intensityWeight) * 255).floor();

    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.black38,
                  // colors take the form 0xFFFFFFFF
                  gradient: LinearGradient(colors: [
                    _getColorFromValue(valueMax),
                    _getColorFromValue(valueMin)
                  ]),
                ),
              ),
            ),
          ),
          Container(
              color: Colors.black12,
              height: 1), // Divider() without padding essentially
          Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.title,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    this.subtitle,
                    style: TextStyle(fontSize: 15, color: Colors.black45),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
