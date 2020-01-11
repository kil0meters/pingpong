import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_state.dart';

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
    AppState appState = AppState.of(context);
    RegExp ipValidatorRegex = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');

    final _formKey = GlobalKey<FormState>();

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
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: appState.data['serverUrl'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Server Address',
                        helperText: 'The IP address of your Rasperry Pi',
                      ),
                      onChanged: (value) async {
                        if (ipValidatorRegex.hasMatch(value.trim())) {
                          appState.setServerUrl(value.trim());
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('serverUrl', value);
                        }
                      },
                      validator: (value) {
                        if (!ipValidatorRegex.hasMatch(value.trim())) {
                          return 'Invalid IP address';
                        }
                        return null;
                      }
                    ),
                  ],
                ),
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
