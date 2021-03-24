import 'package:field_photo/MainBottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'constants.dart' as Constants;

import 'LoginScreen.dart';
import 'LoginSession.dart';
import 'MainCameraButton.dart';
import 'localizations.dart';

class SignedInScreen extends StatefulWidget {
	@override
	_SignedInScreenState createState() => _SignedInScreenState();
}

class _SignedInScreenState extends State<SignedInScreen>
{
	SharedPreferences prefs;
	
	void getSharedPreferences() async {
		SharedPreferences tempPrefs = await SharedPreferences.getInstance();
		setState(() {
			prefs =  tempPrefs;
		});
	}
	
	@override void initState() {
		super.initState();
		getSharedPreferences();
	}
	
	@override
	Widget build(BuildContext context) {
		
		if(prefs == null)
		{
			return Container(
					color: Color.fromARGB(255, 20, 20, 20),
					child: SizedBox(
							height: 20,
							width: 20,
							child: Center(
									child: CircularProgressIndicator()
							)
					)
			);
		}
		
		String username = prefs.getString('savedUsername') ?? ' ACCOUNT NAME ERROR';
		
		return Scaffold(
			resizeToAvoidBottomInset: false,
			appBar: AppBar(
				title: Text(
						AppLocalizations.of(context).translate('Field Photo'),
						style: TextStyle(
							fontSize: 22.0,
							color: Colors.black,
						)
				),
				backgroundColor: Colors.white,
				centerTitle: true,
				iconTheme: IconThemeData(
						color: Colors.black
				),
			),
			body: Container(
				color: Colors.grey[200],
				child: Padding(
					padding: const EdgeInsets.all(30),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						crossAxisAlignment: CrossAxisAlignment.stretch,
						mainAxisSize: MainAxisSize.max,
						children: <Widget>[
							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
								child: Container(
									height: 60,
									child: Center(
										child: Text(
											AppLocalizations.of(context).translate("Signed in as") + ' ' + username,
											style: TextStyle(
												fontSize: 15,
												color: Colors.grey[700],
											),
											textAlign: TextAlign.center,
										),
									),
								),
							),
							Padding(
								padding: const EdgeInsets.symmetric(
										horizontal: 0, vertical: 0),
								child: Container(
									height: 45,
									child: TextButton(
											onPressed: () async {
												//TODO: I have no idea if this logout method actually works server-side. Whether or not it works depends on a complicated interaction between this app and Django session authentication middleware, which is very difficult to debug.
												
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
													'csrfmiddlewaretoken': justToken,
												};
												
												response = await http.post(Constants.LOGOUT_URL, headers:header, body:body);
												print('Response status: ${response.statusCode}');
												print('Response header: ${response.headers}');
												print('Response Body: ${response.body}');
												
												LoginSession.shared.loggedIn = false;
												LoginSession.shared.username = "";
												LoginSession.shared.password = "";
												
												prefs.setString('savedUsername', null);
												prefs.setString('savedPassword', null);
												
												Navigator.pushReplacement(
													context,
													new MaterialPageRoute(builder: (context) => new LoginScreen()),
												);
											},
											style: TextButton.styleFrom(
													backgroundColor: Color.fromARGB(255, 20, 20, 20),
											),
											child: Text(
												AppLocalizations.of(context).translate("Sign Out"),
												style: TextStyle(
														color: Colors.white,
														fontSize: 18
												),
											)
									),
								),
							),
						],
					),
				),
			),
			bottomNavigationBar: MainBottomBar(),
			floatingActionButton: MainCameraButton(),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
		);
	}
}