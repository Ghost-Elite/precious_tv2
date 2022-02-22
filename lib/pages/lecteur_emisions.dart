/*
import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class LecteurDesReplayes extends StatefulWidget {
  String? lien,videoId, title, time, api;

  var logger = Logger();
  bool? isVideoLoading = true;
  bool? isVisible = true;
  String? vodemi, ul, img, desc,typ,youtubeUri,idUrl;
  LecteurDesReplayes({required Key key, required this.vodemi, required this.ul, required this.img, required this.desc,required this.idUrl,required this.typ,required this.youtubeUri,required this.logger}) : super(key: key);

  @override
  _LecteurDesReplayesState createState() => _LecteurDesReplayesState();
}

class _LecteurDesReplayesState extends State<LecteurDesReplayes> with AutomaticKeepAliveClientMixin<LecteurDesReplayes> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  //YoutubePlayerController _controller;

  bool _isPlayerReady = false;
  YoutubeMetaData? _videoMetaData;
  PlayerState? _playerState;
  bool _muted = false;
  bool? isLoading;
  String? lien;
  bool? vrai;
  var logger = Logger();
  String? urId,titre,image,typeVideo,youtubeUl,url;
  YoutubePlayerController _controller=YoutubePlayerController(initialVideoId: "");
  BetterPlayerController? _betterPlayerController;
  var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
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
    controlsConfiguration: BetterPlayerControlsConfiguration(
      iconsColor: Colors.white,
      //controlBarColor: colorPrimary,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: Colors.white,
      enableSkips: false,
      overflowMenuIconsColor: Colors.white,
    ),
  );

  GlobalKey _betterPlayerKey = GlobalKey();
  //RelatedApi relatedApi;

  Future<void> fetchReplay() async {
    var postListUrl =
    Uri.parse(url);
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      // print(widget.listChanel.allitems[0].feedUrl);
      return ListChannelsbygroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
  Future<void> testUrl() async {
    final response = await http.get(urId);
    print(response.body);

    VideoUrl videoUrl = VideoUrl.fromJson(jsonDecode(response.body));
    logger.w(videoUrl.videoUrl);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoUrl.videoUrl,
        //liveStream: true,

        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,

          //notificationChannelName: "7TV Direct",
          //activityName: "7TV Direct",
          title: "Vous suivez MALIKIA TV en direct",
          imageUrl:
          "https://telepack.net/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-03-at-15.12.32.jpeg",
        )
    );

    _betterPlayerController?.setupDataSource(dataSource);
    _betterPlayerController?.setBetterPlayerGlobalKey(_betterPlayerKey);
  }
  Future<RelatedApi> FetchRelated() async {

    final response = await http.get(widget.ul);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //logger.w(listChannelsbygroup);
      setState(() {
        relatedApi = RelatedApi.fromJson(jsonDecode(response.body));
      });

      logger.i("ghost-elite",relatedApi.allitems[0].videoUrl);
      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  */
/*Future<RelatedItems> fetchEmission() async {
    var postListUrl = Uri.parse(widget.related);
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      widget.logger.d(jsonDecode(response.body));
      return RelatedItems.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
*//*

  playerYoutube(){
    */
