import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fast_noise/fast_noise.dart';

import 'package:pingpong/globals.dart' as globals;
import 'package:pingpong/networking.dart';
import 'package:pingpong/app_state.dart';

class AutomaticDrill {
  AutomaticDrill({
    this.title = 'title',
    this.description = 'description',
    this.id,
    this.listIndex,
    this.firingSpeedMin = 0,
    this.firingSpeedMax = 255,
    this.firingSpeedFactor = 8,
    this.oscillationSpeedMin = 0,
    this.oscillationSpeedMax = 255,
    this.oscillationSpeedFactor = 8,
    this.topspinMin = 0,
    this.topspinMax = 255,
    this.topspinFactor = 8,
    this.backspinMin = 0,
    this.backspinMax = 255,
    this.backspinFactor = 8,
  });

  String title;
  String description;

  String id;
  int listIndex;

  int firingSpeedMin;
  int firingSpeedMax;
  int firingSpeedFactor;
  int oscillationSpeedMin;
  int oscillationSpeedMax;
  int oscillationSpeedFactor;
  int topspinMin;
  int topspinMax;
  int topspinFactor;
  int backspinMin;
  int backspinMax;
  int backspinFactor;

  bool addToServer(context) {
    AppState appState = AppState.of(context);

    serverRequest(
      context,
      appState.getServerUrl(),
      '/api/v1/add-automatic-drill',
      params: {
        'title': '$title',
        'description': '$description',
        'firing-speed-max': '$firingSpeedMax',
        'firing-speed-min': '$firingSpeedMin',
        'firing-speed-factor': '$firingSpeedFactor',
        'oscillation-speed-max': '$oscillationSpeedMax',
        'oscillation-speed-min': '$oscillationSpeedMin',
        'oscillation-speed-factor': '$oscillationSpeedFactor',
        'topspin-max': '$topspinMax',
        'topspin-min': '$topspinMin',
        'topspin-factor': '$topspinFactor',
        'backspin-max': '$backspinMax',
        'backspin-min': '$backspinMin',
        'backspin-factor': '$backspinFactor',
      },
    );
    return true;
  }

  static AutomaticDrill fromJSON(Map<dynamic, dynamic> value) {
    return AutomaticDrill(
      title: value['title'],
      description: value['description'],
      id: value['uuid'],
      listIndex: value['listIndex'],
      firingSpeedMin: value['firingSpeed']['min'],
      firingSpeedMax: value['firingSpeed']['max'],
      firingSpeedFactor: value['firingSpeed']['noiseFactor'],
      oscillationSpeedMin: value['oscillationSpeed']['min'],
      oscillationSpeedMax: value['oscillationSpeed']['max'],
      oscillationSpeedFactor: value['oscillationSpeed']['noiseFactor'],
      topspinMin: value['topspin']['min'],
      topspinMax: value['topspin']['max'],
      topspinFactor: value['topspin']['noiseFactor'],
      backspinMin: value['backspin']['min'],
      backspinMax: value['backspin']['max'],
      backspinFactor: value['backspin']['noiseFactor'],
    );
  }
}

class AutomaticDrillEditor extends StatelessWidget {
  AutomaticDrillEditor({
    Key key,
  }) : super(key: key);

  final formKey = GlobalKey<FormState>();

  final AutomaticDrill editingDrill = AutomaticDrill();

