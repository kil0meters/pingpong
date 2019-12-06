import 'package:flutter/material.dart';
import 'package:morpheus/morpheus.dart';

import 'remote_page.dart';
import 'drill_editor.dart';
import 'settings_menu.dart';

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

class NavBarItem {
  const NavBarItem(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

class HomePage extends StatefulWidget {
  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 1;

  final List<NavBarItem> navigationPages = <NavBarItem>[
    NavBarItem('Drills', Icons.collections_bookmark, Colors.green),
    NavBarItem('Remote', Icons.settings_remote, Colors.deepPurple),
    NavBarItem('Settings', Icons.settings, Colors.grey),
  ];


  final List<Widget> _screens = <Widget>[
    DrillPage(),
    RemotePage(),
    RemotePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MorpheusTabView(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            if (index != _currentIndex) {
              setState(() => _currentIndex = index);
            }
          });
        },
        items: navigationPages.map((NavBarItem page) {
          return BottomNavigationBarItem(
            icon: Icon(page.icon),
            backgroundColor: page.color,
            title: Text(page.title)
          );
        }).toList(),
      ),
    );
  }
}