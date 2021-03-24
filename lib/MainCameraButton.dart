import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'CameraScreen.dart';
import 'localizations.dart';

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
													AppLocalizations.of(context).translate("Camera access not granted")
											)
									),
									content: Text(
											AppLocalizations.of(context).translate("camera-permission-required")
									),
									actions: <Widget>[
										TextButton(
											child: Text(AppLocalizations.of(context).translate("Dismiss")),
											onPressed: () {
												Navigator.pop(context);
											},
										),
										TextButton(
											child: Text(AppLocalizations.of(context).translate("Settings")),
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
													AppLocalizations.of(context).translate("Location access not granted")
											)
									),
									content: Text(
											AppLocalizations.of(context).translate("location-permission-required")
									),
									actions: <Widget>[
										TextButton(
											child: Text(AppLocalizations.of(context).translate("Dismiss")),
											onPressed: () {
												Navigator.pop(context);
											},
										),
										TextButton(
											child: Text(AppLocalizations.of(context).translate("Settings")),
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