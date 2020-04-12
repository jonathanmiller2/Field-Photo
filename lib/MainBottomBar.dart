
import 'package:field_photo/PhotoLibraryScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'InfoScreen.dart';

class MainBottomBar extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return BottomAppBar(
			shape: const CircularNotchedRectangle(),
			child: Container(
					height: 50.0,
					child: Row(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: <Widget>[
							Expanded(
								child: Container(
									child: Padding(
										padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
										child: Align(
											alignment: Alignment.centerLeft,
											child: IconButton(
													icon: Icon(
														Icons.photo_library,
														size: 30,
														color: Colors.blue[600],
													),
													onPressed: () {
														Navigator.push(
															context,
															new MaterialPageRoute(builder: (context) => new PhotoLibraryScreen()),
														);
													}
											),
										),
									),
								),
							),
							Expanded(
								child: Padding(
									padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
									child: Align(
										alignment: Alignment.centerRight,
										child: IconButton(
												icon: Icon(
													Icons.info_outline,
													size: 32,
													color: Colors.blue[600],
												),
												onPressed: () {
													Navigator.push(
														context,
														new MaterialPageRoute(builder: (context) => new InfoScreen()),
													);
												}
										),
									),
								),
							),
						],
					)
			),
		);
	}
}
