

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'LabelledInvisibleButton.dart';
import 'PositionIndicator.dart';
import 'main.dart';

class ImageDetailScreen extends StatefulWidget {
	
	final Map<String, dynamic> image;
	final Database database;
	
	ImageDetailScreen({this.image, this.database});
	
	@override
	_ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
	int landcoverClass = 0; //TODO: Start this # out correctly
	Database database;
	final fieldNoteController = TextEditingController();
	
	
	_updateImage() async {
		await database.transaction((txn) async {
		
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
						'Field Photo Metadata',
						style: TextStyle(
							fontSize: 22.0,
							color: Colors.black,
						)
				),
				backgroundColor: Colors.white,
				centerTitle: true,
			),
			body: ListView(
					children: <Widget>[
						Padding(
						  padding: const EdgeInsets.all(8.0),
						  child: Image.file(
						  	File(widget.image['path'].toString()),
						  ),
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
													"Latitude",
													style: labelStyle,
												),
											),
											Expanded(
												child: Text(
													widget.image['lat'].toString(),
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
														widget.image['long'].toString()
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
														controller: fieldNoteController
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
													onPress: () async {
													
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