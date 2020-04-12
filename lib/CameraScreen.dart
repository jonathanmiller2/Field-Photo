import 'package:field_photo/CameraPassthrough.dart';
import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
	@override
	_CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
	String label = "Current Position";
	String position = "35\u00b0 12\' 10\" N\, 97\u00b0 27\' 35\" W";
	String confidence = "\u00B173\u00b0 / \u00B18yd.";
	
	TextStyle mainTextStyle = TextStyle(
		fontSize: 18,
		color: Colors.white, // DARKMODE
		//color: Colors.blue[800], //LIGHTMODE
	
	
	);
	TextStyle lesserTextStyle = TextStyle(
		fontSize: 14,
		color: Colors.white, // DARKMODE
		//color: Colors.blue[800], //LIGHTMODE
	);
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Column(
				children: <Widget>[
					Container(
						color: Colors.black,
						child: CameraPassthrough(),
					),
					Expanded(
						child: Container(
								color: Color.fromARGB(255, 25, 25, 25),
								//color: Colors.black, //DARKMODE
								//color: Colors.grey[300], //LIGHTMODE
								child: Center(
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: <Widget>[
												Text(
														label,
														style: mainTextStyle
												),
												Text(
														position,
														style: mainTextStyle
												),
												Text(
														confidence,
														style: lesserTextStyle
												),
											],
										)
								)
						),
					)
				],
			),
			bottomNavigationBar: BottomAppBar(
				shape: const CircularNotchedRectangle(),
				child: Container(
						height: 50.0,
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: <Widget>[
								Expanded(
									child: Padding(
										padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
										child: Align(
												alignment: Alignment.centerLeft,
												child: LabelledInvisibleButton(
													label: "Close",
													onPress: () {
														Navigator.pop(context);
													},
													defaultColor: Colors.blue[600],
													pressedColor: Colors.blue[200],
													centered: false,
													fontWeight: FontWeight.normal,
												)
										),
									),
								),
								Expanded(
									child: Padding(
										padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
										child: Align(
												alignment: Alignment.centerRight,
												child: LabelledInvisibleButton(
													label: "Geolock",
													onPress: () {
														//TODO: Add geolock functionality
													},
													defaultColor: Colors.blue[600],
													pressedColor: Colors.blue[200],
													centered: false,
													fontWeight: FontWeight.normal,
												)
										),
									),
								),
							],
						)
				),
			),
			floatingActionButton: FloatingActionButton(
				backgroundColor: Colors.blue[600],
				onPressed: () {
					//TODO: Add take picture functionality
				},
				child: Icon(
						Icons.camera,
						size: 36
				),
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
		);
	}
}
