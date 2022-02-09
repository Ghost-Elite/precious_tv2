import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:precious_tv/network/yt_video.dart';
import 'package:precious_tv/services/serviceNetwork.dart';
import 'package:better_player/better_player.dart';
import 'package:precious_tv/utils/constants.dart';

import 'drawerPage.dart';
class HomePage extends StatefulWidget {
  var lien;

  HomePage({Key? key,this.lien}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  var scaffold = GlobalKey<ScaffoldState>();
  Services s = new Services();
  BetterPlayerController? betterPlayerController;

  GlobalKey _betterPlayerKey = GlobalKey();
  late final bool  videoLoading;
  var data;
  var datas;
  TabController? tabController;

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
    controlsConfiguration: BetterPlayerControlsConfiguration(
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
    final response = await http.get(Uri.parse(widget.lien['allitems'][0]['feed_url']));
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
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: "Elephant dream",
        author: "Some author",
        imageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/African_Bush_Elephant.jpg/1200px-African_Bush_Elephant.jpg",
      ),
    );
    //betterPlayerController.setupDataSource(dataSource);
    betterPlayerController?.setBetterPlayerGlobalKey(_betterPlayerKey);
    betterPlayerController!.setupDataSource(dataSource)
        .then((response) {
     s.logger.i(' Ghost-Elite ',dataSource);
      videoLoading = false;
    })
        .catchError((error) async {
      // Source did not load, url might be invalid
      inspect(error);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
    tabController = TabController(length: 3, vsync: this);

    var tabBarItem = TabBar(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50), // Creates border
        color: ColorPalette.appYellowColor),
      tabs: const [
        Tab(
          icon: Icon(Icons.list),
        ),
        Tab(
          icon: Icon(Icons.grid_on,color: Colors.pink,),
        ),
        Tab(
          icon: Icon(Icons.grid_on,color: Colors.pink,),
        ),
      ],
      controller: tabController,
      indicatorColor: ColorPalette.appColorBg,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffold,
        drawer: DrawerPage(),
        appBar: AppBar(
          backgroundColor: ColorPalette.appBarColor,
          centerTitle: true,
          title: Container(
            width: 100,
            height: 19.0,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/title.png')
                )
            ),
          ),
          leading: GestureDetector(
            onTap: (){
              scaffold.currentState?.openDrawer();
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/menu.png')
                  )
              ),
            ),
          ),
          bottom: tabBarItem,
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            listItem,
            listItem,
            listItem

          ],
        ),
      ),
    );


      /*Scaffold(
      drawer: DrawerPage(),
      key: scaffold,
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        centerTitle: true,
        title: Container(
          width: 100,
          height: 19.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/title.png')
          )
        ),
        ),
        leading: GestureDetector(
          onTap: (){
            scaffold.currentState?.openDrawer();
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/menu.png')
              )
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 200,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            key: _betterPlayerKey,
            child: BetterPlayer(controller: betterPlayerController!),
          ),
        ),
      ),
    )*/;
  }
  var listItem = ListView.builder(
    itemCount: 20,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Card(
          elevation: 5.0,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text("ListItem $index"),
          ),
        ),

      );
    },
  );
}

