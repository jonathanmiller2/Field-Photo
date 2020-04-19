

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
	
	static String getDirFromHeading(double heading)
	{
		if(heading <= 22.5)
		{
			return "N";
		}
		else if(heading <= 67.5)
		{
			return "NE";
		}
		else if(heading <= 112.5)
		{
			return "E";
		}
		else if(heading <= 157.5)
		{
			return "SE";
		}
		else if(heading <= 202.5)
		{
			return "S";
		}
		else if(heading <= 247.5)
		{
			return "SW";
		}
		else if(heading <= 292.5)
		{
			return "W";
		}
		else if(heading <= 337.5)
		{
			return "NW";
		}
		else if(heading <= 360)
		{
			return "N";
		}
		else
		{
			return "ERR";
		}
	}
	
}

class _PositionIndicatorState extends State<PositionIndicator>
{
	Timer _updateTimer;
	
	// ignore: non_constant_identifier_names
	String DMSPosition = "Unknown";
	String locationAccuracy = "";
	String locationAge = "";
	String heading = "";
	bool showingHeading = false;
	Widget buttonChild;
	
	@override
	void initState() {
		_updateTimer = new Timer.periodic(
				Duration(milliseconds: 500), //TODO: This is the location renewal timer, may need fine tuned if performance issues arise
						(timer){
					setState(() {});
				}
		);
		super.initState();
	}
	
	@override
	Widget build(BuildContext context) {
		
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
			if(!showingHeading)
			{
				buttonChild = Column(
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
				buttonChild = Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text(
								"Heading",
								style: mainTextStyle
						),
						Text(
								heading,
								style: mainTextStyle
						),
					],
				);
			}
			
			return FlatButton(
				child: buttonChild,
				color: Color.fromARGB(0, 0, 0, 0),
				onPressed: () {
					setState(() {
						showingHeading = !showingHeading;
						
					});
				},
			);
		}
		else
		{
			
			//TODO: If we want to NOT geolock the heading, we need to always return this future builder, saving a new position with the new heading, but same location as before. Basically we need to delete every if statement above this line
			
			return new FutureBuilder<List<Object>>(
					future: Future.wait([
						MyApp.geolocator.getCurrentPosition(),
						MyApp.geolocator.isLocationServiceEnabled()
					]),
					builder: (context, asyncSnapshot) {
						
						if (asyncSnapshot.hasError || asyncSnapshot.data == null)
						{
							PositionIndicator.mostRecentPosition = null;
							DMSPosition = "Unknown";
							locationAccuracy = "";
							heading = "Unknown";
						}
						else {
							Position pos = asyncSnapshot.data[0];
							bool locationServiceEnabled = asyncSnapshot.data[1];
							
							if(locationServiceEnabled)
							{
								PositionIndicator.mostRecentPosition = pos;
								DMSPosition = PositionIndicator.formatPositionAsDMS(pos);
								locationAccuracy = "\u00B1" + pos.accuracy.truncate().toString() + "m";
								heading = pos.heading.truncate().toString() + "\u00B0 " + PositionIndicator.getDirFromHeading(pos.heading);
							}
							else
							{
								PositionIndicator.mostRecentPosition = null;
								DMSPosition = "Unknown";
								locationAccuracy = "";
								heading = "Unknown";
							}
						}
						
						if(!showingHeading) {
							buttonChild = Column(
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
						else {
							buttonChild = Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									Text(
											"Heading",
											style: mainTextStyle
									),
									Text(
											heading,
											style: mainTextStyle
									),
								],
							);
						}
						
						return FlatButton(
							child: buttonChild,
							color: Color.fromARGB(0, 0, 0, 0),
							onPressed: () {
								setState(() {
									showingHeading = !showingHeading;
								});
							},
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