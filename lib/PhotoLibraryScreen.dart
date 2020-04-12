

import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoLibraryScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(
						'All Photos',
						style: TextStyle(
							fontSize: 22.0,
							color: Colors.black,
						)
				),
				backgroundColor: Colors.white,
				centerTitle: true,
				actions: <Widget>[
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
					  child: LabelledInvisibleButton(
					  	label: 'Select',
					  	onPress: () {
					  		//TODO: Add photo select functionality
							},
							defaultColor: Colors.blue[600],
							pressedColor: Colors.blue[200],
							fontWeight: FontWeight.normal,
							fontSize: 20,
					  ),
					)
				],
			),
		);
	}
}