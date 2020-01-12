import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:pingpong/drill_screen/drill_editor_automatic.dart';
import 'package:pingpong/drill_screen/drill_screen.dart';
import 'package:pingpong/app_state.dart';
import 'package:pingpong/networking.dart';
import 'package:pingpong/globals.dart' as globals;

class AutomaticDrillViewer extends StatelessWidget {
  final AutomaticDrill drill;

  AutomaticDrillViewer({
    Key key,
    this.drill,
  }) : super(key: key);

  List<double> generatedNoise = AutomaticDrillValueGraph.generateNoise();

  @override
  Widget build(BuildContext context) {
    AppState appState = AppState.of(context);
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
                value: 'edit',
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {} 
              else if (value == 'delete') {
                serverRequest(context, appState.getServerUrl(), '/api/v1/remove-automatic-drill', params: {'id': drill.id});
                Navigator.of(context).pop();
              }
            },
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
                  image: AutomaticDrillValueGraph(
                    generatedNoise: generatedNoise,
                    noiseFactor: drill.firingSpeedFactor.toDouble(),
                    valueRange: RangeValues(drill.firingSpeedMin.toDouble(), drill.firingSpeedMax.toDouble()),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: ListViewTile(
                  title: 'Oscillation Speed',
                  subtitle: 'How fast the machine moves horizontally',
                  image: AutomaticDrillValueGraph(
                    generatedNoise: generatedNoise,
                    noiseFactor: drill.oscillationSpeedFactor.toDouble(),
                    valueRange: RangeValues(drill.oscillationSpeedMin.toDouble(), drill.oscillationSpeedMax.toDouble()),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: ListViewTile(
                  title: 'Topspin',
                  subtitle: 'How much topspin each ball will have',
                  image: AutomaticDrillValueGraph(
                    generatedNoise: generatedNoise,
                    noiseFactor: drill.topspinFactor.toDouble(),
                    valueRange: RangeValues(drill.topspinMin.toDouble(), drill.topspinMax.toDouble()),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.fromLTRB(6, 12, 6, 12),
                child: ListViewTile(
                  title: 'Backspin',
                  subtitle: 'How much backspin each abll will have',
                  image: AutomaticDrillValueGraph(
                    generatedNoise: generatedNoise,
                    noiseFactor: drill.backspinFactor.toDouble(),
                    valueRange: RangeValues(drill.backspinMin.toDouble(), drill.backspinMax.toDouble()),
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