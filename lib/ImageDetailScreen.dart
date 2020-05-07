

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

import 'LabelledInvisibleButton.dart';
import 'constants.dart' as Constants;
import 'main.dart';

class ImageDetailScreen extends StatefulWidget {
	
	final Map<String, dynamic> image;
	final Database database;
	
	ImageDetailScreen({this.image, this.database});
	
	@override
	_ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
	int selectedLandcoverClass;
	int savedLandcoverClass;
	String savedDescription;
	
	TextEditingController fieldNoteController;
	bool editMode = false;
	
	@override
	void initState() {
		super.initState();
		savedDescription = widget.image['description'];
		savedLandcoverClass = widget.image['categoryid'];
		selectedLandcoverClass = widget.image['categoryid'];
		fieldNoteController = TextEditingController(text: widget.image['description']);
	}
	
	
	@override
	Widget build(BuildContext context) {
		
		const double horizontalPadding = 12;
		const double verticalPadding = 15;
		const double labelWidth = 80;
		
		TextStyle labelStyle = TextStyle(
			color: Colors.blue[600],
		);
		
		if(editMode)
		{
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
					actions: <Widget>[
						Padding(
							padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
							child: LabelledInvisibleButton(
								label: 'Cancel',
								onPress: () {
									setState(() {
										editMode = false;
										selectedLandcoverClass = savedLandcoverClass;
										fieldNoteController = TextEditingController(text: savedDescription);
									});
								},
								defaultColor: Colors.blue[600],
								pressedColor: Colors.blue[200],
								fontWeight: editMode ? FontWeight.bold : FontWeight.normal,
								fontSize: 20,
							),
						)
					],
				),
				body: ListView(
						children: <Widget>[
							Image.file(
									File(widget.image['path'].toString()),
									fit: BoxFit.fitWidth
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
															value: selectedLandcoverClass,
															onChanged: (int newClass) {
																setState(() {
																	selectedLandcoverClass = newClass;
																}
																);
															},
															items: <int> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17].map<DropdownMenuItem<int>> ((int value)
															{
																return DropdownMenuItem<int>(
																		value: value,
																		child: Text(
																				Constants.landcoverClassMap[value],
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
													alignment: Alignment.centerRight,
													child: LabelledInvisibleButton(
														label: "Save",
														onPress: () async {
															await widget.database.rawUpdate('UPDATE photos SET description = ?, categoryid = ? WHERE id = ?', [fieldNoteController.text, selectedLandcoverClass, widget.image['id']]);
															setState(() {
																savedDescription = fieldNoteController.text;
																savedLandcoverClass = selectedLandcoverClass;
																editMode = false;
															});
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
		else
		{
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
					actions: <Widget>[
						Padding(
							padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
							child: LabelledInvisibleButton(
								label: 'Edit',
								onPress: () {
									setState(() {
										editMode = true;
									});
								},
								defaultColor: Colors.blue[600],
								pressedColor: Colors.blue[200],
								fontWeight: editMode ? FontWeight.bold : FontWeight.normal,
								fontSize: 20,
							),
						)
					],
				),
				body: ListView(
						children: <Widget>[
							Image.file(
									File(widget.image['path'].toString()),
									fit: BoxFit.fitWidth
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
														child: Text(
																Constants.landcoverClassMap[selectedLandcoverClass],
																style: TextStyle(
																		fontSize: 15
																)
														)
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
														"Field Notes",
														style: labelStyle,
													),
												),
												Expanded(
													child: TextField(
															readOnly: true,
															minLines: 5,
															maxLines: 10,
															maxLength: 300,
															controller: fieldNoteController
													),
												),
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
					child: Container(
							height: 50.0,
							child: Row(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: <Widget>[
									Expanded(
										child: Align(
											alignment: Alignment.center,
											child: Padding(
												padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
												child: LabelledInvisibleButton(
													label: "Share",
													onPress: () async {
														ByteData byteData = await rootBundle.load(widget.image['path'].toString());
														Share.files('Field Photo', {basename(widget.image['path']) : byteData.buffer.asUint8List()}, '*/*');
													},
													defaultColor: Colors.blue[600],
													pressedColor: Colors.blue[200],
													centered: false,
													fontWeight: FontWeight.normal,
												),
											),
										),
									),
									Expanded(
										child: Align(
											alignment: Alignment.center,
											child: Padding(
												padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
												child: LabelledInvisibleButton(
													label: "Upload",
													onPress: () {
														//TODO: Checked if logged in
														
													},
													defaultColor: Colors.blue[600],
													pressedColor: Colors.blue[200],
													centered: false,
													fontWeight: FontWeight.normal,
												),
											),
										),
									),
									Expanded(
										child: Align(
											alignment: Alignment.center,
											child: Padding(
												padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
												child: LabelledInvisibleButton(
													label: "Delete",
													onPress: () {
														showDialog(
																context: context,
																builder: (BuildContext context) {
																	return AlertDialog(
																		title: Text("Delete image?"),
																		content: Text("Deleting a image permanently removes it."),
																		actions: <Widget>[
																			FlatButton(
																				child: Text("Cancel"),
																				onPressed: () {
																					Navigator.pop(context);
																				},
																			),
																			FlatButton(
																				child: Text("Delete"),
																				onPressed: () async {
																					await widget.database.rawDelete('DELETE FROM photos WHERE id = ?', [widget.image['id']]);
																					Navigator.pop(context);
																					Navigator.pop(context);
																				},
																			)
																		],
																	
																	);
																}
														
														);
													},
													defaultColor: Colors.red[600],
													pressedColor: Colors.red[200],
													centered: false,
													fontWeight: FontWeight.normal,
												),
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
}