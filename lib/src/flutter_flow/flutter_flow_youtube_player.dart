import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FlutterFlowYoutubePlayer extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final bool autoPlay;
  final bool looping;
  final bool mute;
  final bool showControls;
  final bool showFullScreen;
  final bool strictRelatedVideos;

  const FlutterFlowYoutubePlayer({
    Key? key,
    required this.url,
    required this.width,
    required this.height,
    this.autoPlay = false,
    this.looping = true,
    this.mute = false,
    this.showControls = true,
    this.showFullScreen = true,
    this.strictRelatedVideos = false,
  }) : super(key: key);

  @override
  _FlutterFlowYoutubePlayerState createState() =>
      _FlutterFlowYoutubePlayerState();
}

class _FlutterFlowYoutubePlayerState extends State<FlutterFlowYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        loop: widget.looping,
        mute: widget.mute,
        controlsVisibleAtStart: widget.showControls,
        hideControls: !widget.showControls,
        hideThumbnail: false,
        enableCaption: false,
        isLive: false,
        forceHD: false,
        disableDragSeek: false,
        showLiveFullscreenButton: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        aspectRatio: widget.width / widget.height,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        progressColors: const ProgressBarColors(
          playedColor: Colors.blue,
          handleColor: Colors.blueAccent,
        ),
        onReady: () {
          print('Player is ready.');
        },
      ),
      builder: (context, player) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: player,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
