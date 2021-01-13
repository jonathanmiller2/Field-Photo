import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'main.dart';

class CameraPassthrough extends StatefulWidget {
  @override
  _CameraPassthroughState createState() => _CameraPassthroughState();
}

class _CameraPassthroughState extends State<CameraPassthrough> {
  bool zoom = true;
  double scaleFactor = 1.0;
  double baseScaleFactor = 1.0;
  double lowerLimit;
  double upperLimit;
  int pointers = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> asyncTasks() async {
    List<CameraDescription> cameras = await availableCameras();
    CameraController res = CameraController(cameras[0], ResolutionPreset.medium);
    await res.initialize();
    MyApp.cameraController = res;
    MyApp.cameraController.setFlashMode(FlashMode.off);
    lowerLimit = await MyApp.cameraController.getMinZoomLevel();
    upperLimit = await MyApp.cameraController.getMaxZoomLevel();
    return true; //Some data must be returned for .hasData to work (More consistent than checking connection state)
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: asyncTasks(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return AspectRatio(
                aspectRatio: MyApp.cameraController.value.aspectRatio,
                child: Listener(
                  onPointerDown: (x) {
                    pointers = (pointers + 1).clamp(0, 2);
                  },
                  onPointerUp: (x) {
                    pointers = (pointers - 1).clamp(0, 2);
                  },
                  child: GestureDetector(
                      child: CameraPreview(MyApp.cameraController),
                      onScaleStart: (scaleUpdate) async {
                        if (pointers >= 2) {
                          baseScaleFactor = scaleFactor;
                        }
                      },
                      onScaleUpdate: (scaleUpdate) async {
                        if (pointers >= 2) {
                          //Change scale to zoomlevel
                          //double newScale = (baseScaleFactor * scaleUpdate.scale).clamp(0.1, 10.0);
                          //double zoom = (newScale / 10) * (upperLimit - lowerLimit) + lowerLimit;

                          double newScale = (baseScaleFactor * scaleUpdate.scale).clamp(lowerLimit, upperLimit);
                          double zoom = newScale;
                          MyApp.cameraController.setZoomLevel(zoom);
                          scaleFactor = newScale;
                        }
                      },
                      onScaleEnd: (scaleUpdate) {
                        baseScaleFactor = scaleFactor;
                      }),
                ));
          } else {
            return Container(height: MediaQuery.of(context).size.height * 0.75, child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  @override
  void dispose() {
    MyApp.cameraController.dispose();
    super.dispose();
  }
}
