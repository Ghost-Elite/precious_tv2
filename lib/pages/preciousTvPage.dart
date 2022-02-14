import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:better_player/better_player.dart';
import 'package:http/http.dart' as http;
import 'package:precious_tv/configs/size_config.dart';
import 'package:precious_tv/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:google_fonts/google_fonts.dart';

class PreciousTvPage extends StatefulWidget {
  var dataUrl;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  PreciousTvPage({Key? key,this.dataUrl,this.ytApiPlaylist,required this.ytResultPlaylist,required this.ytResult,this.ytApi}) : super(key: key);

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
      backgroundColor: ColorPalette.appColorWhite,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              width: SizeConfi.screenWidth,
              height: 180,
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
                  padding: EdgeInsets.only(right: 5,left: 5),
                  child: Text(
                    'Latest Videos',
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: ColorPalette.appBarColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.playlist_add,
                    size: 20,
                    color: ColorPalette.appBarColor,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            Container(
              width: SizeConfi.screenWidth,
                height: 200,
                child: listVideos()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 5,left: 5),
                  child: Text(
                    'TV Programs',
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: ColorPalette.appBarColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.playlist_add,
                    size: 20,
                    color: ColorPalette.appBarColor,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            makeMostPopular()
          ],
        ),
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
  Widget listVideos(){
    return ListView.builder(

      itemCount: widget.ytResult.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(top: 1,bottom: 1),
          child: Container(
            width: SizeConfi.screenWidth,
            height: 70,
            color: ColorPalette.appColorBg,
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: 100,
                      height: 70,
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: 100,
                          height: 70,
                          imageUrl: widget.ytResult[index].thumbnail["medium"]["url"],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Image.asset(
                                "assets/images/vignete.png",
                                width: 100,height: 70,
                              ),
                          errorWidget: (context, url, error) =>
                              Image.asset(
                                "assets/images/vignete.png",width: 100,height: 70,
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
                          '${widget.ytResult[index].title}',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,color: ColorPalette.appBarColor
                          ),maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 3,),
                      /*Container(
                        margin: EdgeInsets.all(5),
                        child: Text(
                          '${widget.ytResult[index].description}',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.normal,
                            fontSize: 13.0,),maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )*/
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  Widget makeMostPopular() {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 10.2),
      //margin: EdgeInsets.symmetric(vertical: 8.0),
        height: 100,
        child: ListView.builder(
            itemCount: widget.ytResultPlaylist.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              return SizedBox(
                height: 100,
                width: 140,
                //margin: const EdgeInsets.only(left: 6,  top: 10, bottom: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 2,left: 2),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 140,
                            child: GestureDetector(
                              child: Container(
                                //margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          widget.ytResultPlaylist[i].thumbnail['high']['url'],
                                        ),
                                        fit: BoxFit.cover)),
                                width: MediaQuery.of(context).size.width,
                                height: 130,
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 140,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/rectImage.png'),
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                          Text('${widget.ytResultPlaylist[i].title}',style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 12,color: ColorPalette.appColorWhite),maxLines: 2,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

}

