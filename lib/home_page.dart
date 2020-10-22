import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raw_video/camera_page.dart';
import 'package:raw_video/network/auth_helper.dart';
import 'package:raw_video/video_page.dart';

bool isFullScreen = false;

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        SystemChrome.setEnabledSystemUIOverlays([]);
      } else {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      }

      // if (offset.dx > screen.width ||
      //     offset.dx < 0 ||
      //     offset.dy > screen.height ||
      //     offset.dy < 0) {
      //   setState(() {
      //     offset = Offset.zero;
      //   });
      //   Scaffold.of(context).showSnackBar(
      //       SnackBar(content: Text("Out of screen, setting back to 0 ,0")));
      // }
      return Scaffold(
        bottomNavigationBar: ColoredBox(
          color: Colors.black87,
          child: ListTile(
            title: Text(
              "${widget.user.email}",
              style: TextStyle(color: Colors.white),
            ),
            // trailing: FlatButton(
            //   onPressed: () {
            //     AuthHelper()
            //       ..signOutGoogle().then((value) => SystemNavigator.pop());
            // //   },
            //   child: Text("Sign out"),
            //   textColor: Theme.of(context).primaryColor,
            // ),
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return Stack(
            children: [
              VideoApp(
                orientation: orientation,
              ),
              Positioned(
                child: GestureDetector(
                  child: CameraApp(
                    orientation: orientation,
                  ),
                  onPanUpdate: (details) {
                    setState(() {
                      offset =
                          offset.translate(details.delta.dx, details.delta.dy);
                    });
                  },
                ),
                top: offset.dy,
                left: offset.dx,
              )
            ],
          );
        }),
      );
    });
  }
}
