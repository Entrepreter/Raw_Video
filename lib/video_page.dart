import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class VideoApp extends StatefulWidget {
  final Orientation orientation;

  const VideoApp({Key key, this.orientation}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: _controller.value.initialized
            ? Builder(builder: (context) {
                if (widget.orientation == Orientation.landscape) {
                  return RotatedBox(
                    quarterTurns: 4,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child:
                            buildPlayerWithControls(_controller, widget.orientation),
                      ),
                    ),
                  );
                } else {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: buildPlayerWithControls(_controller, widget.orientation),
                  );
                }
              })
            : Container(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              ),
      ),
    );
  }

  bool isPlayPauseVisible = true;
  bool isVolumeVisible = false;
  bool optimized = false;

  buildPlayerWithControls(
      VideoPlayerController controller, Orientation orientation) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            enablePlayPause();
          },
          onPanUpdate: (details) {
            onUpdateVolume(details);
          },
          child: VideoPlayer(_controller),
        ),
        Visibility(
          visible: isPlayPauseVisible,
          child: Center(
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  enablePlayPause();
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 56,
            color: Colors.white.withOpacity(0.4),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Container(
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                      "${_controller.value.duration.inHours}:${_controller.value.duration.inMinutes}:${_controller.value.duration.inSeconds}"),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: _controller,
                      builder: (ctx, VideoPlayerValue s, ch) {
                        return Container(
                          child: Slider(
                              label: " ${s.position.inSeconds.toDouble()}",
                              min: 0,
                              max: s.duration.inSeconds.toDouble(),
                              value: s.position.inSeconds.toDouble(),
                              onChanged: (v) {
                                _controller
                                    .seekTo(Duration(seconds: v.toInt()));
                              }),
                        );
                      }),
                ),
                InkWell(
                  onTap: () {
                    if (isFullScreen) {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    } else {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]);
                    }
                    setState(() {
                      isFullScreen = !isFullScreen;
                    });
                  },
                  child: Container(
                    child: Icon(
                      isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        // Positioned(
        //     left: 56,
        //     top: 56,
        //     child: Visibility(
        //       visible: isVolumeVisible,
        //       child: Container(
        //         height: 56,
        //         color: Colors.black.withOpacity(0.1),
        //         width: 56,
        //         child: Text("${_controller.value.volume.toInt() .bitLength* 100} %"),
        //       ),
        //     ))
      ],
    );
  }

  void onUpdateVolume(DragUpdateDetails details) {
    if (!optimized) {
      setState(() {
        optimized = true;
        isVolumeVisible = true;
      });

      Future.delayed(Duration(seconds: 3)).then((value) {
        setState(() {
          isVolumeVisible = false;
          optimized = false;
        });
      });
    }
    double s = details.delta.dy;
    double d = MediaQuery.of(context).size.height;
    double v = (s / d) * 5;
    _controller.setVolume(_controller.value.volume - v);
  }

  void enablePlayPause() {
    setState(() {
      isPlayPauseVisible = true;
    });

    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        isPlayPauseVisible = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

// onPressed: () {
// setState(() {
// _controller.value.isPlaying
// ? _controller.pause()
//     : _controller.play();
// });
