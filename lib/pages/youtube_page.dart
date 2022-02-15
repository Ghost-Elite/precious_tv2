import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/constants.dart';
class YoutubePages extends StatefulWidget {
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  YoutubePages({Key? key,required this.ytResult,required this.ytResultPlaylist,this.ytApi,this.ytApiPlaylist}) : super(key: key);

  @override
  _YoutubePagesState createState() => _YoutubePagesState();
}

class _YoutubePagesState extends State<YoutubePages> {
  late YoutubePlayerController _controller;

  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UCIby2pzNJkvQsbc38shuGTw';

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String? uri,tite,lien,test;
  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];
  @override
  void initState() {
    super.initState();
    lien =widget.ytResult[0].url;
    _controller = YoutubePlayerController(
      initialVideoId: lien!.split("=")[1],
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,

      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    //tite = widget.title;
  }
  void listener() {
    if (_isPlayerReady && mounted && _controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.pause();
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        extendBodyBehindAppBar: true,

        body: Container(
          decoration: const BoxDecoration(
              color: ColorPalette.appColorWhite
          ),
          child: Container(
            width: double.infinity,
            child: player,
          ),
        ),
      ),
    );
  }
}
