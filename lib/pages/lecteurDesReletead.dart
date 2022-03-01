import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import '../configs/size_config.dart';
import '../utils/constants.dart';
import 'package:better_player/better_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
class VideoRelated extends StatefulWidget {
  var datas,related,title;
  VideoRelated({Key? key,this.datas,this.related,this.title}) : super(key: key);

  @override
  _VideoRelatedState createState() => _VideoRelatedState();
}

class _VideoRelatedState extends State<VideoRelated> {
  var item,data,urldata,titles,related,relat;
  var logger=Logger();
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
    final response = await http.get(Uri.parse(urldata));
    setState(() {
      data = json.decode(response.body);
    });
    logger.i(' Ghost-Elite 2022 ',urldata);
    getInitPlayer(data['video_url']);
     /* if (widget.onPlay == "vod") {
        getInitPlayer(data['video_url']);
      } else {
        iniPlayerYoutube(data['video_url']);
      }*/
    return data;
  }
  Future<void> getVODIteams() async {
    final response = await http.get(Uri.parse( relat));
    setState(() {
      item = json.decode(response.body);
    });
    logger.i(' Ghost-Elite 202 ', item['allitems']);

    return item;
  }
  /*Future<void> FetchRelated() async {

    final response = await http.get(widget.related);
    if (response.statusCode == 200) {

      //logger.w(listChannelsbygroup);
      setState(() {
        data = jsonDecode(response.body);
      });

      logger.i("ghost-elite",data);
      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }*/
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    urldata=widget.datas;
    titles=widget.title;
    relat=widget.related;
    getVODVideos();
    getVODIteams();
  }
  @override
  Widget build(BuildContext context) {
    //logger.i('message',data['video_url']);
    return Scaffold(
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
        child: Stack(
          children: <Widget>[
            Container(
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
                    child: gridviewItem(),
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
                "${titles}",
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
  Widget gridviewItem() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      //padding: const EdgeInsets.all(20),
      crossAxisSpacing: 8,
      mainAxisSpacing: 4,
      padding: EdgeInsets.only(top: 10),
      children:
      List.generate(item == null ? 0 : item['allitems'].length, (index) {
        return Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  urldata=item['allitems'][index]['feed_url'];
                  related=item['allitems'][index]['relatedItems'];
                  titles=item['allitems'][index]['title'];
                });
                getVODVideos();
                getVODIteams();
              },
              child: Stack(
                children: [
                  GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 180,
                        height: 110,
                        child: CachedNetworkImage(
                          imageUrl: item['allitems'][index]['logo'],
                          width: 180,
                          height: 110,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            "assets/images/vignete.png",
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/vignete.png",
                            width: 180,
                            fit: BoxFit.cover,
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
                                image: AssetImage("assets/images/jouer.png"))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "${item['allitems'][index]['title']}",
                  style: const TextStyle(
                      fontSize: 13, color: ColorPalette.appBarColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
