import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:better_player/better_player.dart';
import 'package:http/http.dart' as http;
import 'package:precious_tv/pages/ytoubeplayer.dart';
import 'package:precious_tv/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../configs/size_config.dart';
import 'AllPlayListScreen.dart';
import 'drawerReplay.dart';
import 'lecteurDesEmission.dart';
import 'listVideoProg.dart';

class PreciousTvPage extends StatefulWidget {
  var dataUrl;
  var dataToLoad;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  PreciousTvPage({Key? key,this.dataUrl,this.ytApiPlaylist,required this.ytResultPlaylist,required this.ytResult,this.ytApi,this.dataToLoad}) : super(key: key);

  @override
  _PreciousTvPageState createState() => _PreciousTvPageState();
}

class _PreciousTvPageState extends State<PreciousTvPage> {
  @override

  var logger =Logger();
  GlobalKey _betterPlayerKey = GlobalKey();
  GlobalKey _scaffoldKey = GlobalKey();
  BetterPlayerController? betterPlayerController;
  late final bool  videoLoading;
  AnimationController? animationController;
  var data;
  var datas;
  var dataVOD;
  var dataEmis;
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
      iconsColor: ColorPalette.appColorWhite,
      //controlBarColor: colorPrimary,
      controlBarColor: Colors.transparent,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
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

  Future<void> getData() async {
    final response = await http.get(Uri.parse(widget.dataUrl));
    data = json.decode(response.body);
    getDirect(data['allitems'][0]['feed_url']);

    //logger.i('Ghost-Elite',data['allitems'][0]['alaune_feed']);
    getVODPrograms(data['allitems'][0]['vod_feed']);
    getVODEmissions(data['allitems'][0]['alaune_feed']);

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
  Future<void> getVODPrograms(String url) async {
    final response = await http.get(Uri.parse(url));
    setState(() {
      dataVOD = json.decode(response.body);
    });
    getDirect(dataVOD['allitems'][0]['feed_url']);

    //logger.i(' Ghost-Elite 2022 ',dataVOD['allitems']);
    return dataVOD;
  }
  Future<void> getVODEmissions(String url) async {
    final response = await http.get(Uri.parse(url));
    dataEmis = json.decode(response.body);
    //getDirect(dataVOD['allitems'][0]['feed_url']);

    logger.i(' Ghost-Elite 2022 ',url);
    return dataEmis;
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
  initPlayer(String directUrl){
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      directUrl,
      liveStream: true,
      asmsTrackNames: ["3G 360p", "SD 480p", "HD 1080p"],
      /*notificationConfiguration: BetterPlayerNotificationConfiguration(
            showNotification: true,
            title: tvTitle,
            author: "DMedia",
            imageUrl:tvIcon,
          ),*/
    );
    if (betterPlayerController != null) {
      betterPlayerController!.pause();
      betterPlayerController!.setupDataSource(betterPlayerDataSource);
    } else {
      betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
          betterPlayerDataSource: betterPlayerDataSource);
    }
    betterPlayerController!.setBetterPlayerGlobalKey(_betterPlayerKey);
  }

