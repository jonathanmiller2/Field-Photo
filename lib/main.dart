import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'LoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  static Geolocator geolocator = Geolocator();
  static CameraController cameraController;

  static const Map<int, String> landcoverClassMap =
  {0: 'Unclassified',
    1:'Evergreen Needleleaf Forest',
    2:'Evergreen Broadleaf Forest',
    3:'Deciduous Needleleaf Forest',
    4:'Deciduous broadleaf Forest',
    5:'Mixed Forest',
    6:'Closed Shrublands',
    7:'Open Shrublands',
    8:'Woody Savannas',
    9:'Savannas',
    10:'Grasslands',
    11:'Permanent Wetlands',
    12:'Croplands',
    13:'Urban and Built-Up',
    14:'Cropland/Natural Vegetation Mosaic',
    15:'Snow and Ice',
    16:'Barren or Sparsely Vegetated',
    17:'Water Body',};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: LoginScreen()
    );
  }
}


