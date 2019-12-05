import 'package:flutter/material.dart';

class Drill {
  const Drill(this.title, this.description, this.firingSpeed, this.oscillationFrequency, this.topspin, this.backspin);
  final String title;
  final String description;
  final int firingSpeed;
  final int oscillationFrequency;
  final int topspin;
  final int backspin;
}

class DrillPage extends StatefulWidget {
  DrillPage({Key key}) : super(key: key);

  @override
  _DrillPageState createState() => _DrillPageState();
}

class _DrillPageState extends State<DrillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drills'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: DrillList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // click
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
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
    return ListView.builder(
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
    );
  }
}