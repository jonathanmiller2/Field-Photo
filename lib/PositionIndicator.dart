

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'main.dart';

class PositionIndicator extends StatefulWidget {
	static Position mostRecentPosition;
	static bool isGeolocked = false;
	
	@override
	_PositionIndicatorState createState() => _PositionIndicatorState();
	
	static Position getMostRecentPosition() {
		return mostRecentPosition;
	}
	
	static void toggleGeolock() {
		isGeolocked = !isGeolocked;
	}
	
	static String formatPositionAsDMS(Position position) {
		String latDir;
		if (position.latitude >= 0) {
			latDir = "N";
		}
		else {
			latDir = "S";
		}
		
		String lonDir;
		if (position.longitude >= 0) {
			lonDir = "E";
		}
		else {
			lonDir = "W";
		}
		
		double lat = position.latitude.abs();
		double lon = position.longitude.abs();
		
		int latDeg = lat.truncate();
		int latMin = ((lat % 1) * 60).truncate();
		int latSec = ((((lat % 1) * 60) % 1) * 60).truncate();
		String latDMS = latDeg.toString() + "\u00b0 " + latMin.toString() + "\' " + latSec.toString() + "\"" + " " + latDir;
		
		int lonDeg = lon.truncate();
		int lonMin = ((lon % 1) * 60).truncate();
		int lonSec = ((((lon % 1) * 60) % 1) * 60).truncate();
		String lonDMS = lonDeg.toString() + "\u00b0 " + lonMin.toString() + "\' " + lonSec.toString() + "\"" + " " + lonDir;
		
		return latDMS + ", " + lonDMS;
	}
}

class _PositionIndicatorState extends State<PositionIndicator>
{
	Timer _updateTimer;
	
	// ignore: non_constant_identifier_names
	String DMSPosition = "Unknown";
	String locationAccuracy = "";
	String locationAge = "";
	
	@override
	void initState() {
		_updateTimer = new Timer.periodic(
				Duration(seconds: 4), //TODO: This is the location renewal timer, may need fine tuned if performance issues arise
						(timer){
					setState(() {});
				}
		);
		super.initState();
	}
	
	@override
	Widget build(BuildContext context) {
		//TODO: Add the heading display on tap
		//TODO: Add Geolock
		//TODO: Detect when stream breaks (i.e. location services are abruptly turned off). Currently it just retains most recent position
		
		TextStyle mainTextStyle = TextStyle(
			fontSize: 18,
			color: PositionIndicator.isGeolocked ? Colors.red[600] : Colors.white, // DARKMODE
			//color: PositionIndicator.isGeolocked ? Colors.red[600] : Colors.blue[800], //LIGHTMODE
		);
		
		TextStyle lesserTextStyle = TextStyle(
			fontSize: 14,
			color: PositionIndicator.isGeolocked ? Colors.red[600] : Colors.white, // DARKMODE
			//color: PositionIndicator.isGeolocked ? Colors.red[600] : Colors.blue[800], //LIGHTMODE
		);
		
		if(PositionIndicator.isGeolocked)
		{
			return Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					Text(
							"Geolocked Position",
							style: mainTextStyle
					),
					Text(
							DMSPosition,
							style: mainTextStyle
					),
					Text(
							locationAccuracy,
							style: lesserTextStyle
					),
				],
			);
		}
		else
		{
			return new FutureBuilder<Position>(
					future: MyApp.geolocator.getCurrentPosition(),
					builder: (context, asyncSnapshot) {
						if (asyncSnapshot.hasError) {
							//TODO: Handle this properly
						}
						else if (asyncSnapshot.data == null) {
							//TODO: Handle this properly
						}
						else {
							PositionIndicator.mostRecentPosition = asyncSnapshot.data;
							DMSPosition = PositionIndicator.formatPositionAsDMS(asyncSnapshot.data);
							locationAccuracy = "\u00B1" + asyncSnapshot.data.accuracy.truncate().toString() + "m";
						}
						
						//TODO: Use asyncSnapshot.data.heading for camera screen's heading
						//TODO: Use asyncSnaphot.data.timestamp for database timestamp in the future
						
						
						return Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								Text(
										"Current Position",
										style: mainTextStyle
								),
								Text(
										DMSPosition,
										style: mainTextStyle
								),
								Text(
										locationAccuracy,
										style: lesserTextStyle
								),
							],
						);
					}
			);
		}
	}
	
	@override
	void dispose() {
		_updateTimer.cancel();
		super.dispose();
	}
}