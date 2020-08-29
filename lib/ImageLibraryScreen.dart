import 'dart:async';
import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';

import 'ImageDetailScreen.dart';
import 'ImageSquare.dart';
import 'LoginSession.dart';
import 'constants.dart' as Constants;
import 'localizations.dart';



class ImageLibraryScreen extends StatefulWidget {
	
	@override
	_ImageLibraryScreenState createState() => _ImageLibraryScreenState();
}


class _ImageLibraryScreenState extends State<ImageLibraryScreen> {
	Database database;
	bool selectMode = false;
	final ImagePicker picker = ImagePicker();
	Map<int, bool> imageSelections = new Map<int, bool>(); //<id, selected or not>
	
	
	Future<List<Map<String, dynamic>>> _loadImages() async {
		var databasesPath = await getDatabasesPath();
		String dbPath = join(databasesPath, 'FieldPhoto.db');
		
		//await deleteDatabase(dbPath);
		
		Database db = await openDatabase(dbPath, version:1,
				onCreate: (Database db, int version) async {
					await db.execute('CREATE TABLE photos (id INTEGER PRIMARY KEY, path STRING, userid INTEGER, description TEXT, long DOUBLE, lat DOUBLE, alt DOUBLE, takendate TIMESTAMP, categoryid INTEGER, dir CHARACTER[4], dir_deg DOUBLE, uploaded BOOLEAN)');
				}
		);
		database = db;
		
		return await db.rawQuery('SELECT * FROM photos');
	}
	
	static double getDecimalFromRatio(Ratio ratio)
	{
		return ratio.numerator / ratio.denominator;
	}
	
