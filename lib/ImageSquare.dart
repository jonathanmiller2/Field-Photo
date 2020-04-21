
import 'package:field_photo/ImageDetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class ImageSquare extends StatefulWidget {
	final int id;
	final Database database;
	final Function onSelect;
	final bool selectMode;
	ImageSquare({this.id, this.database, this.onSelect, this.selectMode});
	
	@override
	_ImageSquareState createState() => _ImageSquareState();
}

class _ImageSquareState extends State<ImageSquare> {
	bool isSelected = false;
	String imagePath;
	
	bool getIsSelected() {
		return isSelected;
	}
	
	void deselect() {
		setState(() {
			isSelected = false;
		});
	}
	
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
		
		if(isSelected)
		{
			return Container(
				decoration: BoxDecoration(
						color: Colors.red,
						border: Border.all(
							color: Colors.blue[600],
							width: 3,
						),
				),
				child: FlatButton(
						padding: const EdgeInsets.all(0),
						child: AspectRatio(
							aspectRatio: 1,
							child: Image.file(
								File(imagePath),
								fit: BoxFit.fitWidth, //Change to BoxFit.fill for previews stretched to show full photo
							),
						),
						onPressed: () {
							setState(() {
								isSelected = !isSelected;
							});
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
						child: Image.file(
							File(imagePath),
							fit: BoxFit.fitWidth, //Change to BoxFit.fill for previews stretched to show full photo
						),
					),
					onPressed: () {
						if(widget.selectMode)
						{
							setState(() {
								isSelected = !isSelected;
							});
						}
						else
						{
							Navigator.push(
								context,
								new MaterialPageRoute(builder: (context) => new ImageDetailScreen(id: widget.id, database: widget.database)),
							);
						}
					}
			);
		}
		
		
	}
}