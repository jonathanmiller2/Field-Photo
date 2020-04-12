
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CameraScreen.dart';


class MainCameraButton extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return FloatingActionButton(
			onPressed: () {
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