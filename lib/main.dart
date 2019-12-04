import 'package:flutter/material.dart';

import 'navigation.dart';
import 'remote_page.dart';

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

List<NavBarItem> navigationPages = <NavBarItem>[
  NavBarItem('Drills', Icons.collections_bookmark, Colors.blue, Text("wow1")),
  NavBarItem('Remote', Icons.settings_remote, Colors.red, RemotePage()),
  NavBarItem('Settings', Icons.settings, Colors.grey, Text("wow3")),
];

class HomePage extends StatefulWidget {
  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: navigationPages.map<Widget>((NavBarItem page) {
            return NavPage(style: page);
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
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