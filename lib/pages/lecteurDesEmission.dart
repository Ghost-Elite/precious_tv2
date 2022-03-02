import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart'as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../configs/size_config.dart';
import '../utils/constants.dart';
class LecteurDesEmissions extends StatefulWidget {
  var videoUrl,videoItems,title;
  var dataToLoad;
  LecteurDesEmissions({Key? key,this.videoUrl,this.videoItems,this.title,this.dataToLoad}) : super(key: key);

  @override
  _LecteurDesEmissionsState createState() => _LecteurDesEmissionsState();
}

class _LecteurDesEmissionsState extends State<LecteurDesEmissions> {
  var logger=Logger();
  var data,dataEmis,urlData,title,ulVod,datTitle,dates;
  BetterPlayerController? betterPlayerController;
  YoutubePlayerController? _controller;
  GlobalKey _betterPlayerKey1 = GlobalKey();
  late var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    //autoDetectFullscreenAspectRatio: true,
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
      iconsColor: ColorPalette.appColorWhite,
      //controlBarColor: colorPrimary,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
      controlBarColor: Colors.transparent,
      enablePip: true,
      enableFullscreen: true,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: ColorPalette.appColorWhite,
      enableSkips: false,
      overflowMenuIconsColor: ColorPalette.appColorWhite,
      //overflowModalColor: Colors.amberAccent
    ),
  );
  Future<void> getVODVideos() async {
    final response = await http.get(Uri.parse(urlData));
      setState(() {
        data = json.decode(response.body);
      });

    logger.i(' Ghost-Elite 2022 ',data['video_url']);
    getInitPlayer(data['video_url']);
    /*if (widget.onPlay == "vod") {
      getInitPlayer(data['video_url']);
    } else {
      iniPlayerYoutube(data['video_url']);
    }*/
    return data;
  }
  Future<void> getVODVideosYoutube() async {
    final response = await http.get(Uri.parse(urlData));
    setState(() {
      data = json.decode(response.body);
    });

    logger.i(' Ghost-Elite 2022 ',data['video_url']);
    iniPlayerYoutube(data['video_url']);
    if (widget.dataToLoad == "vod") {
      getInitPlayer(data['video_url']);
    } else {
      getInitPlayers(widget.videoUrl);
    }
    return data;
  }
  Future<void> getVODEmissions() async {
    final response = await http.get(Uri.parse(ulVod));
    setState(() {
      dataEmis = json.decode(response.body);
    });
    //getDirect(dataVOD['allitems'][0]['feed_url']);

    //logger.i(' Ghost-Elite 2022 yuu',widget.videoItems);
    return dataEmis;
  }

  getInitPlayer(String url) {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network, url,
      liveStream: false,
      asmsTrackNames: ["3G 360p", "SD 480p", "HD 1080p"],
    );
    if (betterPlayerController != null) {
      betterPlayerController!.pause();
      betterPlayerController!.setupDataSource(betterPlayerDataSource);
    } else {
      betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
          betterPlayerDataSource: betterPlayerDataSource);
    }
    betterPlayerController!.setBetterPlayerGlobalKey(_betterPlayerKey1);
  }
  getInitPlayers(String url) {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network, url,
      liveStream: false,
      asmsTrackNames: ["3G 360p", "SD 480p", "HD 1080p"],
    );
    if (betterPlayerController != null) {
      betterPlayerController!.pause();
      betterPlayerController!.setupDataSource(betterPlayerDataSource);
    } else {
      betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
          betterPlayerDataSource: betterPlayerDataSource);
    }
    betterPlayerController!.setBetterPlayerGlobalKey(_betterPlayerKey1);
  }
  iniPlayerYoutube(String url) {
    _controller = YoutubePlayerController(
      initialVideoId: '${data['video_url']}'.split("=")[1],
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    urlData=widget.videoUrl;
    ulVod=widget.videoItems;
    title=widget.title;
    if(widget=="vod"){
      getVODVideos();
    }else{
      getVODVideosYoutube();
    }

    getVODEmissions();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    betterPlayerController!.dispose();
    //betterPlayerController ==null;
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    betterPlayerController?.dispose();
    betterPlayerController ==null;
  }

  @override
  Widget build(BuildContext context) {
    logger.i(' message yy',urlData);
    return widget.dataToLoad=="vod"?Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: ColorPalette.appColorWhite),
            onPressed: () {
              //PlayerInit(widget.dataUrls);
              //PlayerInit();
              Navigator.of(context).pop();
            }),
        //iconTheme: IconThemeData(color: ColorPalette.),
        title: Container(
          width: 100,
          height: 19.0,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/title.png'))),
        ),
      ),
      body: Container(
        decoration:
        const BoxDecoration(color: ColorPalette.appColorWhite),
        child: Container(
          height: MediaQuery.of(context).size.height,
          //padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 83,
              ),
              Container(
                width: double.infinity,
                child: player(),
              ),
              card(),
              const SizedBox(
                height: 10,
              ),
              videoSimilaire(),
              Expanded(
                child: cardItems(),
              )
            ],
          ),
        ),
      ),
    ):YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp]);
      },
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      },
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: ColorPalette.appBarColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: ColorPalette.appColorWhite),
              onPressed: () {
                //PlayerInit(widget.dataUrls);
                //PlayerInit();
                Navigator.of(context).pop();
              }),
          //iconTheme: IconThemeData(color: ColorPalette.),
          title: Container(
            width: 100,
            height: 19.0,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/title.png'))),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          //padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 83,
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
                child: cardItems(),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget player() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.black,
      child: Center(
        child: Stack(
          children: <Widget>[
            betterPlayerController != null
                ? AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: betterPlayerController!,
                key: _betterPlayerKey1,
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
  Widget cardItems(){
    return ListView.builder(

      itemCount: dataEmis==null?0: dataEmis['allitems'].length,
      padding: EdgeInsets.only(top: 10),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            logger.i(' ghost-elite 90',urlData);
            if(widget.dataToLoad=="vod"){
              setState(() {
                urlData=dataEmis['allitems'][index]['feed_url'];
                ulVod=dataEmis['allitems'][index]['relatedItems'];
                title=dataEmis['allitems'][index]['title'];

              });
              getVODVideos();
            }else{
              setState(() {
                urlData=dataEmis['allitems'][index]['feed_url'];
                ulVod=dataEmis['allitems'][index]['relatedItems'];
                title=dataEmis['allitems'][index]['title'];

              });
              getVODVideosYoutube();
            }

            getVODEmissions();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 1,bottom: 3),
            child: Container(
              width: SizeConfi.screenWidth,
              height: 70,
              decoration: const BoxDecoration(
                color: ColorPalette.appColorWhite,
                boxShadow: [
                  BoxShadow(
                      color: ColorPalette.appColorDivider,
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 1)
                  ),

                ],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      GestureDetector(
                        onTap: (){
                          logger.i(' ghost-elite 90',urlData);
                          if(widget.dataToLoad=="vod"){
                            setState(() {
                              urlData=dataEmis['allitems'][index]['feed_url'];
                              ulVod=dataEmis['allitems'][index]['relatedItems'];
                              title=dataEmis['allitems'][index]['title'];

                            });
                            getVODVideos();
                          }else{
                            setState(() {
                              urlData=dataEmis['allitems'][index]['feed_url'];
                              ulVod=dataEmis['allitems'][index]['relatedItems'];
                              title=dataEmis['allitems'][index]['title'];

                            });
                            getVODVideosYoutube();
                          }

                          getVODEmissions();
                        },
                        child: Container(
                          width: 100,
                          height: 70,
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              width: 100,
                              height: 70,
                              imageUrl: dataEmis['allitems'][index]['logo'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    "assets/images/vignete.png",
                                    width: 100,height: 70,fit: BoxFit.cover,
                                  ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    "assets/images/vignete.png",width: 100,height: 70,fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 70,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/carreImage.png'),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/play.png')
                            )
                        ),
                      )
                    ],
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${dataEmis['allitems'][index]['title']}',
                            style: GoogleFonts.poppins(
                                fontSize: 12,color: ColorPalette.appBarColor
                            ),maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 3,),
                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.topLeft,
                          //margin: EdgeInsets.all(5),
                          child: Text(
                            '${dataEmis['allitems'][index]['date']}',
                            style: GoogleFonts.poppins(
                                fontSize: 9.0,color: ColorPalette.appColorGrey),maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget card() {
    return Container(
      width: SizeConfi.screenWidth,
      height: SizeConfi.screenHeight! / 20,
      decoration: const BoxDecoration(
          color: ColorPalette.appBarColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "${title}",
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
}
