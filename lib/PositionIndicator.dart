
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'localizations.dart';

class PositionIndicator extends StatefulWidget {
	static Position mostRecentPosition;
	static int mostRecentHeading;
	static bool isGeolocked = false;

	@override
	_PositionIndicatorState createState() => _PositionIndicatorState();

	static Position getMostRecentPosition() {
		return mostRecentPosition;
	}
	static int getMostRecentHeading() {
		return mostRecentHeading;
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
	// ignore: non_constant_identifier_names
	String DMSPosition = "Unknown";
	String locationAccuracy = "";
	String locationAge = "";
	String heading = "";
	bool showingHeading = false;
	Widget buttonChild;


	@override
	Widget build(BuildContext context) {

		TextStyle mainTextStyle = TextStyle(
				fontSize: 18,
				color: PositionIndicator.isGeolocked ? Colors.red[600] : Colors.white
		);

		TextStyle lesserTextStyle = TextStyle(
				fontSize: 14,
				color: PositionIndicator.isGeolocked ? Colors.red[600] : Colors.white
		);

		var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 11);
		var geolocator = Geolocator();

		return StreamBuilder<Position>(
				stream: geolocator.getPositionStream(locationOptions),
				builder: (context, positionSnapshot) {
					return StreamBuilder<double>(
							stream: FlutterCompass.events,
							builder: (context, compassSnapshot){

								if (compassSnapshot.hasError || !compassSnapshot.hasData || positionSnapshot.hasError || !positionSnapshot.hasData)
								{
									print("Position/Compass error");
									PositionIndicator.mostRecentPosition = PositionIndicator.isGeolocked ? PositionIndicator.mostRecentPosition : null;
									DMSPosition = AppLocalizations.of(context).translate("Unknown");
									locationAccuracy = "";
									heading = AppLocalizations.of(context).translate("Unknown");
								}
								else
								{
									Position pos = positionSnapshot.data;

									PositionIndicator.mostRecentPosition = PositionIndicator.isGeolocked ? PositionIndicator.mostRecentPosition : pos;
									PositionIndicator.mostRecentHeading = compassSnapshot.data.truncate();
									DMSPosition = PositionIndicator.formatPositionAsDMS(pos);
									locationAccuracy = "\u00B1" + pos.accuracy.truncate().toString() + "m";
									heading = compassSnapshot.data.truncate().toString() + "\u00B0 " + PositionIndicator.getDirFromHeading(compassSnapshot.data);

								}

								if(!showingHeading) {
									buttonChild = Column(
										mainAxisAlignment: MainAxisAlignment.center,
										children: <Widget>[
											Text(
													AppLocalizations.of(context).translate("Current Position"),
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

								return TextButton(
									child: buttonChild,
									style: TextButton.styleFrom(
											backgroundColor: Colors.transparent,
											primary: Colors.transparent
									),
									onPressed: () {
										setState(() {
											showingHeading = !showingHeading;
										});
									},
								);
							}
					);
				}
		);
	}

	@override
	void dispose() {
		super.dispose();
	}
}