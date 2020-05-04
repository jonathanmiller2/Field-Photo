
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImageSquare extends StatelessWidget {
	final String path;
	ImageSquare({this.path});
	
	//TODO: Add "uploaded" bool field, show on image squares
	
	@override
	Widget build(BuildContext context) {
		return AspectRatio(
			aspectRatio: 1,
			child: Image.file(
				File(path),
				fit: BoxFit.fitWidth, //Change to BoxFit.fill for previews stretched to show full photo
			),
		);
  }
}