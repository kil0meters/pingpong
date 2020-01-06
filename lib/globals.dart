library pingpong.globals;

import 'package:flutter/material.dart';

const double firingSpeedMax = 255;
const double firingSpeedMin = 0;

const double oscillationSpeedMax = 255;
const double oscillationSpeedMin = 0;

const double backspinMax = 255;
const double backspinMin = 0;

const double topspinMax = 255;
const double topspinMin = 0;

final Color accentColor = Colors.indigoAccent[700];
final Color errorAccentColor = Colors.redAccent[700];

String serverUrl = '10.0.2.2'; // development port/url (10.0.2.2 redirects to localhost in Android emu)
bool isFiring = false;