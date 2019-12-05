import 'package:flutter/material.dart';

class NavBarItem {
  const NavBarItem(this.title, this.icon, this.color, this.body);
  final String title;
  final IconData icon;
  final MaterialColor color;
  final Widget body;
}

class NavPage extends StatefulWidget {
  NavPage({Key key, this.style}) : super(key: key);

  final NavBarItem style;

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override 
  void initState() {
    super.initState();

  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.style.title}'),
        backgroundColor: widget.style.color,
      ),
      backgroundColor: widget.style.color[100],
      body: widget.style.body,
    );
  }
}