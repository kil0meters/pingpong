import 'package:flutter/material.dart';

// for storing mutable global data
class AppState extends InheritedWidget {
  final Widget child;
  final Map _data = {
    'firingSpeed': 0,
    'oscillationSpeed': 0,
    'topspin': 0,
    'backspin': 0,
    'firingState': false,
    'serverUrl': '',
    'isLoading': true,
  };

  AppState({ this.child }) : super(child: child);

  setFiringSpeed(int firingSpeed) {
    _data['firingSpeed'] = firingSpeed;
  }

  setOscillationSpeed(int firingSpeed) {
    _data['oscillationSpeed'] = firingSpeed;
  }

  setTopspin(int firingSpeed) {
    _data['topspin'] = firingSpeed;
  }

  setBackspin(int firingSpeed) {
    _data['backspin'] = firingSpeed;
  }

  setFiringState(bool firingState) {
    _data['firingState'] = firingState;
  }

  setServerUrl(String serverUrl) {
    _data['serverUrl'] = serverUrl;
  }

  getServerUrl() {
    return _data['serverUrl'] + ':5858';
  }

  finishedLoading() {
    _data['isLoading'] = false;
  }

  get data => _data;

  @override
  bool updateShouldNotify(AppState oldWidget) => true;

  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppState>();
}