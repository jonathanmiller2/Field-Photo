import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'CameraScreen.dart';

class MainCameraButton extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			onPressed: () async {
				
				bool cameraPermissionGranted = await Permission.camera.request().isGranted;
				bool locationPermissionGranted = await Permission.locationWhenInUse.request().isGranted && await Permission.locationWhenInUse.serviceStatus.isEnabled;
				
				
				if(!cameraPermissionGranted)
				{
					showDialog(
							context: context,
							builder: (BuildContext context) {
								return AlertDialog(
									title: Center(
											child: Text(
													"Camera access not granted"
											)
									),
									content: Text(
										"This app needs permission to use your camera in order to take field photos, please allow camera access in your settings",
									),
									actions: <Widget>[
										FlatButton(
											child: Text("Dismiss"),
											onPressed: () {
												Navigator.pop(context);
											},
										),
										FlatButton(
											child: Text("Settings"),
											onPressed: () {
												openAppSettings();
												Navigator.pop(context);
											},
										),
									],
								);
							}
					);
					return;
				}
				if(!locationPermissionGranted)
				{
					showDialog(
							context: context,
							builder: (BuildContext context) {
								return AlertDialog(
									title: Center(
											child: Text(
													"Location access not granted"
											)
									),
									content: Text(
										"This app needs permission to use your location in order to tag field photos, please allow location access in your settings",
									),
									actions: <Widget>[
										FlatButton(
											child: Text("Dismiss"),
											onPressed: () {
												Navigator.pop(context);
											},
										),
										FlatButton(
											child: Text("Settings"),
											onPressed: () {
												openAppSettings();
												Navigator.pop(context);
											},
										),
									],
								);
							}
					);
					return;
				}
				
				Navigator.push(
					context,
					new MaterialPageRoute(builder: (context) => new CameraScreen()),
				);
			},
			child: Icon(
				Icons.photo_camera,
				size: 32,
			),
			backgroundColor: Colors.blue[600],
		);
	}
}