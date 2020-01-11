import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:morpheus/morpheus.dart';

import 'package:pingpong/globals.dart' as globals;
import 'package:pingpong/drill_screen/drill_editor_automatic.dart';
import 'package:pingpong/drill_screen/drill_editor_manual.dart';
import 'package:pingpong/main.dart';

class DrillScreen extends StatefulWidget {
  DrillScreen({Key key}) : super(key: key);

  @override
  _DrillScreenState createState() => _DrillScreenState();
}

class _DrillScreenState extends State<DrillScreen>
    with TickerProviderStateMixin<DrillScreen> {
  @override
  Widget build(BuildContext context) {
    final drillList = PingPongRoot.of(context).drills;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drills'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 96),
          itemCount: drillList.length,
          itemBuilder: (context, index) =>
              _buildCard(context, index, drillList),
        ),
      ),
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

  Widget _buildCard(BuildContext context, int index, List<AutomaticDrill> drillList) {
    // final GlobalKey _parentKey = GlobalKey();
    AutomaticDrill drill = drillList[index];
    GlobalKey _parentKey = GlobalKey();

    ListViewTile tile = ListViewTile(
      // key: _parentKey,
      title: drill.title,
      subtitle: drill.description,
      image: AutomaticFiringDrillVisualization(drill: drill),
      onTap: () {
        Navigator.of(context).push(
          MorpheusPageRoute(
            builder: (context) => new DrillViewer(drill: drill),
            parentKey: _parentKey,
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      },
    );

    Draggable draggable = LongPressDraggable<AutomaticDrill>(
      data: drill,
      maxSimultaneousDrags: 1,
      child: tile,
      childWhenDragging: SizedBox(),
      feedback: Card(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 24), // -24 is the padding value
          child: tile,
        ),
        elevation: 4.0,
      ),
    );

    return DragTarget<AutomaticDrill>(
      onWillAccept: (drill) {
        return drillList.indexOf(drill) != index;
      },
      onAccept: (drill) {
        // setState(() {
        int currentIndex = drillList.indexOf(drill);
        setState(() {
          drillList.remove(drill);
          drillList.insert(currentIndex > index ? index : index - 1, drill);
        });
        // });
      },
      builder: (BuildContext context, List<AutomaticDrill> candidateData,
          List<dynamic> rejectedData) {
        return Column(
          children: <Widget>[
            AnimatedSize(
              duration: Duration(milliseconds: 100),
              vsync: this,
              // vsync: this,
              child: candidateData.isEmpty
                  ? Container()
                  : Opacity(
                    opacity: 0,
                    child: tile,
                  )
            ),
            Card(
              key: _parentKey,
              margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: candidateData.isEmpty ? draggable : tile,
            )
          ],
        );
      },
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
                    builder: (context) => ManualDrillEditor(),
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
                    builder: (context) => AutomaticDrillEditor(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class DrillViewer extends StatelessWidget {
  final AutomaticDrill drill;

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
              Card(
                margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: ListViewTile(
                  title: 'Firing Speed',
                  subtitle: 'How fast the machine fires',
                  image: RangeVisualization(
                    valueMax: drill.firingSpeedMax,
                    valueMin: drill.firingSpeedMin,
                    rangeMax: globals.firingSpeedMax,
                    rangeMin: globals.firingSpeedMin,
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: ListViewTile(
                  title: 'Oscillation Speed',
                  subtitle: 'How fast the machine moves horizontally',
                  image: RangeVisualization(
                    valueMax: drill.oscillationSpeedMax,
                    valueMin: drill.oscillationSpeedMin,
                    rangeMax: globals.oscillationSpeedMax,
                    rangeMin: globals.oscillationSpeedMin,
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: ListViewTile(
                  title: 'Topspin',
                  subtitle: 'How much topspin each ball will have',
                  image: RangeVisualization(
                    valueMax: drill.topspinMax,
                    valueMin: drill.topspinMin,
                    rangeMax: globals.oscillationSpeedMax,
                    rangeMin: globals.oscillationSpeedMin,
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: ListViewTile(
                  title: 'Backspin',
                  subtitle: 'How much backspin each abll will have',
                  image: RangeVisualization(
                    valueMax: drill.backspinMax,
                    valueMin: drill.backspinMin,
                    rangeMax: globals.oscillationSpeedMax,
                    rangeMin: globals.oscillationSpeedMin,
                  ),
                ),
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

class AutomaticFiringDrillVisualization extends StatelessWidget {
  final AutomaticDrill drill;

  const AutomaticFiringDrillVisualization({Key key, this.drill})
      : super(key: key);

  Color _getColorFromValue(double value, double rangeMax) {
    double intensityWeight = (rangeMax - value) / rangeMax;

    int red = ((1 - intensityWeight) * 255).floor();
    int green = globals.accentColor.green;
    int blue = ((intensityWeight) * 255).floor();

    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165, // I got this value from trial and error I guess?
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            _getColorFromValue(
                (drill.firingSpeedMin + drill.firingSpeedMax) / 2,
                globals.firingSpeedMax.toDouble()),
            // _getColorFromValue(drill.firingSpeedMax, globals.firingSpeedMax),
            _getColorFromValue(
                (drill.oscillationSpeedMin + drill.firingSpeedMax) / 2,
                globals.oscillationSpeedMax.toDouble()),
            // _getColorFromValue(drill.oscillationSpeedMax, globals.oscillationSpeedMax),
            _getColorFromValue(
                (drill.topspinMin + drill.topspinMax) / 2, globals.topspinMax.toDouble()),
            // _getColorFromValue(drill.topspinMax, globals.topspinMax),
            _getColorFromValue((drill.backspinMin + drill.backspinMax) / 2,
                globals.backspinMax.toDouble()),
            // _getColorFromValue(drill.backspinMax, globals.backspinMax),
          ],
        ),
      ),
    );
  }
}

class RangeVisualization extends StatelessWidget {
  final int valueMax;
  final int valueMin;
  final int rangeMax;
  final int rangeMin;

  const RangeVisualization({
    Key key,
    this.valueMax,
    this.valueMin,
    this.rangeMax,
    this.rangeMin,
  });

  Color _getColorFromValue(int value) {
    double intensityWeight = (rangeMax - value) / rangeMax;

    int red = ((1 - intensityWeight) * 255).floor();
    int green = globals.accentColor.green;
    int blue = ((intensityWeight) * 255).floor();

    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165, // I got this value from trial and error I guess?
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getColorFromValue(valueMin), _getColorFromValue(valueMax)],
        ),
      ),
    );
  }
}

class ListViewTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget image;
  final Function onTap;

  const ListViewTile({
    Key key,
    this.title,
    this.subtitle,
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            child: image,
          ),
          Container(
            color: Colors.black12,
            height: 1,
          ), // Divider() without padding essentially
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
            ),
          )
        ],
      ),
    );
  }
}
