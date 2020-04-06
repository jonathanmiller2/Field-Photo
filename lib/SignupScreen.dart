import 'package:url_launcher/url_launcher.dart';
import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
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
														hintText: 'Email Address',
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
								padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
								child: Container(
									height: 45,
								  child: FlatButton(
								  		onPressed: () {},
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
			bottomNavigationBar: BottomAppBar(
				shape: const CircularNotchedRectangle(),
				child: Container(
						height: 50.0
				),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {},
				child: Icon(Icons.photo_camera),
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
		);
	}
	
}