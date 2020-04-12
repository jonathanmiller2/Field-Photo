
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



class CameraPassthrough extends StatefulWidget {
	
	@override
	_CameraPassthroughState createState() => _CameraPassthroughState();
}

class _CameraPassthroughState extends State<CameraPassthrough> {
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
			return Center(child: CircularProgressIndicator());
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
	
	@override
	void dispose() {
		// Dispose of the controller when the widget is disposed.
		_controller.dispose();
		super.dispose();
	}
	
}