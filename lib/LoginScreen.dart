import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:field_photo/MainBottomBar.dart';
import 'package:field_photo/SignedInScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'LoginSession.dart';
import 'constants.dart' as Constants;

import 'MainCameraButton.dart';
import 'SignupScreen.dart';
import 'localizations.dart';

class LoginScreen extends StatefulWidget {
	
	@override
	_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
	final usernameController = TextEditingController();
	final passwordController = TextEditingController();
	
	
	@override
	Widget build(BuildContext context) {
		
		return GestureDetector(
			onTap: () {
				FocusScope.of(context).unfocus();
			},
			child: Scaffold(
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
								Form(
									child: Container(
										decoration: BoxDecoration(
											border: Border.all(
												color: Colors.grey[400],
												width: 1,
											),
											borderRadius: BorderRadius.all(
													Radius.circular(5)
											),
											color: Colors.white,
										),
										child: Column(
											children: <Widget>[
												Padding(
													padding: const EdgeInsets.symmetric(
															horizontal: 9, vertical: 0),
													child: TextField(
														decoration: InputDecoration(
															border: InputBorder.none,
															fillColor: Colors.white,
															hintText: AppLocalizations.of(context).translate('Username'),
														),
														controller: usernameController,
													),
												),
												Container(
													color: Colors.grey,
													height: 1,
												),
												Padding(
													padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 0),
													child: TextField(
														obscureText: true,
														decoration: InputDecoration(
															border: InputBorder.none,
															hintText: AppLocalizations.of(context).translate('Password'),
														),
														controller: passwordController,
													),
												),
											],
										),
									),
								),
								
								Padding(
									padding: const EdgeInsets.symmetric(
											horizontal: 0, vertical: 15),
									child: Container(
										height: 45,
										child: TextButton(
												onPressed: () async {
													showDialog(
															context: context,
															builder: (BuildContext context) {
																return SizedBox(
																		height: 20,
																		width: 20,
																		child: Center(
																				child: CircularProgressIndicator()
																		)
																);
															}
													);
													
													bool loginSuccessful = await login(usernameController.text, passwordController.text);
													
													if(!loginSuccessful)
													{
														LoginSession.shared.loggedIn = false;
														showDialog(
																context: context,
																builder: (BuildContext context) {
																	return AlertDialog(
																		title: Center(
																				child: Text(
																						AppLocalizations.of(context).translate('Unable to sign in')
																				)
																		),
																		content: Text(
																			AppLocalizations.of(context).translate("check-details"),
																		),
																		actions: <Widget>[
																			TextButton(
																				child: Text(AppLocalizations.of(context).translate("Dismiss")),
																				onPressed: () {
																					Navigator.pop(context);
																					Navigator.pop(context);
																					return;
																				},
																			),
																		],
																	);
																}
														);
													}
												},
												style: TextButton.styleFrom(
													backgroundColor: Colors.green[700],
												),
												child: Text(
													AppLocalizations.of(context).translate("Sign In"),
													style: TextStyle(
															color: Colors.white,
															fontSize: 18
													),
												)
										),
									),
								),
								
								Padding(
									padding: const EdgeInsets.all(8.0),
									child: Center(
										child: Text(
												AppLocalizations.of(context).translate("Don't have an account?"),
												style: TextStyle(
													fontSize: 15,
													color: Colors.grey[700],
												)
										),
									),
								),
								
								Padding(
									padding: const EdgeInsets.all(10.0),
									child: LabelledInvisibleButton(
										label: AppLocalizations.of(context).translate("Sign Up"),
										onPress: () {
											Navigator.push(
												context,
												new MaterialPageRoute(builder: (context) => new SignupScreen()),
											);
										},
										defaultColor: Colors.blue[900],
										pressedColor: Colors.white,
									
									),
								),
								
								Padding(
									padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
									child: Container(
										child: Center(
											child: Text(
												AppLocalizations.of(context).translate("account-use-explanation"),
												style: TextStyle(
													fontSize: 15,
													color: Colors.grey[700],
												),
												textAlign: TextAlign.center,
											),
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
			),
		);
	}
	
	Future<bool> login(String username, String password) async {
		
		
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
//		print('Response status: ${response.statusCode}');
//		print('Response header: ${response.headers}');
//		print('Response Body: ${response.body}');
		
		if(response.statusCode == 200) {
			
			SharedPreferences prefs = await SharedPreferences.getInstance();
			await prefs.setString('savedUsername', usernameController.text);
			await prefs.setString('savedPassword', passwordController.text);
			
			LoginSession.shared.loggedIn = true;
			LoginSession.shared.username = usernameController.text;
			LoginSession.shared.password = passwordController.text;
			
			Navigator.pushReplacement(
				context,
				new MaterialPageRoute(builder: (context) => new SignedInScreen()),
			);
			
			return true;
		}
		
		return false;
	}
	
}