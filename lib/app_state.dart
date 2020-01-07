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
  };

  AppState({ this.child }) : super(child: child);

  setFiringSpeed(int firingSpeed) {
    _data['firingSpeed'] = firingSpeed;
  }

  setOscillationSpeed(int firingSpeed) {
    _data['firingSpeed'] = firingSpeed;
  }

  setTopspin(int firingSpeed) {
    _data['firingSpeed'] = firingSpeed;
  }

  setBackspin(int firingSpeed) {
    _data['firingSpeed'] = firingSpeed;
  }

  setFiringState(bool firingState) {
    _data['firingState'] = firingState;
  }

  get data => _data;

  @override
  bool updateShouldNotify(AppState oldWidget) => true;

  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppState>();
}