	static double getCoordFromDMS(double deg, double min, double sec, String cardinalDir)
	{
		double decimal = deg + (min / 60) + (sec / 3600);
		
		if (cardinalDir == "N" || cardinalDir == "E") {
			return decimal;
		}
		else if (cardinalDir == "S" || cardinalDir == "W") {
			return -decimal;
		}
		else {
			print("DIR NOT RECOGNIZED!!");
		}
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
		return new FutureBuilder<List<Object>>(
			future: _loadImages(),
			builder: (context, asyncSnapshot) {
				
				if (asyncSnapshot.hasError) {
					showDialog(
							context: context,
							builder: (BuildContext context) {
								return AlertDialog(
									title: Center(
											child: Text(
													AppLocalizations.of(context).translate("Library error")
											)
									),
									content: Text(
											AppLocalizations.of(context).translate("There was an error showing your photo library.")
									),
									actions: <Widget>[
										FlatButton(
											child: Text("Return"),
											onPressed: () {
												Navigator.pop(context);
												Navigator.pop(context);
												return;
											},
										),
									],
								);
							}
					);
					print(asyncSnapshot.error);
				}
				
				if (database == null || !asyncSnapshot.hasData) {
					return Container(
							height: 150,
							child: Center(child: CircularProgressIndicator())
					);
				}
				
				//print("Library data: " + asyncSnapshot.toString());
				List<Map<String, dynamic>> imageList = asyncSnapshot.data;
				
				for (Map<String, dynamic> image in imageList)
				{
					if(!imageSelections.containsKey(image['id']))
					{
						imageSelections[image['id']] = false;
					}
				}
				
				//=====================================================================================
				//=======================		Library image square definition ===========================
				//=====================================================================================
				
				List<Widget> imageSquares = imageList.map<Widget> ((Map<String, dynamic> image) {
					
					var contents;
					
					if(selectMode)
					{
						if(imageSelections[image['id']])
						{
							contents = Container(
								decoration: BoxDecoration(
									border: Border.all(
										color: Colors.blue[600],
										width: 3,
									),
								),
								child: FlatButton(
										padding: const EdgeInsets.all(0),
										child: AspectRatio(
												aspectRatio: 1,
												child: ImageSquare(
														path: image['path']
												)
										),
										onPressed: () {
											imageSelections[image['id']] = false;
											setState(() {});
										}
								),
							);
						}
						else
						{
							contents = FlatButton(
									padding: const EdgeInsets.all(0),
									child: AspectRatio(
											aspectRatio: 1,
											child: ImageSquare(
													path: image['path']
											)
									),
									onPressed: () {
										imageSelections[image['id']] = true;
										setState(() {});
									}
							);
						}
					}
					else
					{
						contents = FlatButton(
								padding: const EdgeInsets.all(0),
								child: AspectRatio(
										aspectRatio: 1,
										child: ImageSquare(
												path: image['path']
										)
								),
								onPressed: () {
									Navigator.push(
										context,
										new MaterialPageRoute(builder: (context) => new ImageDetailScreen(image: image, database: database)),
									);
								}
						);
					}
					
					//print(image['uploaded']);
					
					if(image['uploaded'] == 1)
					{
						return Stack(
							children: <Widget>[
								contents,
								Positioned(
										right: 5,
										top: 5,
										child: Container(
												width: 28,
												height: 28,
												decoration: new BoxDecoration(
													shape: BoxShape.circle,
													color: Colors.white,
												)
										)
								),
								Positioned(
										right: 8,
										top: 7,
										child: Icon(
											Icons.cloud_upload,
											color: Colors.lightGreenAccent[700],
											size: 22,
										)
								),
							],
						);
					}
					else
					{
						return contents;
					}
				}).toList();
				
				//=====================================================================================
				//=======================		End of library image square definition ====================
				//=====================================================================================
				
				
				
				
				bool selectionMade = false;
				for(bool x in imageSelections.values)
				{
					if(x)
					{
						selectionMade = true;
						break;
					}
				}
				
				if(selectMode)
				{
					return Scaffold(
						backgroundColor: Colors.grey[200],
						appBar: AppBar(
							title: FittedBox(
								fit: BoxFit.fitWidth,
								child: Text(
										AppLocalizations.of(context).translate("All Field Photos"),
										style: TextStyle(
											color: Colors.black,
										)
								),
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
										label: selectMode ? AppLocalizations.of(context).translate("Cancel") : AppLocalizations.of(context).translate("Select"),
										onPress: () {
											setState(() {
												if(selectMode)
												{
													for(int x in imageSelections.keys)
													{
														imageSelections[x] = false;
													}
													selectMode = false;
												}
												else
												{
													selectMode = true;
												}
											});
										},
										defaultColor: Colors.blue[600],
										pressedColor: Colors.blue[200],
										fontWeight: selectMode ? FontWeight.bold : FontWeight.normal,
										fontSize: 20,
									),
								)
							],
						),
						body: GridView.count(
							crossAxisCount: 3,
							crossAxisSpacing: 5,
							mainAxisSpacing: 5,
							children: imageSquares,
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
																if(!selectionMade)
																{
																	return;
																}
																
																Map<String, List<int>> byteDataMap = new Map<String, List<int>>();
																List<int> selectedIds = new List<int>();
																
																for(MapEntry<int, bool> selectionEntry in imageSelections.entries)
																{
																	if(selectionEntry.value)
																	{
																		selectedIds.add(selectionEntry.key);
																	}
																}
																
																for (Map<String, dynamic> image in imageList)
																{
																	if(selectedIds.contains(image['id']))
																	{
																		String imagePath = image['path'];
																		String filename = basename(imagePath);
																		ByteData byteData = await rootBundle.load(imagePath);
																		byteDataMap[filename] = byteData.buffer.asUint8List();
																	}
																}
																
																Share.files('Field Photo', byteDataMap, '*/*');
															},
															defaultColor: selectionMade ? Colors.blue[600] : Colors.grey,
															pressedColor: selectionMade ? Colors.blue[200] : Colors.grey,
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
																if(!selectionMade)
																{
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
																									"Login required"
																							)
																					),
																					content: Text(
																						"In order to upload photos you must first be logged in",
																					),
																					actions: <Widget>[
																						FlatButton(
																							child: Text("Cancel"),
																							onPressed: () {
																								Navigator.pop(context);
																								return;
																							},
																						),
																						FlatButton(
																							child: Text("Login"),
																							onPressed: () {
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
																
																List<int> selectedIDs = new List<int>();
																for(MapEntry<int, bool> selectionEntry in imageSelections.entries)
																{
																	if(selectionEntry.value)
																	{
																		selectedIDs.add(selectionEntry.key);
																	}
																}
																
																bool allSuccessful = true;
																
																for(Map<String, dynamic> image in imageList)
																{
																	if(selectedIDs.contains(image['id']))
																	{
																		bool success = await upload(image);
																		
																		if(success)
																		{
																			await database.rawUpdate('UPDATE photos SET uploaded = ? WHERE id = ?', [1, image['id']]);
																		}
																		else
																		{
																			allSuccessful = false;
																		}
																	}
																}
																
																Navigator.pop(context);
																
																if(allSuccessful)
																{
																	showDialog(
																			context: context,
																			child: AlertDialog(
																				title: Center(
																						child: Text(
																								AppLocalizations.of(context).translate("Upload succeeded")
																						)
																				),
																				content: Text(
																					AppLocalizations.of(context).translate("All images were uploaded successfully."),
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
																else
																{
																	showDialog(
																			context: context,
																			child: AlertDialog(
																				title: Center(
																						child: Text(
																								AppLocalizations.of(context).translate("Upload failed")
																						)
																				),
																				content: Text(
																					AppLocalizations.of(context).translate("library-upload-error"),
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
																
																setState(() {
																	for(int x in imageSelections.keys)
																	{
																		imageSelections[x] = false;
																	}
																	selectMode = false;
																});
															},
															defaultColor: selectionMade ? Colors.blue[600] : Colors.grey,
															pressedColor: selectionMade ? Colors.blue[200] : Colors.grey,
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
																if(!selectionMade)
																{
																	return;
																}
																
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
																							List<int> selectedIDs = new List<int>();
																							for(MapEntry<int, bool> selectionEntry in imageSelections.entries)
																							{
																								if(selectionEntry.value)
																								{
																									selectedIDs.add(selectionEntry.key);
																								}
																							}
																							for(int id in selectedIDs)
																							{
																								imageSelections.remove(id);
																								await database.rawDelete('DELETE FROM photos WHERE id = ?', [id]);
																							}
																							
																							Navigator.pop(context);
																							setState(() {
																								selectMode = false;
																							});
																						},
																					)
																				],
																			
																			);
																		}
																
																);
															},
															defaultColor: selectionMade ? Colors.red[600] : Colors.grey,
															pressedColor: selectionMade ? Colors.red[200] : Colors.grey,
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
				else
				{
					return Scaffold(
						backgroundColor: Colors.grey[200],
						appBar: AppBar(
							title: FittedBox(
								fit: BoxFit.fitWidth,
								child: Text(
										AppLocalizations.of(context).translate("All Field Photos"),
										style: TextStyle(
											color: Colors.black,
										)
								),
							),
							iconTheme: IconThemeData(
									color: Colors.black
							),
							backgroundColor: Colors.white,
							centerTitle: true,
							actions: <Widget>[
								Padding(
									padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
									child: LabelledInvisibleButton(
										label: selectMode ? AppLocalizations.of(context).translate("Cancel") : AppLocalizations.of(context).translate("Select"),
										onPress: () {
											setState(() {
												selectMode = !selectMode;
											});
										},
										defaultColor: Colors.blue[600],
										pressedColor: Colors.blue[200],
										fontWeight: selectMode ? FontWeight.bold : FontWeight.normal,
										fontSize: 20,
									),
								)
							],
						),
						body: GridView.count(
							crossAxisCount: 3,
							crossAxisSpacing: 5,
							mainAxisSpacing: 5,
							children: imageSquares,
						),
						bottomNavigationBar: BottomAppBar(
							child: Container(
									height: 50.0,
									child: Row(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: <Widget>[
											Expanded(
												child: Align(
													alignment: Alignment.centerLeft,
													child: Padding(
														padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
														child: IconButton(
															icon: Icon(
																	Icons.add_to_photos,
																	color: Colors.blue[600],
																	size: 32
															),
															onPressed: () async {
																final pickedFile = await picker.getImage(source: ImageSource.gallery);
																
																Map<String, IfdTag> data = await readExifFromBytes(await new File(pickedFile.path).readAsBytes());
																
																for (String key in data.keys) {
																	print("$key (${data[key].tagType}): ${data[key]}");
																}
																
																if(data.containsKey('GPS GPSLatitude') && data.containsKey('GPS GPSLongitude') && (data.containsKey("GPS GPSDate") || data.containsKey("Image DateTime")))
																{
																	double lonDeg = getDecimalFromRatio(data['GPS GPSLongitude'].values[0]);
																	double lonMin = getDecimalFromRatio(data['GPS GPSLongitude'].values[1]);
																	double lonSec = getDecimalFromRatio(data['GPS GPSLongitude'].values[2]);
																	
																	double latDeg = getDecimalFromRatio(data['GPS GPSLatitude'].values[0]);
																	double latMin = getDecimalFromRatio(data['GPS GPSLatitude'].values[1]);
																	double latSec = getDecimalFromRatio(data['GPS GPSLatitude'].values[2]);
																	
																	double longitude = getCoordFromDMS(lonDeg, lonMin, lonSec, data['GPS GPSLongitudeRef'].toString());
																	double latitude = getCoordFromDMS(latDeg, latMin, latSec, data['GPS GPSLatitudeRef'].toString());
																	
																	DateTime timestamp;
																	
																	if(data.containsKey("GPS GPSDate"))
																	{
																		List<String> dateComponents = data["GPS GPSDate"].toString().split(':');
																		timestamp = DateTime.utc(int.parse(dateComponents[0]), int.parse(dateComponents[1]), int.parse(dateComponents[2]));
																		print("GPSDATE:   " + timestamp.toString());
																	}
																	else if(data.containsKey("Image DateTime"))
																	{
																		List<String> dateComponents = data["Image DateTime"].toString().split(' ')[0].split(':');
																		timestamp = DateTime.utc(int.parse(dateComponents[0]), int.parse(dateComponents[1]), int.parse(dateComponents[2]));
																		print("DateTime:   " + timestamp.toString());
																	}
																	
																	
																	return;
																	
																	double altitude;
																	
																	if(data.containsKey('GPS GPSAltitude'))
																	{
																		altitude = getDecimalFromRatio(data['GPS GPSAltitude'].values[0]);
																	}
																	else
																	{
																		altitude = 0;
																	}
																	
																	_saveImage(pickedFile.path, "", longitude, latitude, altitude, timestamp, 0, 'N', 0);
																	setState(() {});
																}
																else
																{
																	showDialog(
																			context: context,
																			builder: (BuildContext context)
																			{
																				return AlertDialog(
																					title: Text(AppLocalizations.of(context).translate("GPS information missing")),
																					content: Text(AppLocalizations.of(context).translate("EXIF missing message")),
																					actions: <Widget>[
																						FlatButton(
																							child: Text(AppLocalizations.of(context).translate("Dismiss")),
																							onPressed: () {
																								Navigator.pop(context);
																							},
																						)
																					],
																				);
																			}
																	);
																}
															},
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
			},
		);
	}
	
	void printWrapped(String text) {
		final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
		pattern.allMatches(text).forEach((match) => print(match.group(0)));
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
