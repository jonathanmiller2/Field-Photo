
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'LabelledInvisibleButton.dart';
import 'PositionIndicator.dart';

import 'constants.dart' as Constants;
import 'localizations.dart';

class ImageInfoEntryScreen extends StatefulWidget {
	final String imagePath;
	final DateTime timestamp;
	final double latitude;
	final double longitude;
	final double altitude;
	final double heading;
	
	ImageInfoEntryScreen({this.imagePath, this.timestamp, this.latitude, this.longitude, this.altitude, this.heading});
	
	@override
	_ImageInfoEntryScreenState createState() => _ImageInfoEntryScreenState();
}

class _ImageInfoEntryScreenState extends State<ImageInfoEntryScreen>
{
	int landcoverClass = 0;
	Database database;
	final fieldNoteController = TextEditingController();
	
	
	@override
	void initState() {
		_startDB();
		super.initState();
	}
	
	
	_startDB() async {
		var databasesPath = await getDatabasesPath();
		String path = join(databasesPath, 'FieldPhoto.db');
		
		//await deleteDatabase(path);
		
		Database db = await openDatabase(path, version:1,
				onCreate: (Database db, int version) async {
					await db.execute('CREATE TABLE photos (id INTEGER PRIMARY KEY, path STRING, userid INTEGER, description TEXT, long DOUBLE, lat DOUBLE, alt DOUBLE, takendate TIMESTAMP, categoryid INTEGER, dir CHARACTER[4], dir_deg DOUBLE, uploaded BOOLEAN)');
				}
		);
		setState(() {
			database = db;
		});
	
	}
	
	_saveImage(path, description, longitude, latitude, altitude, timestamp, categoryid, dir, heading) async {
		await database.transaction((txn) async {
			await txn.rawInsert(
					'INSERT INTO photos(path, description, long, lat, alt, takendate, categoryid, dir, dir_deg, uploaded) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [path, description, longitude, latitude, altitude, timestamp.toString(), categoryid, dir, heading, 0]
			);
		});
	}
	
	
	@override
	Widget build(BuildContext context) {
		
		Map<int, String> landcoverMap = Constants.LandcoverMap().getLandcoverClassMap(context);
		
		const double horizontalPadding = 12;
		const double verticalPadding = 15;
		const double labelWidth = 90;
		
		TextStyle labelStyle = TextStyle(
			color: Colors.blue[600],
		);
		
		return GestureDetector(
			onTap: () {
				FocusScope.of(context).unfocus();
			},
			child: Scaffold(
				backgroundColor: Colors.grey[200],
				appBar: AppBar(
					title: Text(
							AppLocalizations.of(context).translate("Field Photo Metadata"),
							style: TextStyle(
								fontSize: 22,
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
														AppLocalizations.of(context).translate("Latitude"),
														style: labelStyle,
													),
												),
												Expanded(
													child: Text(
														widget.latitude.toStringAsPrecision(7),
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
														AppLocalizations.of(context).translate("Longitude"),
														style: labelStyle,
													),
												),
												Expanded(
													child: Text(
															widget.longitude.toStringAsPrecision(7)
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
														AppLocalizations.of(context).translate("Land Cover"),
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
																				landcoverMap[value],
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
														AppLocalizations.of(context).translate("Field Notes"),
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
														label: AppLocalizations.of(context).translate("Cancel"),
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
														label: AppLocalizations.of(context).translate("Save"),
														onPress: () async {
															if(landcoverClass == 0)
															{
																showDialog(
																		context: context,
																		builder: (BuildContext context) {
																			return AlertDialog(
																				title: Center(
																						child: Text(
																								AppLocalizations.of(context).translate("Land cover unspecified")
																						)
																				),
																				content: Text(
																					AppLocalizations.of(context).translate("land-cover-unspecified-msg-text"),
																				),
																				actions: <Widget>[
																					FlatButton(
																						child: Text(AppLocalizations.of(context).translate("Cancel")),
																						onPressed: () {
																							Navigator.pop(context);
																							return;
																						},
																					),
																					FlatButton(
																						child: Text(AppLocalizations.of(context).translate("Continue")),
																						onPressed: () {
																							_saveImage(widget.imagePath, fieldNoteController.text, widget.longitude, widget.latitude, widget.altitude, widget.timestamp, landcoverClass, PositionIndicator.getDirFromHeading(widget.heading), widget.heading);
																							
																							Navigator.pop(context);
																							Navigator.pop(context);
																							Navigator.pop(context);
																						},
																					)
																				],
																			);
																		}
																);
															}
															else
															{
																_saveImage(widget.imagePath, fieldNoteController.text, widget.longitude, widget.latitude, widget.altitude, widget.timestamp, landcoverClass, PositionIndicator.getDirFromHeading(widget.heading), widget.heading);
																
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
			),
		);
	}
}