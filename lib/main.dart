import 'package:camera/camera.dart';
import 'package:field_photo/SignedInScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localizations.dart';

import 'LoginScreen.dart';
import 'LoginSession.dart';
import 'constants.dart' as Constants;

void main() async {
  await initialLogin();
  LoginSession.shared.loggedIn ??= false;
  
  Locale chosenLocale;
  
  List<Locale> locales = WidgetsBinding.instance.window.locales;
  for(Locale l in locales)
  {
    if(AppLocalizations.delegate.isSupported(l))
    {
      chosenLocale = l;
    }
  }
  
  if(chosenLocale != null)
  {
    await AppLocalizations.delegate.load(chosenLocale);
  }
  else
  {
    await AppLocalizations.delegate.load(Locale('en'));
  }
  
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  
  static Geolocator geolocator = Geolocator();
  static CameraController cameraController;
  
  @override
  Widget build(BuildContext context) {
    
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    Widget child;
    
    if(LoginSession.shared.loggedIn)
    {
      child = SignedInScreen();
    }
    else
    {
      child = LoginScreen();
    }
    
    return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Constants.SUPPORTED_LOCALES,
        home: child
    );
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
    LoginSession.shared.loggedIn = false;
    return false;
  }
  
  if(username == null || password == null)
  {
    print("Username or password were null on initial login");
    LoginSession.shared.loggedIn = false;
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
  
  /*
  print('Response status: ${response.statusCode}');
  print('Response header: ${response.headers}');
  */
  
  if(response.statusCode == 200)
  {
    LoginSession.shared.loggedIn = true;
    LoginSession.shared.username = username;
    LoginSession.shared.password = password;
    return true;
  }
  
  LoginSession.shared.loggedIn = false;
  return false;
}



