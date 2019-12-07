import 'package:flutter/material.dart';

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

class SettingsList extends StatelessWidget {
  const SettingsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}