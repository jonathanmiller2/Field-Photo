

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'main.dart';

class PositionIndicator extends StatelessWidget
{
	final String position = "35\u00b0 12\' 10\" N\, 97\u00b0 27\' 35\" W";
	final String confidence = "\u00B173\u00b0 / \u00B18yd.";
	
	static Position mostRecentPosition;
	
	final TextStyle mainTextStyle = TextStyle(
		fontSize: 18,
		color: Colors.white, // DARKMODE
		//color: Colors.blue[800], //LIGHTMODE
	);
	
	final TextStyle lesserTextStyle = TextStyle(
		fontSize: 14,
		color: Colors.white, // DARKMODE
		//color: Colors.blue[800], //LIGHTMODE
	);
	
	static var locationOptions = LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);
	
	@override
	Widget build(BuildContext context)
	{
		
		//TODO: Add the heading display on tap
		//TODO: Add Geolock
		//TODO: Detect when stream breaks (i.e. location services are abruptly turned off). Currently it just retains most recent position
		//TODO: Maybe show the timestamp of the most recent position?
		
		// ignore: non_constant_identifier_names
		String DMSPosition = "Unknown";
		String locationAccuracy = "";
		
		return new StreamBuilder<Position>(
				stream: MyApp.geolocator.getPositionStream(locationOptions),
				builder: (context, asyncSnapshot)
				{
					if(asyncSnapshot.hasError)
					{
						//TODO: Handle this properly
					}
					else if(asyncSnapshot.data == null)
					{
						//TODO: Handle this properly
					}
					else
					{
						mostRecentPosition = asyncSnapshot.data;
						DMSPosition = formatPositionAsDMS(asyncSnapshot.data);
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
	
	static Position getMostRecentPosition() {
		return mostRecentPosition;
	}
	
	String formatPositionAsDMS(Position position) {
		String latDir;
		if (position.latitude >= 0)
		{
			latDir = "N";
		}
		else
		{
			latDir = "S";
		}
		
		String lonDir;
		if (position.longitude >= 0)
		{
			lonDir = "E";
		}
		else
		{
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