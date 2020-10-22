import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraApp extends StatefulWidget {
  final Orientation orientation;

  const CameraApp({Key key, this.orientation}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    List<CameraDescription> cameras;

    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

    controller =
        CameraController(cameras[1], ResolutionPreset.max, enableAudio: true);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return CircularProgressIndicator();
    }
    if (!controller.value.isInitialized) {
      return Container();
    }

    return Builder(builder: (context) {
      print(widget.orientation);
      if (widget.orientation == Orientation.landscape) {
        print("ss");
        return RotatedBox(
          quarterTurns: 3,
          child: SizedBox(
            width: MediaQuery.of(context).size.height / 3,
            child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller)),
          ),
        );
      } else {
        return Container(
          width: MediaQuery.of(context).size.width / 3,
          child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller)),
        );
      }
    });
  }
}
