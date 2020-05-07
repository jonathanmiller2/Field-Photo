import 'package:camera/camera.dart';
import 'package:field_photo/SignedInScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'constants.dart' as Constants;

import 'LoginScreen.dart';

void main() async {
  bool isLoggedIn = await initialLogin();
  
  if(isLoggedIn)
    {
      print('initial login succeed p2');
    }
  else
  {
    print('initial login failed p2');
  }
  
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  
  static Geolocator geolocator = Geolocator();
  static CameraController cameraController;
  
  final bool isLoggedIn;
  
  MyApp({this.isLoggedIn = false});
  
  @override
  Widget build(BuildContext context) {
    
    if(isLoggedIn) {
      
      print('initial login succeed p3');
      
      return MaterialApp(
        home: SignedInScreen()
      );
    }
    else {
      print('initial login failed p3');
      return MaterialApp(
          home: LoginScreen()
      );
    }
  }
}


Future<bool> initialLogin() async {
  
  String username;
  String password;

  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('savedUsername');
    password = prefs.getString('savedPassword');
  }
  catch(e)
  {
    print("Shared preferences failed on initial login");
    print(e.toString());
    return false;
  }
  
  if(username == null || password == null)
  {
    print("Username or password were null on initial login");
    return false;
  }
  
  //Make a request to the register url for CSRF token
  http.Response response = await http.get(Constants.REGISTER_URL);
  String rawCookie = response.headers['set-cookie'];
  String justToken;
  
  int startIndex = rawCookie.indexOf('=') + 1;
  int stopIndex = rawCookie.indexOf(';');
  justToken = (startIndex == -1 || stopIndex == -1) ? rawCookie : rawCookie.substring(startIndex, stopIndex);
  
  Map<String, String> header = {
    'cookie': response.headers.toString(),
  };
  
  Map<String, String> body = {
    'username': username,
    'password': password,
    'csrfmiddlewaretoken': justToken,
  };
  
  response = await http.post(Constants.LOGIN_URL, headers:header, body:body);
  print('Response status: ${response.statusCode}');
  print('Response header: ${response.headers}');
  
  
  //For whatever reason, the EOMF API returns 302 (Moved) when the username/pw is correct, and returns 200 with a webpage when the username/pw is incorrect
  //TODO: Investigate this further.
  if(response.statusCode == 302) {
    print('initial login succeed p1');
    return true;
  }

  print('initial login failed p1');
  return false;
}



