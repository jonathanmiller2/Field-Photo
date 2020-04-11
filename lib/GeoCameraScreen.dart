
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



class GeoCameraScreen extends StatefulWidget {
	
	@override
	_GeoCameraScreenState createState() => _GeoCameraScreenState();
}

class _GeoCameraScreenState extends State<GeoCameraScreen> {
	CameraController _controller;
	
	
	@override
	void initState()
	{
		super.initState();
		loadCameraController().then((result)
		{
			setState(() {
				_controller = result;
			});
		});
	}
	
	@override
	Widget build(BuildContext context)
	{
		if(_controller?.value?.aspectRatio == null)
			{
				return Container();
			}
		else
			{
				return AspectRatio(
						aspectRatio: _controller.value.aspectRatio,
						child: CameraPreview(_controller));
			}
	}
	
	Future<CameraController> loadCameraController() async {
		List<CameraDescription> cameras = await availableCameras();
		CameraController res = CameraController(cameras[0], ResolutionPreset.medium);
		await res.initialize();
		return res;
	}
}