
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'LabelledInvisibleButton.dart';
import 'main.dart';

class ImageInfoEntryScreen extends StatefulWidget {
	final String imagePath;
	final DateTime timestamp;
	final double latitude;
	final double longitude;
	final double heading;
	
	ImageInfoEntryScreen({this.imagePath, this.timestamp, this.latitude, this.longitude, this.heading});
	
	@override
	_ImageInfoEntryScreenState createState() => _ImageInfoEntryScreenState();
}

class _ImageInfoEntryScreenState extends State<ImageInfoEntryScreen>
{
	SharedPreferences sp;
	int landcoverClass = 0;
	
	
	@override
	void initState() {
		super.initState();
		_loadSharedPreferences();
	}
	
	_loadSharedPreferences() async {
		setState(() async {
		  sp = await SharedPreferences.getInstance();
		});
	}
	
	
	@override
	Widget build(BuildContext context) {
		
		const double horizontalPadding = 12;
		const double verticalPadding = 15;
		const double labelWidth = 80;
		
		TextStyle labelStyle = TextStyle(
			color: Colors.blue[600],
		);
		
		return Scaffold(
			backgroundColor: Colors.grey[200],
			appBar: AppBar(
				title: Text(
						'Image Metadata',
						style: TextStyle(
							fontSize: 22.0,
							color: Colors.black,
						)
				),
				backgroundColor: Colors.white,
				centerTitle: true,
			),
			body: Column(
					children: <Widget>[
						Padding(
								padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
								child: Row(
										children: <Widget>[
											Container(
												width: labelWidth,
												child: Text(
													"Latitude",
													style: labelStyle,
												),
											),
											Expanded(
												child: Text(
													widget.latitude.toString(),
												),
											),
										]
								)
						),
						Padding(
								padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
								child: Row(
										children: <Widget>[
											Container(
												width: labelWidth,
												child: Text(
													"Longitude",
													style: labelStyle,
												),
											),
											Expanded(
												child: Text(
														widget.longitude.toString()
												),
											),
										]
								)
						),
						Container(
								color: Colors.grey,
								height: 1
						),
						Padding(
								padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
								child: Row(
										children: <Widget>[
											Container(
												width: labelWidth,
												child: Text(
													"Land Cover",
													style: labelStyle,
												),
											),
											Expanded(
													child: DropdownButton<int>(
														isExpanded: true,
														value: landcoverClass,
														onChanged: (int newClass) {
															setState(() {
																landcoverClass = newClass;
															}
															);
														},
														items: <int> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17].map<DropdownMenuItem<int>> ((int value)
														{
															return DropdownMenuItem<int>(
																	value: value,
																	child: Text(
																			MyApp.landcoverClassMap[value],
																			style: TextStyle(
																					fontSize: 15
																			)
																	)
															);
														}).toList(),
													)
											),
											Icon(
													Icons.edit
											)
										]
								)
						),
						Container(
								color: Colors.grey,
								height: 1
						),
						Padding(
								padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
								child: Row(
										children: <Widget>[
											Container(
												width: labelWidth,
												child: Text(
													"Field Notes",
													style: labelStyle,
												),
											),
											Expanded(
												child: TextField(
													minLines: 5,
													maxLines: 10,
													maxLength: 300,
												),
											),
											Icon(
													Icons.edit
											)
										]
								)
						),
						Container(
								color: Colors.grey,
								height: 1
						),
					]
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
													label: "Cancel",
													onPress: () {
														Navigator.pop(context);
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
													label: "Save",
													onPress: () {
														//TODO: Ask the user if they want to save an unclassified image
														
														if(sp != null)
															{
																//TODO: Save image using SQFlite
																Navigator.pop(context);
																Navigator.pop(context);
															}
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