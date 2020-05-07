import 'package:url_launcher/url_launcher.dart';
import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'LoginScreen.dart';
import 'constants.dart' as Constants;

import 'MainBottomBar.dart';
import 'MainCameraButton.dart';

class SignupScreen extends StatefulWidget {
	@override
	_SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<StatefulWidget>
{
	final usernameController = TextEditingController();
	final emailController = TextEditingController();
	final passwordController = TextEditingController();
	
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
			resizeToAvoidBottomInset: false,
			appBar: AppBar(
				title: Text(
						'Field Photo',
						style: TextStyle(
							fontSize: 22.0,
							color: Colors.black,
						)
				),
				backgroundColor: Colors.white,
				centerTitle: true,
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
														hintText: 'Username',
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
													decoration: InputDecoration(
														border: InputBorder.none,
														hintText: 'Email Address',
													),
													controller: emailController,
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
														hintText: 'Password',
													),
													controller: passwordController,
												),
											),
										],
									),
								),
							),
							
							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
								child: Container(
									height: 45,
									child: FlatButton(
											onPressed: () async {
												final emailPattern = RegExp("[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
												
												if(usernameController.text == "")
												{
													showDialog(
															context: context,
															builder: (BuildContext context) {
																return AlertDialog(
																	title: Center(
																			child: Text(
																					"Missing username"
																			)
																	),
																	content: Text(
																		"Please enter a username",
																	),
																	actions: <Widget>[
																		FlatButton(
																			child: Text("Dismiss"),
																			onPressed: () {
																				Navigator.pop(context);
																			},
																		),
																	],
																);
															}
													);
													return;
												}
												
												if(!emailPattern.hasMatch(emailController.text) || emailController.text == "")
												{
													showDialog(
															context: context,
															builder: (BuildContext context) {
																return AlertDialog(
																	title: Center(
																			child: Text(
																					"Invalid Email"
																			)
																	),
																	content: Text(
																		"Email invalid, please check your email",
																	),
																	actions: <Widget>[
																		FlatButton(
																			child: Text("Dismiss"),
																			onPressed: () {
																				Navigator.pop(context);
																			},
																		),
																	],
																);
															}
													);
													return;
												}
												
												if(passwordController.text == "")
												{
													showDialog(
															context: context,
															builder: (BuildContext context) {
																return AlertDialog(
																	title: Center(
																			child: Text(
																					"Missing password"
																			)
																	),
																	content: Text(
																		"Please enter your password",
																	),
																	actions: <Widget>[
																		FlatButton(
																			child: Text("Dismiss"),
																			onPressed: () {
																				Navigator.pop(context);
																			},
																		),
																	],
																);
															}
													);
													return;
												}
												
												String registerResult = await register(usernameController.text, emailController.text, passwordController.text);
												
												//TODO: Handle each possible result
												
											},
											color: Colors.blue[700],
											child: Text(
												'Create Account',
												style: TextStyle(
														color: Colors.white,
														fontSize: 18
												),
											)
									),
								),
							),
							
							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
								child: Container(
									height: 45,
									child: LabelledInvisibleButton(
										label: 'Cancel',
										onPress: () {
											Navigator.pop(context);
										},
										defaultColor: Colors.blue[900],
										pressedColor: Colors.white,
									),
								),
							),
							
							
							
							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
								child: Container(
									height: 150,
									child: Column(
										children: <Widget>[
											Padding(
												padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
												child: Center(
													child: Text(
															'Having trouble signing up?',
															style: TextStyle(
																fontSize: 15,
																color: Colors.grey[700],
															)
													),
												),
											),
											Padding(
												padding: const EdgeInsets.symmetric(horizontal:0, vertical: 10),
												child: new LabelledInvisibleButton(
													label:'Sign up online',
													onPress: () async {
														String url = 'http://eomf.ou.edu/accounts/register/';
														if (await canLaunch(url)) {
															await launch(url);
														}
														else {
															throw 'Could not launch $url';
														}
													},
													defaultColor: Colors.blue[900],
													pressedColor: Colors.white,
												),
											),
										],
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
	
	
	Future<String> register(String username, String email, String password) async {
		
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
			'email': email,
			'password': password,
			'csrfmiddlewaretoken': justToken,
		};
		
		response = await http.post(Constants.LOGIN_URL, headers:header, body:body);
		print('Response status: ${response.statusCode}');
		print('Response body: ${response.body}');
		print('Response header: ${response.headers}');
		
		
		if(response.statusCode == 302) {
			return "something";
		}
		return "something";
	}
}