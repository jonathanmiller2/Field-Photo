

import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'ImageSquare.dart';

class PhotoLibraryScreen extends StatefulWidget {
	
	@override
	_PhotoLibraryScreenState createState() => _PhotoLibraryScreenState();
}


class _PhotoLibraryScreenState extends State<PhotoLibraryScreen> {
	Database database;
	
	
	
	Future<List<Map<String, dynamic>>> _loadImages() async {
		var databasesPath = await getDatabasesPath();
		String dbPath = join(databasesPath, 'FieldPhoto.db');
		
		//await deleteDatabase(dbPath);
		
		Database db = await openDatabase(dbPath, version:1,
				onCreate: (Database db, int version) async {
					await db.execute('CREATE TABLE photos (id INTEGER PRIMARY KEY, path STRING, userid INTEGER, description TEXT, long DOUBLE, lat DOUBLE, takendate TIMESTAMP, categoryid INTEGER, dir CHARACTER[4], dir_deg DOUBLE)');
				}
		);
		database = db;
		
		return await db.rawQuery('SELECT id FROM photos');
	}
	
	@override
	Widget build(BuildContext context) {
		
		return new FutureBuilder<List<Object>>(
			future: _loadImages(),
			builder: (context, asyncSnapshot) {
				
				if(asyncSnapshot.hasError)
				{
					//TODO: Handle this error
					print(asyncSnapshot.error);
				}
				
				if(database == null || !asyncSnapshot.hasData)
				{
					return Container(
							height: 150,
							child: Center(child: CircularProgressIndicator())
					);
				}
				
				print("Library data: " + asyncSnapshot.toString());
				
				List<Map<String, dynamic>> photoList = asyncSnapshot.data;
				
				List<Widget> photoSquares = photoList.map<Widget> ((Map<String, dynamic> photo) {
					
					return FlatButton(
						padding: const EdgeInsets.all(0),
						child: ImageSquare(
								id: photo['id'],
								database: database
						),
						onPressed: () {
							//TODO: Navigate to a page showing the image in full resolution
							print('image '+photo['id'].toString()+' pressed');
						},
					);
				}).toList();
				
				
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
						body: GridView.count(
							crossAxisCount: 3,
							crossAxisSpacing: 5,
							mainAxisSpacing: 5,
							children: photoSquares,
						)
				);
			},
		);
		
		
		
	}
}