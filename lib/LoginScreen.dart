

import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:field_photo/MainBottomBar.dart';
import 'package:field_photo/SignedInScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'constants.dart' as Constants;

import 'MainCameraButton.dart';
import 'SignupScreen.dart';

class LoginScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
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
									child: FlatButton(
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
												
												String username = "CSRFCookieTest2";
												String password = "CSRFCookieTest2";
												
												var response = await post(Constants.LOGIN_URL, body:{'username': username, 'password': password});
												print('Response status: ${response.statusCode}');
												print('Response body: ${response.body}');
												
												
												if(1 == 1) //TODO: If login successful...
														{
													Navigator.pushReplacement(
														context,
														new MaterialPageRoute(builder: (context) => new SignedInScreen()),
													);
												}
												else
												{
													showDialog(
															context: context,
															builder: (BuildContext context) {
																return AlertDialog(
																	title: Center(
																			child: Text(
																					"Unable to sign in"
																			)
																	),
																	content: Text(
																		"Please check your username and password",
																	),
																	actions: <Widget>[
																		FlatButton(
																			child: Text("Dismiss"),
																			onPressed: () {
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
											color: Colors.green[700],
											child: Text(
												'Sign In',
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
											'Don\'t have an account?',
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
									label: 'Sign Up',
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
								padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
								child: Container(
									height: 200,
									child: Center(
										child: Text(
											'You may capture and geotag photos without an account, but you must have an account to upload them to the University of Oklahoma\'s Earth Observation and Modelling Facility database.',
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
		);
	}
}