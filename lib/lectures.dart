import 'package:flutter/gestures.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Teachers/teacherAccount.dart';
import 'package:flutter_class/widgets.dart';

import 'Accounts/authentication.dart';

class Lectures extends StatefulWidget {
  @override
  State<Lectures> createState() => LecturesState();
}


class LecturesState extends State<Lectures> {
  final videoUrl = "https://www.youtube.com/watch?v=jzh3DfUtRhE";

  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  @override
  void initState(){
    final videoID = YoutubePlayer.convertUrlToId(videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    )..addListener(() {
      if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
        setState(() {
          _playerState = _controller.value.playerState;
          _videoMetaData = _controller.metadata;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            YoutubePlayer(
                controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                  _isPlayerReady = true;
                  debugPrint('Ready');
                  },
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: Colors.white38,
                    handleColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

}
