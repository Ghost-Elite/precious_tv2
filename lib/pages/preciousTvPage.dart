import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:better_player/better_player.dart';
import 'package:http/http.dart' as http;
import 'package:precious_tv/configs/size_config.dart';
import 'package:precious_tv/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PreciousTvPage extends StatefulWidget {
  var dataUrl;
  PreciousTvPage({Key? key,this.dataUrl}) : super(key: key);

  @override
  _PreciousTvPageState createState() => _PreciousTvPageState();
}

class _PreciousTvPageState extends State<PreciousTvPage> {
  var logger =Logger();
  GlobalKey _betterPlayerKey = GlobalKey();
  BetterPlayerController? betterPlayerController;
  late final bool  videoLoading;
  var data;
  var datas;
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
    final response = await http.get(Uri.parse(widget.dataUrl));
    data = json.decode(response.body);
    getDirect(data['allitems'][0]['feed_url']);
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
    betterPlayerController?.setBetterPlayerGlobalKey(_betterPlayerKey);
    betterPlayerController!.setupDataSource(dataSource)
        .then((response) {
      //s.logger.i(' Ghost-Elite ',dataSource);
      videoLoading = false;
    })
        .catchError((error) async {
      // Source did not load, url might be invalid
      inspect(error);
    });
  }
  Future<void> test() async {
    // Simple check to see if we have Internet
    // ignore: avoid_print
    logger.i('''The statement 'this machine is connected to the Internet' is: ''');
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    logger.i(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    logger.i(
        'Current status: ${await InternetConnectionChecker().connectionStatus}');
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
          // ignore: avoid_print
            logger.i('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            logger.i('You are disconnected from the internet.');
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(
        const Duration(seconds: 10),
        getData
    );
    await listener.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    //logger.i('message',datas['direct_url']);
    test();
    betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    betterPlayerController?.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appColorDivider,
      body: Column(
        children: [
          Container(
            width: SizeConfi.screenWidth,
            height: 200,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              key: _betterPlayerKey,
              child: BetterPlayer(controller: betterPlayerController!),
            ),
          ),
          Container(
            width: SizeConfi.screenWidth,
            height: SizeConfi.screenHeight! / 20,
            decoration: const BoxDecoration(
              color: ColorPalette.appBarColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16))
            ),
            child: Container(
              padding: EdgeInsets.only(left: 45),
              alignment: Alignment.center,
              child: Row(
                children: [
                  IconButton(onPressed: (){

                  },
                      icon: const Icon(
                        Icons.tv,size: 26,color: ColorPalette.appYellowColor,
                      )
                  ),
                  Text('You’re watching Precious TV ',style: GoogleFonts.rowdies(fontSize: 13,fontWeight: FontWeight.bold,color: ColorPalette.appYellowColor),),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  'Latest Videos',
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: ColorPalette.appBarColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.playlist_add,
                  size: 30,
                  color: ColorPalette.appBarColor,
                ),
                onPressed: () {},
              )
            ],
          ),
          Expanded(child: listItem),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  'TV Programs',
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: ColorPalette.appBarColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.playlist_add,
                  size: 30,
                  color: ColorPalette.appBarColor,
                ),
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
  var listItem = ListView.builder(
    itemCount: 3,
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(top: 1,bottom: 1),
        child: Container(
          width: SizeConfi.screenWidth,
          height: 70,
          color: ColorPalette.appColorBg,
          child: Center(
            child: Text('$index Ghost-Elite '),
          ),
        ),
      );
    },
  );
}

