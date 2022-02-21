import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:precious_tv/utils/constants.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:logger/logger.dart';
import 'package:better_player/better_player.dart';
import '../configs/size_config.dart';
import 'package:better_player/better_player.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
/// Homepage
class YtoubePlayerPage extends StatefulWidget {
  BetterPlayerController? betterPlayerController;
  var dataUrls;
 String? apiKey,
      channelId,
      videoId,
      texte,
      lien,
      url,
      title,
      img,
      date,
      related;
  final List<YT_API> ytResult;
  var data;
  YtoubePlayerPage(
      {Key? key,
       this.apiKey,this.data,
      this.channelId,
      this.videoId,
      required this.ytResult,
      this.texte,
      this.lien,
      this.url,
      this.title,
      this.img,
      this.date,
      this.related,this.betterPlayerController,this.dataUrls,
      required List videos})
      : super(key: key);

  @override
  _YtoubePlayerPageState createState() => _YtoubePlayerPageState();
}

class _YtoubePlayerPageState extends State<YtoubePlayerPage> {
  late YoutubePlayerController _controller;

  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UCIby2pzNJkvQsbc38shuGTw';

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String? uri,tite,lien,test;
  var logger =Logger();
  bool? videoLoading;
  BetterPlayerController? betterPlayerController;
  var data;
  var datas;
  VoidCallback? listeners;
  GlobalKey _betterPlayerKey = GlobalKey();
  late var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    autoDetectFullscreenAspectRatio: true,
    translations: [
      BetterPlayerTranslations(
        languageCode: "fr",
        generalDefaultError: "Impossible de lire la vidéo",
        generalNone: "Rien",
        generalDefault: "Défaut",
        generalRetry: "Réessayez",
        playlistLoadingNextVideo: "Chargement de la vidéo suivante",
        controlsNextVideoIn: "Vidéo suivante dans",
        overflowMenuPlaybackSpeed: "Vitesse de lecture",
        overflowMenuSubtitles: "Sous-titres",
        overflowMenuQuality: "Qualité",
        overflowMenuAudioTracks: "Audio",
        qualityAuto: "Auto",
      ),
    ],
    deviceOrientationsAfterFullScreen: [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    //autoDispose: true,
    controlsConfiguration: const BetterPlayerControlsConfiguration(
      iconsColor: Colors.cyan,
      //controlBarColor: colorPrimary,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
      enablePip: true,
      enableFullscreen: true,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: Colors.cyan,
      enableSkips: false,
      overflowMenuIconsColor: Colors.cyan,
      //overflowModalColor: Colors.amberAccent
    ),
  );
  Future<void> getData() async {
    final response = await http.get(Uri.parse(widget.dataUrls));
    data = json.decode(response.body);
    getDirect(data['allitems'][0]['feed_url']);

    logger.i('Ghost-Elite',data['allitems'][0]['alaune_feed']);
    return data;
  }
  Future<void> getDirect(String url) async {
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      datas = json.decode(response.body);
      setState(() {
        datas;
      });
    }
    PlayerInit(datas['direct_url']);
  }
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
  void PlayerInit(String url){
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      liveStream: true,
      /*notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: "Elephant dream",
        author: "Some author",
        imageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/African_Bush_Elephant.jpg/1200px-African_Bush_Elephant.jpg",
      ),*/
    );
    //betterPlayerController.setupDataSource(dataSource);
    widget.betterPlayerController?.setBetterPlayerGlobalKey(_betterPlayerKey);
    widget.betterPlayerController!.setupDataSource(dataSource)
        .then((response) {
      //s.logger.i(' Ghost-Elite ',dataSource);
      videoLoading = false;
    })
        .catchError((error) async {
      // Source did not load, url might be invalid
      inspect(error);
    });
  }
  youtubePlayer(){
    lien =widget.videoId;
    _controller = YoutubePlayerController(
      initialVideoId:
      lien!.split("=")[1],
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
    tite = widget.title;
  }

  @override
  void initState() {
    super.initState();
    youtubePlayer();
    //PlayerInit(widget.dataUrls);
    logger.i("initState");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      logger.i("WidgetsBinding");
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      logger.i("SchedulerBinding");
    });
    listeners = () {
      setState(() {
      });
    };
  }

  void listener() {
    if (_isPlayerReady && mounted && _controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

/*  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }*/

/*  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    //logger.i('message',datas['direct_url']);
    Wakelock.enable();
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: ColorPalette.appBarColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ColorPalette.appColorWhite),
              onPressed: () {
                //PlayerInit(widget.dataUrls);
                //PlayerInit();
                Navigator.of(context).pop();
              }
          ),
         //iconTheme: IconThemeData(color: ColorPalette.),
          title: Container(
            width: 100,
            height: 19.0,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/title.png')
                )
            ),
          ),

        ),
        body: Container(
          decoration: const BoxDecoration(
            color: ColorPalette.appColorWhite
          ),
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                //padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 90,
                    ),
                    Container(
                      width: double.infinity,
                      child: player,
                    ),
                    card(),
                    const SizedBox(
                      height: 10,
                    ),
                    videoSimilaire(),
                    Expanded(
                        child: makeItemEpecial(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget gridviewItem(){
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: const EdgeInsets.all(15),
      crossAxisSpacing: 8,
      mainAxisSpacing: 4,
      children: List.generate(widget.ytResult.length, (index) {
        return Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                /*Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => YtoubePlayerPage(
                                            videoId: widget.ytResult[index].url,
                                            title: widget.ytResult[index].title,
                                            ytResult: widget.ytResult)));*/
                setState(() {
                  uri = widget.ytResult[index].url;
                  //lien = widget.ytResult[index].url;
                });
                _controller.load(widget.ytResult[index].url.split("=")[1]);
                tite = widget.ytResult[index].title;
              },
              child: Stack(
                children: [
                  GestureDetector(
                    child: Container(
                      width: 150,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                '${widget.ytResult[index].thumbnail["medium"]["url"]}'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/play_button.png"))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text(
                  "${widget.ytResult[index].title}",
                  style: const TextStyle(
                      fontSize: 14,
                      color: ColorPalette.appBarColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        );
      }),
    );
  }
  Widget makeItemEpecial() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  //elevation: 4.0,
                  shadowColor: ColorPalette.appBarColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      YtoubePlayerPage(
                                        videoId: widget.ytResult[position].url,
                                        title:widget.ytResult[position].title,

                                        related: "",
                                        ytResult: widget.ytResult,
                                      )),
                                  (Route<dynamic> route) => true);*/
                          setState(() {
                            uri = widget.ytResult[position].url;
                            //lien = widget.ytResult[index].url;
                          });
                          _controller.load(widget.ytResult[position].url.split("=")[1]);
                          tite = widget.ytResult[position].title;
                        },
                        child: Stack(
                          children: [
                            GestureDetector(

                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: 140,
                                height: 80,
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:widget.ytResult[position].thumbnail["medium"]["url"],
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 80,
                                    placeholder: (context, url) =>
                                        Image.asset(
                                          "assets/images/vignete.png",fit: BoxFit.cover,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/vignete.png",fit: BoxFit.cover
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("assets/images/jouer.png")
                                      )
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${widget.ytResult[position].title}',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: ColorPalette.appBarColor),maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                           /* const SizedBox(height: 3,),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: Text(
                                '${widget.ytResult[position].description}',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: ColorPalette.appBarColor),maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )*/
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: widget.ytResult.length>24?24:widget.ytResult.length,
    );

  }
  Widget videoSimilaire() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.2),
          //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: const Text(
                  "Related Videos",
                  style: TextStyle(
                    color: ColorPalette.appBarColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "helvetica",
                  ),
                ),
              ),
              // SizedBox(width: 3,),

            ],
          ),
        ),
      ],
    );
  }

  Widget card() {
    return Container(
      width: SizeConfi.screenWidth,
      height: SizeConfi.screenHeight! / 20,
      decoration: const BoxDecoration(
          color: ColorPalette.appBarColor,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "${tite}",
                style: const TextStyle(
                  color: ColorPalette.appYellowColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: "helvetica",
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
