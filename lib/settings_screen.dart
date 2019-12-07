import 'package:flutter/material.dart';

import 'sliders.dart';
import 'globals.dart' as globals;

class SettingsScreen extends StatelessWidget {
  final GlobalKey navigatorKey;

  SettingsScreen({Key key, this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Navigator(
        key: navigatorKey,
        onGenerateRoute: (RouteSettings settings ) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              switch(settings.name) {
                case '/':
                  return SettingsList();
                default:
                  return Text('ERROR - this should never happen');
              }
            }
          );
        }
      )
    );
  }
}

class SettingsList extends StatefulWidget {
  const SettingsList({
    Key key,
  }) : super(key: key);

  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Text(
            'Connection',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
        ),
        Card(
          margin: EdgeInsets.all(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: <Widget> [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Server Address',
                    helperText: 'The IP address of your Rasperry Pi',
                  )
                ),
                SizedBox(height: 12), // --------------------
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Authorization Key',
                    helperText: 'Go to Authorized Devices > New in the web portal'
                  )
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
        ),
        Card(
          elevation: 1,
          margin: EdgeInsets.all(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Made with 🏓 by:\n',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                Text('• kilometers\n\n• Joshua Yu'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}