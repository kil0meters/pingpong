import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fast_noise/fast_noise.dart';

import 'package:pingpong/globals.dart' as globals;
import 'package:pingpong/main.dart';

class AutomaticDrill {
  AutomaticDrill({
    this.title,
    this.description,
    this.firingSpeedMin = globals.firingSpeedMin,
    this.firingSpeedMax = globals.firingSpeedMax,
    this.oscillationSpeedMin = globals.oscillationSpeedMin,
    this.oscillationSpeedMax = globals.oscillationSpeedMax,
    this.topspinMin = globals.topspinMin,
    this.topspinMax = globals.topspinMax,
    this.backspinMin = globals.backspinMin,
    this.backspinMax = globals.backspinMax,
  });

  String title;
  String description;

  int firingSpeedMin;
  int firingSpeedMax;
  int oscillationSpeedMin;
  int oscillationSpeedMax;
  int topspinMin;
  int topspinMax;
  int backspinMin;
  int backspinMax;

  static AutomaticDrill copy(AutomaticDrill drill) {
    return AutomaticDrill(
      title: drill.title,
      description: drill.description,
      firingSpeedMin: drill.firingSpeedMin,
      firingSpeedMax: drill.firingSpeedMax,
      oscillationSpeedMin: drill.oscillationSpeedMin,
      oscillationSpeedMax: drill.oscillationSpeedMax,
      topspinMin: drill.topspinMin,
      topspinMax: drill.topspinMax,
      backspinMin: drill.backspinMin,
      backspinMax: drill.backspinMax,
    );
  }
}

class AutomaticDrillEditor extends StatelessWidget {
  AutomaticDrillEditor({
    Key key,
  }) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AutomaticDrill editingDrill =
        new AutomaticDrill(title: "title", description: "description");

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
                            editingDrill.title = value;
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
                            editingDrill.description = value;
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
            RangeEditingCard(
              title: "Firing Speed",
              max: globals.firingSpeedMax,
              min: globals.firingSpeedMin,
              onChanged: (RangeValues values) async {
                editingDrill.firingSpeedMin = values.start.floor();
                editingDrill.firingSpeedMax = values.end.floor();
              },
            ),
            RangeEditingCard(
              title: "Oscillation Speed",
              max: globals.oscillationSpeedMax,
              min: globals.oscillationSpeedMin,
              onChanged: (RangeValues values) async {
                editingDrill.oscillationSpeedMin = values.start.floor();
                editingDrill.oscillationSpeedMax = values.end.floor();
              },
            ),
            RangeEditingCard(
              title: "Topspin",
              max: globals.topspinMax,
              min: globals.topspinMin,
              onChanged: (RangeValues values) async {
                editingDrill.topspinMin = values.start.floor();
                editingDrill.topspinMax = values.end.floor();
              },
            ),
            RangeEditingCard(
              title: "Backspin",
              max: globals.backspinMax,
              min: globals.topspinMin,
              onChanged: (RangeValues values) async {
                editingDrill.backspinMin = values.start.floor();
                editingDrill.backspinMax = values.end.floor();
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
            PingPongRoot.of(context)
                .addAutomaticDrill(AutomaticDrill.copy(editingDrill));
            Navigator.of(context).pop();
          }
          else {

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

class RangeEditingCard extends StatefulWidget {
  final String title;
  final int max;
  final int min;
  final Function(RangeValues) onChanged;

  RangeEditingCard({Key key, this.title, this.max, this.min, this.onChanged})
      : super(key: key);

  @override
  _RangeEditingCardState createState() => _RangeEditingCardState();
}

class _RangeEditingCardState extends State<RangeEditingCard> {
  int rangeStart = 0;
  int rangeEnd = 255;

  double noiseFactor = 8;
  RangeValues valueRange = RangeValues(0.0, 255.0);

  _RangeEditingCardState({Key key});

  List<double> generatedNoise = noise2(1, 256,
          noiseType: NoiseType.SimplexFractal,
          seed: math.Random().nextInt(256),
          gain: 5000,
          octaves: 3,
          frequency: 0.075)[0]
      .map((index) => (index + 1) * 128)
      .toList();

  LineChartData mainData() {
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
            double localNoise = math.max(generatedNoise[x], valueRange.start);
            localNoise = math.min(localNoise, valueRange.end);

            return FlSpot(x.toDouble(), localNoise);
          }),
          isCurved: true,
          colors: <Color>[Colors.lightBlue],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
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
    return Card(
      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 128,
              child: Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: LineChart(mainData()),
                ),
              ]),
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
                widget.onChanged(values);

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