/*_controller = YoutubePlayerController(
        initialVideoId: widget.youtubeUri.split("=")[1],
        flags: YoutubePlayerFlags(
          controlsVisibleAtStart: false,
          autoPlay: true,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true
        ));*//*

    _controller = YoutubePlayerController(
      initialVideoId: urId.replaceAll("https://www.youtube.com/watch?v=",""),
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
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    urId=widget.vodemi;
    titre=widget.desc;
    image=widget.img;
    typeVideo=widget.typ;
    //youtubeUl=widget.youtubeUri;
    betterPlayerConfiguration;
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    FetchRelated();

    //logger.i("1234656",relatedApi.allitems[0].desc);
  }




  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }
  @override
  void dispose() {
    widget.playerController.dispose();
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    //typeVideo=="youtube"?YoutubeVideo():Player(),
    return typeVideo =="youtube"?YoutubePlayerBuilder(

        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,


        ),
        builder: (context, player) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            flexibleSpace: Image(
              image: AssetImage('assets/images/headers.png'),
              fit: BoxFit.cover,
            ),
            title: Container(
              child: Text("Lecteur Vidéo",style: GoogleFonts.roboto(fontSize: 22,color: Palette.color4,fontWeight: FontWeight.bold),),
            ),

          ),
          body: Container(
            decoration: BoxDecoration(
              color: Palette.colorAlbayaneBg
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  //padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 90,
                      ),

                      Container(
                        height: 200,
                        child: player,
                      ),
                      //typeVideo=="youtube"?YoutubeVideo():Player(),
                     card(),
                      SizedBox(height: 5,),
                      Expanded(
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: Wrap(
                                children: [
                                  //videoSimilaire(),
                                  makeVideo(),
                                ],
                              ),
                            ),
                          )
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    ):Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Image(
          image: AssetImage('assets/images/headers.png'),
          fit: BoxFit.cover,
        ),
        title: Container(
          child: Text("Lecteur Vidéo",style: GoogleFonts.roboto(fontSize: 22,color: Palette.color4,fontWeight: FontWeight.bold),),
        ),

      ),
      body: Container(
        decoration: BoxDecoration(
          color: Palette.colorAlbayaneBg,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              //padding: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 90,
                  ),
                  playerVideo(),
                  //typeVideo=="youtube"?YoutubeVideo():Player(),
                  card(),
                  SizedBox(height: 5,),
                  Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: Wrap(
                            children: [
                              //videoSimilaire(),
                              makeVideo(),
                              playerVideo()
                            ],
                          ),
                        ),
                      )
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget card() {
    return Container(
      padding: EdgeInsets.all(8),
      width: double.infinity,
      height: 40,
      color: Palette.color4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(image))),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Container(
              child: Text(
                titre,
                style: TextStyle(
                  color: Palette.colorAlbayaneLeft,
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
  Widget youtube(){
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          */
/*bottomActions: <Widget>[
                   IconButton(
                     padding: EdgeInsets.all(30.0),
                     icon: Icon(
                       Icons.arrow_back,
                       color: Colors.white,
                     ),
                     onPressed: () {
                       _controller.toggleFullScreenMode();
                     },
                   ),
                 ],*//*

        ),
      ),
    );
  }
  Widget playerVideo() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,

        child: BetterPlayer(controller: _betterPlayerController),
        key: _betterPlayerKey,
      ),
      //child: playerVideo(),
    );
  }
  Widget makeVideo() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 4.0,
          shadowColor: Colors.grey,
          child: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      urId=relatedApi.allitems[position].videoUrl;
                      titre=relatedApi.allitems[position].title;
                      image=relatedApi.allitems[position].logo;
                      typeVideo=relatedApi.allitems[position].type;
                    });
                    if (typeVideo == "vod") {

                      testUrl();
                    }  else if (typeVideo == "youtube") {
                      _controller.load(relatedApi.allitems[position].videoUrl.split("=")[1]);
                    } else {

                    }
                    testUrl();
                    FetchRelated();
                    var  logger = Logger();
                    logger.w("Ghost-Elite",relatedApi.allitems[position].videoUrl);

                    logger.d(titre);
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${relatedApi.allitems[position].title}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Palette.colorBlack),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                urId=relatedApi.allitems[position].videoUrl;
                                titre=relatedApi.allitems[position].title;
                                image=relatedApi.allitems[position].logo;
                                typeVideo=relatedApi.allitems[position].type;
                              });
                              if (typeVideo == "vod") {

                                testUrl();
                              }  else if (typeVideo == "youtube") {
                                _controller.load(relatedApi.allitems[position].videoUrl.split("=")[1]);
                              } else {

                              }
                              testUrl();
                              FetchRelated();
                              var  logger = Logger();
                              logger.w("Ghost-Elite",relatedApi.allitems[position].videoUrl);

                              logger.d(titre);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 140,
                              height: 90,
                              child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  relatedApi.allitems[position].logo,
                                  fit: BoxFit.cover,
                                  width: 180,
                                  height: 90,
                                  placeholder: (context, url) =>
                                      Image.asset(
                                        "assets/images/vignete.png",
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        "assets/images/vignete.png",
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/play_button.png"))),
                              ),
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: relatedApi==null?0:relatedApi.allitems.length,
    );
  }
}
*/
