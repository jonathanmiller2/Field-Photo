import 'package:field_photo/PositionIndicator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'LoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  static var geolocator = Geolocator();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: LoginScreen()
    );
  }
}


