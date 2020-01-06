library pingpong.globals;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const int firingSpeedMax = 255;
const int firingSpeedMin = 0;

const int oscillationSpeedMax = 255;
const int oscillationSpeedMin = 0;

const int backspinMax = 255;
const int backspinMin = 0;

const int topspinMax = 255;
const int topspinMin = 0;

final Color accentColor = Colors.indigoAccent[700];
final Color errorAccentColor = Colors.redAccent[700];

int currentFiringSpeed = 0;
int currentOscillationSpeed = 0;
int currentTopspin = 0;
int currentBackspin = 0;
bool firingState = false;

String serverUrl = '';

Future<bool> initializeValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  serverUrl = (prefs.getString('serverUrl') ?? '');

  if (serverUrl != '') {
    http.Response machineStateResponse = await http.get(Uri.http('$serverUrl', '/api/v1/get-machine-state'));
    if (machineStateResponse.statusCode == 200) {
      Map<String, dynamic> machineState = json.decode(machineStateResponse.body);
      currentFiringSpeed = machineState['firingSpeed'];
      currentOscillationSpeed = machineState['oscillationSpeed'];
      currentTopspin = machineState['topspin'];
      currentBackspin = machineState['backspin'];
      firingState = machineState['firingState'];

      print('Preloaded configuraiton form server: $serverUrl');
      print('currentFiringSpeed: $currentFiringSpeed');
      print('currentOscillationSpeed: $currentOscillationSpeed');
      print('currentTopspin: $currentTopspin');
      print('currentBackspin: $currentBackspin');
      print('firingState: $firingState');
    }
  }

  return true;
}
