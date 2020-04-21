
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class ImageSquare extends StatefulWidget {
	final int id;
	final Database database;
	ImageSquare({this.id, this.database});
	
	@override
	_ImageSquareState createState() => _ImageSquareState();
}

class _ImageSquareState extends State<ImageSquare> {
	
	String imagePath;
	
	@override
	void initState() {
		super.initState();
		_getImagePath();
	}
	
	void _getImagePath() async {
		String path = (await widget.database.rawQuery('SELECT PATH FROM photos WHERE id = ?', [widget.id]))[0]['path'];
		print(await widget.database.rawQuery('SELECT PATH FROM photos WHERE id = ?', [widget.id]));
		setState(() {
			imagePath = path;
		});
	}
	
	@override
	Widget build(BuildContext context) {
		if(imagePath == null)
		{
			return Container(
					height: 150,
					child: Center(child: CircularProgressIndicator())
			);
		}
		else {
			return AspectRatio(
				aspectRatio: 1,
				child: Image.file(
					File(imagePath),
					fit: BoxFit.fitWidth, //Change to BoxFit.fill for previews stretched to show full photo
				),
			);
		}
	}
}