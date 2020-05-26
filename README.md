# Field Photo

This project is a iPhone/Android app for the Earth Observation and Modelling Facility at the University of Oklahoma. The app is written with Flutter, which uses the Dart programming language.

# What to do when this app breaks

This app will likely break for three reasons:
- The interface between the app and the EOMF website changes
- Packages update and change their API's
- Strange, corner-case bugs crop up

If specifically the register function stops working, it is likely due to the two constant strings in the constants.dart file. For whatever reason, custom endpoints for registering were never used in the first app. This means that the app receives the HTML for what the website would be showing if you had a browser, and then scrapes that HTML to figure out why your registration failed. If the website changes the wording of the "Username taken" or "email taken" message, the app will break. You'll have to manually reset those fields in constants.dart.

If specifically land cover classes are being put into the database incorrectly, it is likely due to the landcover mapping in the constants.dart file. The number-landcover pairs should match the EOMF admin website's number-landcover pairs (in the "Categories" section). 

Otherwise, look at the constants.dart file, and check that each URL is still correct. You can check them by sending requests, or by looking at the urls.py files on the server to make sure the server is still handling those URLs. 
Make sure the app is checking for the right HTTP status codes. If the server changes it's response codes or response messages, it's possible that the app will start misbehaving.

If corner-case bugs crop up, and you absolutely cannot figure out how the app works or what's going on, you can try e-mailing me at jonathanmiller2@hotmail.com. Hopefully I'll remember enough to help.

## Info for Future Maintainers


To make changes to this app, you need to [install Flutter's tools](https://flutter.dev/docs/get-started/install) onto your computer and open the project via Android Studio (Windows) or XCode (Apple).

Every file represents a different screen/widget of the app. If a particular screen is broken, that screen's file is a good place to start. 
- main.dart
- constants.dart
- ImageSquare.dart - The preview squares displayed in the library
- LabelledInvisibleButton.dart - Buttons that only show the text, rather than a colored box like Flutter buttons
- CameraPassthrough.dart - The camera's view, shown on the Camera Screen
- MainBottomBar.dart - The bottom bar with the library, camera, and info buttons
- MainCameraButton.dart
- PositionIndicator.dart - A generalized handler for getting the current position/direction. Also is responsible for the coordinate text under the camera passthrough on the camera screen.
- ImagePreviewScreen.dart - 
- ImageInfoEntryScreen.dart - 
- SignedInScreen.dart - The screen that displays your current username with a logout button
- SignupScreen.dart - The screen where you register a new account
- LoginScreen.dart
- InfoScreen.dart - The screen that explains what the EOMF does
- CameraScreen.dart
- LibraryScreen.dart - The screen with the image library
- ImageDetailScreen.dart - The screen that shows after tapping an image square in the library that showsthe image and the entered details 


This app interfaces with the [EOMF website](http://eomf.ou.edu/). It uses the following endpoints on the website to operate. 
- Upload: http://eomf.ou.edu/photos/mobile/upload3/
- Register: http://eomf.ou.edu/accounts/register/
- Login: http://eomf.ou.edu/accounts/mobile_login/
- Logout: http://eomf.ou.edu/accounts/logout

Be warned, these endpoints are janky. Currently, these are hosted on OU's Mangrove machine, however this will likely be changing soon. If you don't know which machine the website is being hosted on, you can hunt down which server has the code by logging into each machine and using the locate command to locate the folder "eomf-admin", which should contain all the code required.

In the future, packages may update and ruin the stability of the app.
The first draft of the app used these packages:

- url_launcher: ^5.0.2
- provider: ^4.0.0
- camera: ^0.5.2+1
- path_provider: ^1.1.0
- path: ^1.6.2
- esys_flutter_share: ^1.0.2
- geolocator: ^5.1.3
- shared_preferences: ^0.5.6
- sqflite: ^1.3.0
- http: ^0.12.1
- http_parser: ^3.1.4
- permission_handler: ^5.0.0
- flutter_compass: ^0.4.1

- flutter_launcher_icons: ^0.7.5