  @override
  Widget build(BuildContext context) {
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title',
                          ),
                          textCapitalization: TextCapitalization.words,
                          onChanged: (String value) {
                            editingDrill.title = value.trim();
                          },
                          validator: (text) {
                            if (text == '') {
                              return 'Please add a title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12), //
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (String value) {
                            editingDrill.description = value.trim();
                          },
                          validator: (text) {
                            if (text == '') {
                              return 'Please add a description';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
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
            AutomaticDrillRangeEditingCard(
              title: "Firing Speed",
              max: globals.firingSpeedMax,
              min: globals.firingSpeedMin,
              onChanged: (int start, int end, int factor) async {
                editingDrill.firingSpeedMin = start;
                editingDrill.firingSpeedMax = end;
                editingDrill.firingSpeedFactor = factor;
              },
            ),
            AutomaticDrillRangeEditingCard(
              title: "Oscillation Speed",
              max: globals.oscillationSpeedMax,
              min: globals.oscillationSpeedMin,
              onChanged: (int start, int end, int factor) async {
                editingDrill.oscillationSpeedMin = start;
                editingDrill.oscillationSpeedMax = end;
                editingDrill.oscillationSpeedFactor = factor;
              },
            ),
            AutomaticDrillRangeEditingCard(
              title: "Topspin",
              max: globals.topspinMax,
              min: globals.topspinMin,
              onChanged: (int start, int end, int factor) async {
                editingDrill.topspinMin = start;
                editingDrill.topspinMax = end;
                editingDrill.topspinFactor = factor;
              },
            ),
            AutomaticDrillRangeEditingCard(
              title: "Backspin",
              max: globals.backspinMax,
              min: globals.topspinMin,
              onChanged: (int start, int end, int factor) async {
                editingDrill.backspinMin = start;
                editingDrill.backspinMax = end;
                editingDrill.backspinFactor = factor;
              },
            ),
            SizedBox(
              // for FAB
              height: 72,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: globals.accentColor,
        onPressed: () {
          if (formKey.currentState.validate()) {
            editingDrill.addToServer(context);
            globals.rootNaviagatorKey.currentState.pop();
          }
        },
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class AutomaticDrillRangeEditingCard extends StatefulWidget {
  final String title;
  final int max;
  final int min;
  final Function(int, int, int) onChanged;

  AutomaticDrillRangeEditingCard(
      {Key key, this.title, this.max, this.min, this.onChanged})
      : super(key: key);

  @override
  _AutomaticDrillRangeEditingCardState createState() =>
      _AutomaticDrillRangeEditingCardState();
}

class _AutomaticDrillRangeEditingCardState
    extends State<AutomaticDrillRangeEditingCard> {
  int rangeStart = 0;
  int rangeEnd = 255;

  double noiseFactor = 8;
  RangeValues valueRange = RangeValues(0.0, 255.0);

  _AutomaticDrillRangeEditingCardState({Key key});

  List<double> generatedNoise = AutomaticDrillValueGraph.generateNoise();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutomaticDrillValueGraph(
              generatedNoise: generatedNoise,
              noiseFactor: noiseFactor,
              valueRange: valueRange,
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${widget.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${this.valueRange.start.floor()}-${this.valueRange.end.floor()}',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            RangeSlider(
              // value slider
              max: widget.max.toDouble(),
              min: widget.min.toDouble(),
              onChanged: (RangeValues values) {
                widget.onChanged(values.start.floor(), values.end.floor(),
                    noiseFactor.floor());

                setState(() {
                  this.valueRange = values;
                });
              },
              values: valueRange,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Noise Factor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${this.noiseFactor.floor()}',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Slider(
              // value slider
              max: 64,
              min: 8,
              value: noiseFactor,
              onChanged: (double value) {
                widget.onChanged(valueRange.start.floor(),
                    valueRange.end.floor(), value.floor());

                setState(() {
                  noiseFactor = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AutomaticDrillValueGraph extends StatelessWidget {
  AutomaticDrillValueGraph({
    this.generatedNoise,
    this.noiseFactor,
    this.valueRange,
    Key key,
  }) : super(key: key);

  List<double> generatedNoise;
  double noiseFactor;
  RangeValues valueRange;

  static List<double> generateNoise() {
    return noise2(1, 256,
        noiseType: NoiseType.SimplexFractal,
        seed: math.Random().nextInt(256),
        gain: 5000,
        octaves: 3,
        frequency: 0.075)[0];
  }

  LineChartData formatData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: noiseFactor.floorToDouble() - 1,
      minY: 0,
      maxY: 255,
      lineTouchData: LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: List<FlSpot>.generate(noiseFactor.floor(), (x) {
            double lowest = generatedNoise.reduce(math.min);
            double highest = generatedNoise.reduce(math.max);

            double localNoise =
                (((generatedNoise[x] - lowest) / (highest - lowest)) *
                        (valueRange.end - valueRange.start)) +
                    valueRange.start;

            return FlSpot(x.toDouble(), localNoise);
          }),
          isCurved: true,
          colors: <Color>[Colors.lightBlue],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            colors: <Color>[
              Colors.lightBlue.withOpacity(0.3),
              Colors.lightBlue.withOpacity(0),
            ],
            gradientColorStops: [0.5, 1.0],
            gradientFrom: const Offset(0, 0),
            gradientTo: const Offset(0, 1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 160,
          child: Row(children: <Widget>[
            Expanded(
              flex: 1,
              child: LineChart(formatData()),
            ),
          ]),
        ),
      ],
    );
  }
}
