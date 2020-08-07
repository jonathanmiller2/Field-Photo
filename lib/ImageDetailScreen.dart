import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'LabelledInvisibleButton.dart';
import 'LoginSession.dart';
import 'constants.dart' as Constants;
import 'localizations.dart';

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
	bool uploadState;
	
	TextEditingController fieldNoteController;
	bool editMode = false;
	
	@override
	void initState() {
		super.initState();
		savedDescription = widget.image['description'];
		savedLandcoverClass = widget.image['categoryid'];
		selectedLandcoverClass = widget.image['categoryid'];
		fieldNoteController = TextEditingController(text: widget.image['description']);
		
		uploadState = widget.image['uploaded'] == 1;
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
		
		if(editMode)
		{
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
						actions: <Widget>[
							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
								child: LabelledInvisibleButton(
									label: AppLocalizations.of(context).translate("Cancel"),
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
															AppLocalizations.of(context).translate("Latitude"),
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
															AppLocalizations.of(context).translate("Longitude"),
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
															AppLocalizations.of(context).translate("Land Cover"),
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
														alignment: Alignment.centerRight,
														child: LabelledInvisibleButton(
															label: AppLocalizations.of(context).translate("Save"),
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
				),
			);
		}
		else
		{
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
									fontSize: 22.0,
									color: Colors.black,
								)
						),
						backgroundColor: Colors.white,
						centerTitle: true,
						iconTheme: IconThemeData(
								color: Colors.black
						),
						
						actions: <Widget>[
							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
								child: LabelledInvisibleButton(
									label: AppLocalizations.of(context).translate("Edit"),
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
															AppLocalizations.of(context).translate("Latitude"),
															style: labelStyle,
														),
													),
													Expanded(
														child: Text(
																widget.image['lat'].toStringAsPrecision(7)
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
																widget.image['long'].toStringAsPrecision(7)
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
															AppLocalizations.of(context).translate("Uploaded"),
															style: labelStyle,
														),
													),
													
													uploadState ? Icon(Icons.cloud_upload, color: Colors.lightGreenAccent[700]) : Icon(Icons.highlight_off, color:Colors.red)
												
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
															child: Text(
																	landcoverMap[selectedLandcoverClass],
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
															AppLocalizations.of(context).translate("Field Notes"),
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
														label: AppLocalizations.of(context).translate("Share"),
														onPress: () async {
															Uri uri = new Uri.file(widget.image['path'].toString());
															File imageFile = new File.fromUri(uri);
															Uint8List bytes = await imageFile.readAsBytes();
															ByteData byteData = ByteData.view(bytes.buffer);
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
														label: AppLocalizations.of(context).translate("Upload"),
														onPress: () async {
															
															if(widget.image['uploaded'] == 1)
															{
																showDialog(
																		context: context,
																		builder: (BuildContext context) {
																			return AlertDialog(
																				title: Center(
																						child: Text(
																								AppLocalizations.of(context).translate("Photo already uploaded")
																						)
																				),
																				content: Text(
																					AppLocalizations.of(context).translate("This photo has already been uploaded"),
																				),
																				actions: <Widget>[
																					FlatButton(
																						child: Text(AppLocalizations.of(context).translate("Dismiss")),
																						onPressed: () {
																							Navigator.pop(context);
																							return;
																						},
																					),
																				],
																			);
																		}
																);
																return;
															}
															
															if(!LoginSession.shared.loggedIn)
															{
																showDialog(
																		context: context,
																		builder: (BuildContext context) {
																			return AlertDialog(
																				title: Center(
																						child: Text(
																								AppLocalizations.of(context).translate("Login required")
																						)
																				),
																				content: Text(
																					AppLocalizations.of(context).translate("In order to upload photos you must first be logged in"),
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
																						child: Text(AppLocalizations.of(context).translate("Login")),
																						onPressed: () {
																							Navigator.pop(context);
																							Navigator.pop(context);
																							Navigator.pop(context);
																							return;
																						},
																					),
																				],
																			);
																		}
																);
																return;
															}
															
															showDialog(
																	context: context,
																	builder: (BuildContext context) {
																		return Container(
																				color: Color.fromARGB(255, 20, 20, 20),
																				child: SizedBox(
																						height: 20,
																						width: 20,
																						child: Center(
																								child: CircularProgressIndicator()
																						)
																				)
																		);
																	});
															
															
															bool success = await upload(widget.image);
															
															Navigator.pop(context);
															
															if (success) {
																await widget.database.rawUpdate('UPDATE photos SET uploaded = ? WHERE id = ?', [1, widget.image['id']]);
																uploadState = true;
																
																showDialog(
																		context: context,
																		child: AlertDialog(
																			title: Center(
																					child: Text(
																							AppLocalizations.of(context).translate("Upload succeeded")
																					)
																			),
																			actions: <Widget>[
																				FlatButton(
																					child: Text(AppLocalizations.of(context).translate("Dismiss")),
																					onPressed: () {
																						Navigator.pop(context);
																					},
																				),
																			],
																		)
																);
																
																setState(() {});
															}
															else {
																showDialog(
																		context: context,
																		child: AlertDialog(
																			title: Center(
																					child: Text(
																							AppLocalizations.of(context).translate("Upload failed")
																					)
																			),
																			content: Text(
																				AppLocalizations.of(context).translate("The upload failed, please try again"),
																			),
																			actions: <Widget>[
																				FlatButton(
																					child: Text(AppLocalizations.of(context).translate("Dismiss")),
																					onPressed: () {
																						Navigator.pop(context);
																					},
																				),
																			],
																		)
																);
															}
															
															
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
														label: AppLocalizations.of(context).translate("Delete"),
														onPress: () {
															showDialog(
																	context: context,
																	builder: (BuildContext context) {
																		return AlertDialog(
																			title: Text(AppLocalizations.of(context).translate("Delete image?")),
																			content: Text(AppLocalizations.of(context).translate("Deleting an image permanently removes it.")),
																			actions: <Widget>[
																				FlatButton(
																					child: Text(AppLocalizations.of(context).translate("Cancel")),
																					onPressed: () {
																						Navigator.pop(context);
																					},
																				),
																				FlatButton(
																					child: Text(AppLocalizations.of(context).translate("Delete")),
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
				),
			);
		}
	}
	
	
	Future<bool> upload(Map<String, dynamic> image) async {
		
		if(image['uploaded'] == 1)
		{
			print('Already uploaded');
			return true;
		}
		
		var request = http.MultipartRequest('POST', Uri.parse(Constants.UPLOAD_URL));
		request.fields["landcover_cat"] = image["categoryid"].toString();
		request.fields["notes"] = image["description"];
		request.fields["username"] = LoginSession.shared.username;
		request.fields["password"] = LoginSession.shared.password;
		request.fields["lat"] = image["lat"].toString();
		request.fields["lon"] = image["long"].toString();
		request.fields["alt"] = image["alt"].toString();
		request.fields["date_taken"] = image["takendate"];
		request.fields["dir_deg"] = image["dir_deg"].toString();
		
		request.files.add(
				await http.MultipartFile.fromPath(
						'file',
						image['path'],
						contentType: MediaType('image', 'jpeg')
				)
		);
		
		
		http.StreamedResponse response = await request.send();

//		response.stream.transform(utf8.decoder).listen((x) {
//			print(x);
//		});
		
		if(response.statusCode == 200)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
