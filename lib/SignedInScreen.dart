import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:field_photo/MainBottomBar.dart';
import 'package:field_photo/SignedInScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';
import 'MainCameraButton.dart';
import 'SignupScreen.dart';

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
							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
								child: Container(
									height: 60,
									child: Center(
										child: Text(
											'Signed in as ' + username,
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
									child: FlatButton(
											onPressed: () {
												
												prefs.setString('savedUsername', null);
												prefs.setString('savedPassword', null);
												
												Navigator.pushReplacement(
													context,
													new MaterialPageRoute(builder: (context) => new LoginScreen()),
												);
											},
											color: Color.fromARGB(255, 20, 20, 20),
											child: Text(
												'Sign Out',
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