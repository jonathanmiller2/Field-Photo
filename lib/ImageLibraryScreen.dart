

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import 'constants.dart' as Constants;

import 'ImageDetailScreen.dart';
import 'ImageSquare.dart';
import 'LoginSession.dart';

class ImageLibraryScreen extends StatefulWidget {
	
	@override
	_ImageLibraryScreenState createState() => _ImageLibraryScreenState();
}


class _ImageLibraryScreenState extends State<ImageLibraryScreen> {
	Database database;
	bool selectMode = false;
	Map<int, bool> imageSelections = new Map<int, bool>();
	
	
	Future<List<Map<String, dynamic>>> _loadImages() async {
		var databasesPath = await getDatabasesPath();
		String dbPath = join(databasesPath, 'FieldPhoto.db');
		
		//await deleteDatabase(dbPath);
		
		Database db = await openDatabase(dbPath, version:1,
				onCreate: (Database db, int version) async {
					//TODO: Add "uploaded" bool field, show on image squares
					await db.execute('CREATE TABLE photos (id INTEGER PRIMARY KEY, path STRING, userid INTEGER, description TEXT, long DOUBLE, lat DOUBLE, takendate TIMESTAMP, categoryid INTEGER, dir CHARACTER[4], dir_deg DOUBLE, uploaded BOOLEAN)');
				}
		);
		database = db;
		
		return await db.rawQuery('SELECT * FROM photos');
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
													"Library Error"
											)
									),
									content: Text(
											"There was an error showing your photo library. Please contact support" //TODO: Support email
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
				
				List<Widget> imageSquares = imageList.map<Widget> ((Map<String, dynamic> image) {
					if(selectMode)
					{
						if(imageSelections[image['id']])
						{
							return Container(
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
							return FlatButton(
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
					else {
						if (imageSelections[image['id']])
						{
							imageSelections[image['id']] = false;
							
							return FlatButton(
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
						else
						{
							return FlatButton(
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
					}
				}).toList();
				
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
							title: Text(
									'All Field Photos',
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
										label: selectMode ? 'Cancel' : 'Select',
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
													alignment: Alignment.center,
													child: Padding(
														padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
														child: LabelledInvisibleButton(
															label: "Share",
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
															label: "Upload",
															onPress: () {
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
																									"Please Log In"
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
																}
																
																
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
															label: "Delete",
															onPress: () {
																if(!selectionMade)
																{
																	return;
																}
																
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
											label: selectMode ? 'Cancel' : 'Select',
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
							)
					);
				}
			},
		);
	}
	
	Future<bool> uploadPhoto(Map<String, dynamic> photo) async {
		
		//CREATE TABLE photos (id INTEGER PRIMARY KEY, path STRING, userid INTEGER, description TEXT, long DOUBLE, lat DOUBLE, takendate TIMESTAMP, categoryid INTEGER, dir CHARACTER[4], dir_deg DOUBLE)
		
		
		var request = http.MultipartRequest('POST', Uri.parse(photo['path']));
		request.fields["landcover_cat"] = photo["categoryid"];
		request.fields["notes"] = photo["description"];
		request.fields["userid"] = photo[""];
		request.fields["lat"] = photo["lat"];
		request.fields["lng"] = photo["lng"];
		
		Map<String, dynamic> body = {
			'landcover_cat': photo["categoryid"],
			'notes': photo["description"],
			'userid': "TODO FIX MEE", //TODO: Find user ID
			'lat': photo['lat'],
			'lng': photo['lng'],
			'file': "TODO FIX MEEEEEEEEEEEEEEEE", //TODO: Post image binary
		};
		
		http.Response response = await http.post(Constants.UPLOAD_URL, body: body);
		
		print('Response status: ${response.statusCode}');
		print('Response body: ${response.body}');
		print('Response header: ${response.headers}');
		
		
		//await database.rawUpdate('UPDATE photos SET uploaded = ? WHERE id = ?', [true, photo['id']]);
	}
}