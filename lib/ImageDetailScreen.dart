

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class ImageDetailScreen extends StatefulWidget {
	
	final int id;
	final Database database;
	
	ImageDetailScreen({this.id, this.database});
	
	@override
	_ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
	@override
	Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}