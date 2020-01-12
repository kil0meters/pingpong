import 'package:flutter/material.dart';
import 'package:morpheus/morpheus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'globals.dart' as globals;
import 'remote_screen.dart';
import 'drill_screen/drill_screen.dart';
import 'drill_screen/drill_editor_automatic.dart';
import 'settings_screen.dart';
import 'app_state.dart';
import 'networking.dart';

void main() => runApp(PingPongRoot());

class PingPongRoot extends StatefulWidget {
  // This widget is the root of your application.
  @override
  PingPongRootState createState() => PingPongRootState();

}

class PingPongRootState extends State<PingPongRoot> {
  List<AutomaticDrill> drills = [];

  void addAutomaticDrill(AutomaticDrill drill) {
    setState(() {
      drills.add(drill);
    });
  }

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
        accentColor: globals.accentColor,
      ),
      home: AppState(child: PingPongContainer()),
      // home: FutureBuilder<bool>(
      //   future: globals.initializeValues(),
      //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return AppState(child: PingPongContainer());
      //     } else {
      //       return Text("loading");
      //     }
      //   }
      // ),
    );
  }
}

class PingPongContainer extends StatefulWidget {
  @override
  PingPongContainerState createState() => PingPongContainerState();
}

class PingPongContainerState extends State<PingPongContainer>
    with TickerProviderStateMixin<PingPongContainer> {
  int _currentIndex = 1;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppState appState = AppState.of(context);

    appState.setServerUrl(prefs.getString('serverUrl') ?? '');

    if (appState.getServerUrl() != ':5858') {
      try {
        http.Response machineStateResponse = await http.get(Uri.http(
            '${appState.getServerUrl()}', '/api/v1/get-machine-state'))
            .timeout(Duration(seconds: 2));

        Map<String, dynamic> machineState =
            json.decode(machineStateResponse.body);

        appState.setFiringSpeed(machineState['firingSpeed']);
        appState.setOscillationSpeed(machineState['oscillationSpeed']);
        appState.setTopspin(machineState['topspin']);
        appState.setBackspin(machineState['backspin']);
        appState.setFiringState(machineState['firingState']);
      } catch (error) {
        scaffoldKey.currentState
            .showSnackBar(errorSnackBar('Could not find server'));
      }
    }

    setState(() {
      appState.finishedLoading();
    });
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: WillPopScope(
        onWillPop: () async => !await globals.rootNaviagatorKey.currentState.maybePop(),
        child: Navigator(
          key: globals.rootNaviagatorKey,
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                return MorpheusTabView(
                  curve: Curves.easeInOutSine,
                  duration: Duration(milliseconds: 200),
                  child: IndexedStack(
                    index: _currentIndex,
                    children: <Widget>[
                      DrillScreen(),
                      RemoteScreen(),
                      SettingsScreen(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
              backgroundColor: Colors.blueGrey,
              title: Text('Settings')),
        ],
      ),
    );
  }
}
