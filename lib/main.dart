import 'package:flutter/material.dart';
import 'package:morpheus/morpheus.dart';

import 'remote_screen.dart';
import 'drill_screen.dart';
import 'settings_screen.dart';

void main() => runApp(PongApp());

class PongApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PingPong',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.yellowAccent,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 1;

  // array storing navigator keys so the back buttin will work properly
  //  class navigatorKeys {
  //   drillScreen: GlobalKey<NavigatorState>();
  //   remoteScreen: GlobalKey<NavigatorState>();
  //   settingsScreen: GlobalKey<NavigatorState>();
  // };

  final navigatorKeys = <GlobalKey<NavigatorState>>[
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        // send signal to the proper state
        onWillPop: () async =>
            !await navigatorKeys[_currentIndex].currentState.maybePop(),
        child: MorpheusTabView(
          curve: Curves.easeInOutSine,
          duration: Duration(milliseconds: 200),
          child: IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              DrillScreen(navigatorKey: navigatorKeys[0]),
              RemoteScreen(navigatorKey: navigatorKeys[1]),
              RemoteScreen(navigatorKey: navigatorKeys[2]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (index != _currentIndex) {
            setState(() {
              setState(() => _currentIndex = index);
            });
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.collections_bookmark),
              backgroundColor: Colors.green,
              title: Text('Drills')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_remote),
              backgroundColor: Colors.deepPurple,
              title: Text('Remote')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              backgroundColor: Colors.grey,
              title: Text('Settings')),
        ],
      ),
    );
  }
}
