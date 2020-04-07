
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



class GeoCameraScreen extends StatefulWidget {
	
	@override
	_GeoCameraScreenState createState() => _GeoCameraScreenState();
}

class _GeoCameraScreenState extends State<GeoCameraScreen> {
	CameraController controller;
	
	@override
	Widget build(BuildContext context) {
		Future<List<CameraDescription>> _cameras = availableCameras();
		
		return FutureBuilder<List<CameraDescription>>(
			future: _cameras,
			builder: (BuildContext context, AsyncSnapshot<List<CameraDescription>> snapshot)
				{
					if(snapshot.hasData && controller.value.isInitialized)
						{
							controller = CameraController(snapshot.data[0], ResolutionPreset.medium);
							controller.initialize();
							
							return AspectRatio(
									aspectRatio:
									controller.value.aspectRatio,
									child: CameraPreview(controller));
						}
					else
						{
							return Container();
						}
				}
		);
	}
}