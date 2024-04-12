import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum VideoType { asset, network }

class FlutterFlowVideoPlayer extends StatefulWidget {
  final String path;
  final VideoType videoType;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool allowFullScreen;
  final bool allowPlaybackSpeedMenu;
  final bool pauseOnNavigate;

  const FlutterFlowVideoPlayer({
    Key? key,
    required this.path,
    required this.videoType,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.allowFullScreen = true,
    this.allowPlaybackSpeedMenu = true,
    this.pauseOnNavigate = true,
  }) : super(key: key);

  @override
  _FlutterFlowVideoPlayerState createState() => _FlutterFlowVideoPlayerState();
}

class _FlutterFlowVideoPlayerState extends State<FlutterFlowVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeVideo() {
    if (widget.videoType == VideoType.network) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.path)
      );
    } else {
      _controller = VideoPlayerController.asset(
        widget.path,
      );
    }

    _controller.initialize().then((_) {
      _controller.setVolume(0);
      if (widget.autoPlay) {
        _controller.play();
      }
      _controller.setLooping(widget.looping);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller),
          if (widget.showControls) _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return AnimatedOpacity(
      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        color: Colors.black26,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (widget.allowFullScreen) _buildFullScreenButton(),
            if (widget.allowPlaybackSpeedMenu) _buildSpeedMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenButton() {
    return IconButton(
      icon: Icon(Icons.fullscreen),
      onPressed: () {
        // Implement full screen functionality
      },
    );
  }

  Widget _buildSpeedMenu() {
    return PopupMenuButton<double>(
      icon: Icon(Icons.speed),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
        PopupMenuItem(
          value: 0.5,
          child: Text('0.5x'),
        ),
        PopupMenuItem(
          value: 1.0,
          child: Text('1.0x'),
        ),
        PopupMenuItem(
          value: 1.5,
          child: Text('1.5x'),
        ),
        PopupMenuItem(
          value: 2.0,
          child: Text('2.0x'),
        ),
      ],
      onSelected: (speed) {
        _controller.setPlaybackSpeed(speed);
      },
    );
  }
}
