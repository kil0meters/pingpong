import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pingpong/globals.dart' as globals;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // _serverUrlController.text = globals.serverUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Text(
              'Connection',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: globals.serverUrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Server Address',
                      helperText: 'The IP address of your Rasperry Pi',
                    ),
                    onChanged: (value) async {
                      setState(() {
                        globals.serverUrl = value;
                      });
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('serverUrl', value);
                    },
                  ),
                  SizedBox(height: 12), // --------------------
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Authorization Key',
                      helperText:
                          'Go to Authorized Devices > New in the web portal',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Text(
              'About',
              style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• kilometers\n\n• Joshua Yu'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
