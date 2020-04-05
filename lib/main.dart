import 'package:field_photo/Hyperlink.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Welcome to Flutter',
        home: LoginScreen()
    );
  }
}


