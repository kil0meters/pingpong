import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:morpheus/morpheus.dart';
import 'package:http/http.dart' as http;

import 'package:pingpong/globals.dart' as globals;
import 'package:pingpong/drill_screen/drill_editor_automatic.dart';
import 'package:pingpong/drill_screen/drill_editor_manual.dart';
import 'package:pingpong/drill_screen/drill_viewer_automatic.dart';
import 'package:pingpong/app_state.dart';
import 'package:pingpong/networking.dart';

class DrillScreen extends StatefulWidget {
  DrillScreen({Key key}) : super(key: key);

  @override
  _DrillScreenState createState() => _DrillScreenState();
}

class _DrillScreenState extends State<DrillScreen>
    with TickerProviderStateMixin<DrillScreen> {

  AnimationController _controller;
  Animation _animation;
  CurvedAnimation _curve;

  Future<List<AutomaticDrill>> fetchDrillList() async {
    AppState appState = AppState.of(context);

    http.Response response = await serverRequest(context, appState.getServerUrl(), '/api/v1/list-automatic-drills')
      .timeout(Duration(seconds: 2));

    var responseJson = json.decode(response.body);

    List<AutomaticDrill> drills = [];

    for (var drill in responseJson) {
      drills.add(AutomaticDrill.fromJSON(drill));
    }

    return drills;
  }

  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_curve);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drills'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: fetchDrillList(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          Widget child;

          if (snapshot.hasData) {
            _controller.forward();

            child = FadeTransition(
              opacity: _animation,
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 96),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                  _buildCard(context, index, snapshot.data),
              ),
            );
          } else if (snapshot.hasError) {
            child = Text('${snapshot.error}');
          } else {
            child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Loading...'),
                )
              ],
            );
          }

          return Container(child: child,);
        }
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
            builder: (context) => new AutomaticDrillViewer(drill: drill),
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
                globals.rootNaviagatorKey.currentState.push(
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
                globals.rootNaviagatorKey.currentState.push(
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
