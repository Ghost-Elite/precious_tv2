import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../configs/size_config.dart';
import '../utils/constants.dart';
import 'AllPlayListScreen.dart';
import 'package:logger/logger.dart';
class YoutubePages extends StatefulWidget {
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];

  YoutubePages({Key? key,required this.ytResult,required this.ytResultPlaylist,this.ytApi,this.ytApiPlaylist}) : super(key: key);

  @override
  _YoutubePagesState createState() => _YoutubePagesState();
}

class _YoutubePagesState extends State<YoutubePages>{
  GlobalKey _scaffoldKey1 = GlobalKey();
  late YoutubePlayerController _controller;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UCIby2pzNJkvQsbc38shuGTw';
  var logger = Logger();
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String? uri,tite,lien,test;
  int playBackTime = 0;
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
  /*  WidgetsBinding.instance
        !.addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());*/
    lien =widget.ytResult[0].url;
    tite=widget.ytResult[0].title;
    //test=widget.ytResult[0].duration.toString();
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
    logger.i("initState");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      logger.i("WidgetsBinding");
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      logger.i("SchedulerBinding");
    });
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
    _controller.dispose();
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }
  @override
  void didUpdateWidget(covariant YoutubePages oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
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
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        key: _refreshIndicatorKey,
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      width: SizeConfi.screenWidth,
                      height: 180,
                      color: Colors.black,
                      child: _controller !=null? player:Container(),
                    ),
                    Container(
                      width: SizeConfi.screenWidth,
                      height: SizeConfi.screenHeight! / 20,
                      decoration: const BoxDecoration(
                          color: ColorPalette.appBarColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16))
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 9,right: 8),
                              alignment: Alignment.center,
                              child: Text('${tite} ',style: GoogleFonts.rowdies(fontSize: 13,fontWeight: FontWeight.bold,color: ColorPalette.appYellowColor),maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 5,left: 5),
                          child: Text(
                            ' Latest Videos ',
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
                            'Playlists',
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
              )

            ],
          ),
        ),
      ),
    );
  }
  Widget listVideos(){
    return ListView.builder(

      itemCount: widget.ytResult.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            setState(() {
              uri = widget.ytResult[index].url;
              //lien = widget.ytResult[index].url;
            });
            _controller.load(widget.ytResult[index].url.split("=")[1]);
            tite = widget.ytResult[index].title;
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 2,bottom: 2),
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
    );
  }
  Widget makeMostPopular() {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 10.2),
      //margin: EdgeInsets.symmetric(vertical: 8.0),
        height: 200,
        child: ListView.builder(
            itemCount: widget.ytResultPlaylist.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => AllPlayListScreen(
                          ytResult:widget.ytResultPlaylist[i],
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
            }));
  }
}