  @override
  void initState() {
    // TODO: implement initState
    betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    getData();
    super.initState();


    //logger.i('message',datas['direct_url']);
    //test();

    logger.i("initState");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      logger.i("WidgetsBinding");
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      logger.i("SchedulerBinding");
    });


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
    betterPlayerController!.dispose();
    betterPlayerController ==null;
  }
  @override
  void didUpdateWidget(PreciousTvPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
  }
  @override
  Widget build(BuildContext context) {
    //logger.i(' ghost-elite ',dataVOD['allitems'].length);
    //logger.i(' Ghost-Elite 2022 ',data['allitems'][0]['alaune_feed']);
    //logger.i(' Ghost-Elite 2022 ',dataEmis['allitems']);
    return Scaffold(
      backgroundColor: ColorPalette.appColorWhite,
      body: SafeArea(
        child:  CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    width: SizeConfi.screenWidth,
                    height: 180,
                    color: Colors.black,
                    child: betterPlayerController !=null?
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      key: _betterPlayerKey,
                      child: BetterPlayer(controller: betterPlayerController!),
                    ):Container(),
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
                        onPressed: () {

                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => YtoubePlayerPage(
                                  videoId: widget.ytResult[0].url, videos: [], ytResult: widget.ytResult,
                                  title: widget.ytResult[0].title,
                                  dataUrls: widget.dataUrl,
                                  url: dataEmis['allitems'][0]['feed_url'],

                                  //apikey: API_Key,
                                ),
                              )
                          );
                        },
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
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => DrawerReplay(
                                  ytResultPlaylist: widget.ytResultPlaylist,
                                  dataToLoad: widget.dataToLoad,
                                  urls: dataVOD,
                                  //apikey: API_Key,
                                ),
                              ),
                                  (Route<dynamic> route) => true);
                        },
                      )
                    ],
                  ),
                  makeMostPopular()

                ],
              ),
            )

          ],
        )

        /*Column(
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
        )*/ ,
      ),
    );
  }
  Widget listVideos(){
    return widget.dataToLoad == "youtube"? ListView.builder(

      itemCount: widget.ytResult.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => YtoubePlayerPage(
                      videoId: widget.ytResult[index].url,
                      title: widget.ytResult[index].title,

                      ytResult: widget.ytResult, videos: [],
                    )),
                    (Route<dynamic> route) => true);
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
                                  width: 100,height: 70,fit: BoxFit.cover,
                                ),
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                  "assets/images/vignete.png",width: 100,height: 70,fit: BoxFit.cover,
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
          ),
        );
      },
    ):
    ListView.builder(

      itemCount: dataEmis==null?0: dataEmis['allitems'].length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            //logger.i('ghost-elite 2022 killer',dataEmis['allitems'][index]['relatedItems']);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => LecteurDesEmissions(
                    videoUrl: dataEmis['allitems'][index]['feed_url'],
                    videoItems: dataEmis['allitems'][index]['relatedItems'],
                    title: dataEmis['allitems'][index]['title'],
                    dataToLoad: widget.dataToLoad,
                    )),
                    (Route<dynamic> route) => true);
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
                      Container(
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
  Widget makeMostPopular() {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 10.2),
      //margin: EdgeInsets.symmetric(vertical: 8.0),
        height: 200,
        child: widget.dataToLoad == "youtube"? ListView.builder(
            itemCount: widget.ytResultPlaylist.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              return GestureDetector(
                onTap: (){
                  logger.i('message',widget.ytResultPlaylist[1].thumbnail);
                  if(widget.ytResultPlaylist !=null || widget.ytResultPlaylist==0){
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => AllPlayListScreen(
                            ytResult:widget.ytResultPlaylist[i],
                            //apikey: API_Key,
                          ),
                        ),
                            (Route<dynamic> route) => true);
                  }else{
                    logger.i('test video');
                  }

                },
                child: SizedBox(
                  height: 160,
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
                              height: 160,
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
                              height: 160,
                              width: 140,
                              decoration: const BoxDecoration(
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
                ),
              );
            }):ListView.builder(
            itemCount: dataVOD==null?0: dataVOD['allitems'].length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              return GestureDetector(
                onTap: (){
                  //logger.i('message',widget.ytResultPlaylist[1].thumbnail);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => ListVideoPrograms(
                          urls:  dataVOD['allitems'][i]['feed_url'],
                          //apikey: API_Key,
                        ),
                      ),
                          (Route<dynamic> route) => true);

                },
                child: SizedBox(
                  height: 160,
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
                              height: 160,
                              width: 140,
                              child: GestureDetector(
                                child: Container(
                                  //margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            dataVOD['allitems'][i]['logo'],
                                          ),
                                          fit: BoxFit.cover)),
                                  width: MediaQuery.of(context).size.width,
                                  height: 130,
                                ),
                              ),
                            ),
                            Container(
                              height: 160,
                              width: 140,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/rectImage.png'),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            Text('${dataVOD['allitems'][i]['title']}',style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 12,color: ColorPalette.appColorWhite),maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
    );
  }

}

