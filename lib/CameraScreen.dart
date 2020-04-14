import 'dart:async';

import 'package:field_photo/CameraPassthrough.dart';
import 'package:field_photo/LabelledInvisibleButton.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'PositionIndicator.dart';

class CameraScreen extends StatefulWidget {
	@override
	_CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
	@override
	Widget build(BuildContext context) {
		
		Color geolockTextColor = PositionIndicator.isGeolocked ? Colors.blue[600] : Colors.red[600];
		
		
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
										child: PositionIndicator()
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
														
														if(!PositionIndicator.isGeolocked) {
															showDialog(
																	context: context,
																	builder: (BuildContext context) {
																		return AlertDialog(
																			title: Text("Enable Geolock?"),
																			content: Text("Enabling geolock saves the current latitude and longitude and saves them for future photos"),
																			actions: <Widget>[
																				FlatButton(
																					child: Text("Cancel"),
																					onPressed: () {
																						Navigator.pop(context);
																					},
																				),
																				FlatButton(
																					child: Text("Enable"),
																					onPressed: () {
																						Navigator.pop(context);
																						PositionIndicator.toggleGeolock();
																						setState(() {});
																					},
																				)
																			],
																		
																		);
																	}
																	
															);
														}
														else
														{
															PositionIndicator.toggleGeolock();
															setState(() {});
														}
													},
													defaultColor: PositionIndicator.isGeolocked ? Colors.red[600] : Colors.blue[600],
													pressedColor: PositionIndicator.isGeolocked ? Colors.red[200] : Colors.blue[200],
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
					
					if(PositionIndicator.getMostRecentPosition() == null)
					{
						showDialog(
								context: context,
								builder: (BuildContext context) {
									return AlertDialog(
											title: Center(
													child: Text(
															"Error Retrieving Position"
													)
											),
											content: Text(
													"There was an error retrieving your position. This app requires your position to geotag photos for our database."
											)
									);
								}
						);
					}
					else {
						showDialog(
								context: context,
								builder: (BuildContext context) {
									return AlertDialog(
											content: Text(
													"pos" + PositionIndicator.getMostRecentPosition().toString()
											)
									);
								}
						);
					}
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
