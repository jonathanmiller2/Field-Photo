import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'LabelledInvisibleButton.dart';
import 'ImageInfoEntryScreen.dart';
import 'localizations.dart';


class ImagePreviewScreen extends StatelessWidget {
	final String imagePath;
	final DateTime timestamp;
	final double latitude;
	final double longitude;
	final double altitude;
	final double heading;
	
	ImagePreviewScreen({this.imagePath, this.timestamp, this.latitude, this.longitude, this.altitude, this.heading});
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Color.fromARGB(255, 20, 20, 20),
			body: Container(
					height: double.maxFinite,
					width: double.maxFinite,
					child: Image.file(File(imagePath), fit: BoxFit.fitWidth)
			),
			bottomNavigationBar: BottomAppBar(
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
													label: AppLocalizations.of(context).translate("Retake"),
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
													label: AppLocalizations.of(context).translate("Use"),
													onPress: () {
														Navigator.push(
															context,
															new MaterialPageRoute(builder: (context) => new ImageInfoEntryScreen(imagePath: imagePath, timestamp: timestamp, latitude: latitude, longitude: longitude, altitude: altitude, heading: heading,)),
														);
													},
													defaultColor: Colors.blue[600],
													pressedColor: Colors.blue[200],
													centered: false,
													fontWeight: FontWeight.bold,
												)
										),
									),
								),
							],
						)
				),
			),
		);
	}
}