import 'package:url_launcher/url_launcher.dart';
import 'package:field_photo/LabelledInvisibleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context)
	{
		return Scaffold(
				appBar: AppBar(
					title: Text(
							'About',
							style: TextStyle(
								fontSize: 25.0,
								color: Colors.black,
							)
					),
					backgroundColor: Colors.white,
					centerTitle: true,
					iconTheme: IconThemeData(
							color: Colors.black
					),
				),
				body: Container(
					color: Colors.grey[200],
					child: Padding(
						padding: const EdgeInsets.all(35),
						child: Column(
							mainAxisAlignment: MainAxisAlignment.start,
							crossAxisAlignment: CrossAxisAlignment.stretch,
							mainAxisSize: MainAxisSize.max,
							children: <Widget>[
								Padding(
									padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
									child: Container(
										height: 200,
										child: Center(
											child: Text(
												'This citizen science effort enables you to share your field photos, show your footprint of travel, and support monitoring of our planet Earth \n\n'
														'Visit the Earth Observation and Modeling Facility (EOMF) website to view photos and satellite data.',
												style: TextStyle(
													fontSize: 18,
													color: Colors.grey[800],
												),
												textAlign: TextAlign.center,
											),
										),
									),
								),
								LabelledInvisibleButton(
									label: 'Visit the EOMF',
									onPress: () async {
										String url = 'http://eomf.ou.edu/photos/';
										if (await canLaunch(url)) {
											await launch(url);
										}
										else {
											throw 'Could not launch $url';
										}
									},
									defaultColor: Colors.blue[900],
									pressedColor: Colors.white,
								)
							],
						),
					),
				)
		);
	}
	
}