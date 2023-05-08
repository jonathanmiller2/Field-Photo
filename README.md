# Field Photo

This project is a iPhone/Android app for the Earth Observation and Modelling Facility at the University of Oklahoma. The app is written with Flutter, which uses the Dart programming language.

# What to do when this app breaks

This app will likely break for three reasons:
- The interface between the app and the EOMF website changes
- Packages update and change their API's
- Strange, corner-case bugs crop up

If specifically land cover classes are being put into the database incorrectly, it is likely due to the landcover mapping in the constants.dart file. The number-landcover pairs should match the CEOM admin website's number-landcover pairs (in the "Categories" section). (ALSO, SEE THE IMPORTANT TRANSLATION NOTE BELOW)

Otherwise, look at the constants.dart file, and check that each URL is still correct. You can check them by sending requests, or by looking at the urls.py files on the server to make sure the server is still handling those URLs. 
Make sure the app is checking for the right HTTP status codes. If the server changes its response codes or response messages, it's possible that the app will start misbehaving.

If corner-case bugs crop up, and you absolutely cannot figure out how the app works or what's going on, you can try e-mailing me at jonathanmiller2@hotmail.com. Hopefully I'll remember enough to help.

## Info for Future Maintainers

To make changes to this app, you need to [install Flutter's tools](https://flutter.dev/docs/get-started/install) onto your computer and open the project via Android Studio (Windows) or XCode (Apple).

Every file represents a different screen/widget of the app. If a particular screen is broken, that screen's file is a good place to start.

IMPORTANT NOTE: If you need to change any of the wording, or if you are adding new text, you will need to know how the localization system works. Basically, all text gets run through `AppLocalizations.of(context).translate("A keyword to lookup in a JSON translation file")`. On startup, the app will read from the device's OS to figure out which locale/language is appropriate, then read from the JSON file associated with that locale. It defaults to English if a locale is missing. When you call `.translate` as shown above, it looks up the string you pass it in the JSON translation file associated with the chosen locale. It will return the value associated with the string key you pass it.

If you add text, you will need to add the translated version of that text to **EVERY** JSON translation file. If you don't, people using other languages will just see a big red error.

To add a language, you need to add a new JSON translation file to /assets/locale/ titled "xx.json" where "xx" is the ISO language code for the new language. The formatting for this file can be found in the other JSON files. **You need to register the new JSON asset in the pubspec.yaml.** Otherwise you would get an unexplained "could not read file" error. Once the JSON file is added, go to constants.dart and add the ISO language code and locale to the supported languages constants.

This app interfaces with the [CEOM website](http://ceom.ou.edu/). It uses the following endpoints on the website to operate. 
- Upload: http://ceom.ou.edu/photos/mobile/upload/
- Register: http://ceom.ou.edu/accounts/mobile_register/
- Login: http://ceom.ou.edu/accounts/mobile_login/
- Logout: http://comf.ou.edu/accounts/mobile_logout/
