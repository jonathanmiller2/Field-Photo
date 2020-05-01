import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'LoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  static Geolocator geolocator = Geolocator();
  static CameraController cameraController;

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: LoginScreen()
    );
  }
}


