import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'globals.dart' as globals;
import 'drill_editor.dart';

class Drill {
  const Drill(this.title, this.description, this.firingSpeedMax, this.firingSpeedMin,
      this.oscillationSpeedMax, this.oscillationSpeedMin, this.topspinMax, this.topspinMin, this.backspinMax, this.backspinMin);
  final String title;
  final String description;

  final int firingSpeedMax;
  final int firingSpeedMin;
  final int oscillationSpeedMax;
  final int oscillationSpeedMin;
  final int topspinMax;
  final int topspinMin;
  final int backspinMax;
  final int backspinMin;
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
                switch (settings.name) {
                  case '/':
                    return DrillList();
                  case '/editor':
                    return DrillEditorAutomatic();
                  default:
                    return Text('ERROR - This should never happen');
                }
              });
        });
  }
}

class DrillList extends StatefulWidget {
  DrillList({Key key}) : super(key: key);

  @override
  _DrillListState createState() => _DrillListState();
}

class _DrillListState extends State<DrillList> {
  List<Drill> drills = <Drill>[
    Drill("Die", "Fast firing, no oscillation", 70, 60, 0, 0, 0, 0, 0, 0),
    Drill("Lie", "Slow firing, lots of oscillation", 5, 10, 80, 100, 0, 20, 0, 20),
    Drill("Kind", "Lots of back spin, medium firing", 20, 60, 30, 50, 0, 0, 90, 100),
    Drill("Mind", "Lots of top spin, medium firing", 20, 60, 30, 50, 90, 100, 0, 0),
  ];

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
        children: drills.map<Widget>((drill) {
          final GlobalKey _parentKey = GlobalKey();
          return Card(
            key: _parentKey,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
            elevation: 1,
            child: ListTile(
              // key: _parentKey,
              title: Text(drill.title),
              subtitle: Text(drill.description),
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
          actions: <Widget> [
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
      }
    );
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
        title: Text(drill.title,
            style: TextStyle(
              color: Colors.black,
            )),
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
        children: <Widget> [
          CarouselSlider(
            height: 256.0,
            items: <Widget>[
              ListViewCard(
                title: 'Firing Speed',
                subtitle: 'How fast the machine fires',
                valueMax: drill.firingSpeedMax,
                valueMin: drill.firingSpeedMin
              ),
              ListViewCard(
                title: 'Oscillation Speed',
                subtitle: 'How fast the machine moves horizontally',
                valueMax: drill.oscillationSpeedMax,
                valueMin: drill.oscillationSpeedMin,
              ),
              ListViewCard(
                title: 'Topspin',
                subtitle: 'How much topspin each ball will have',
                valueMax: drill.topspinMax,
                valueMin: drill.topspinMin,
              ),
              ListViewCard(
                title: 'Backspin',
                subtitle: 'How much backspin each abll will have',
                valueMax: drill.backspinMax,
                valueMin: drill.backspinMin,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
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
                  )
                ),
                onPressed: () {

                },
              )
            )
          )
        ],
      )
    );
  }
}

class ListViewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int valueMax;
  final int valueMin;

  const ListViewCard({
    Key key,
    this.title,
    this.subtitle,
    this.valueMax,
    this.valueMin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget> [
          Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 12),
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
            )
          )
        ],
      ),
    );
  }
}
