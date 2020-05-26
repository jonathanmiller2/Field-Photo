import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class CameraPassthrough extends StatefulWidget {
	@override
	_CameraPassthroughState createState() => _CameraPassthroughState();
}

class _CameraPassthroughState extends State<CameraPassthrough> {
	
	@override
	void initState()
	{
		super.initState();
		loadCameraController().then((result)
		{
			setState(() {
				MyApp.cameraController = result;
			});
		});
	}
	
	@override
	Widget build(BuildContext context) {
		//TODO: This may need to be a future builder. As it stands, if the aspect ratio isn't defined when the app builds, it will likely never rebuild to show the preview
		if(MyApp.cameraController?.value?.aspectRatio == null)
		{
			return Container(
					height: 150,
					child: Center(child: CircularProgressIndicator())
			);
		}
		else
		{
			return AspectRatio(
					aspectRatio: MyApp.cameraController.value.aspectRatio,
					child: CameraPreview(MyApp.cameraController));
		}
	}
	
	Future<CameraController> loadCameraController() async {
		List<CameraDescription> cameras = await availableCameras();
		CameraController res = CameraController(cameras[0], ResolutionPreset.medium);
		await res.initialize();
		return res;
	}
	
	@override
	void dispose() {
		MyApp.cameraController.dispose();
		super.dispose();
	}
	
}