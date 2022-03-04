import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:precious_tv/pages/youtubeEmisions.dart';
import 'package:precious_tv/pages/ytoubeplayer.dart';
import 'package:precious_tv/utils/constants.dart';
import 'package:youtube_api/youtube_api.dart';
import 'AllPlayListScreen.dart';
import 'YoutubeChannelScreen.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class YoutubeVideoPlayList extends StatefulWidget {
  //final String apiKey, channelId;
  //ListChannelsbygroup listChannelsbygroup;
  YoutubeVideoPlayList({Key? key, })
      : super(key: key);

  @override
  _YoutubeVideoPlayListState createState() => new _YoutubeVideoPlayListState();
}

class _YoutubeVideoPlayListState extends State<YoutubeVideoPlayList>
    with AutomaticKeepAliveClientMixin<YoutubeVideoPlayList> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  String? title;

  //String query = "JoyNews";
  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UCcdz74VEvkzA71PeLYMyA_g';
  //Apimalikia apimalikia;
  Future<void> callAPI() async {
    print('UI callled');
    //await Jiffy.locale("fr");
    ytResult = await ytApi!.channel(API_CHANEL);
    setState(() {
      print('UI Updated');
      isLoading = false;
      callAPIPlaylist();
    });
  }

  Future<void> callAPIPlaylist() async {
    print('UI callled');
    //await Jiffy.locale("fr");
    ytResultPlaylist = await ytApiPlaylist!.playlist(API_CHANEL);
    setState(() {
      print('UI Updated');
      print(ytResultPlaylist[0].title);
      isLoadingPlaylist = false;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    ytApi = YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist = YoutubeAPI(API_Key, maxResults: 50, type: "playlist");
    callAPI();
    //print('hello');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      primary: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        elevation: 0,
        centerTitle: true,
        //iconTheme: IconThemeData(color: gren,),
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
            children: [
              /*traitWidget(),*/

              ConstrainedBox(
                constraints: BoxConstraints(),
                child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: callAPI,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                child: const Text(
                                  "New videos",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "CeraPro",
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.appBarColor),
                                ),
                              ),
                              //(height: 20,),
                              Container(child: makeItemVideos()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(right: 10),
                                        child: const Text(
                                          "See more...",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: ColorPalette.appBarColor),
                                        )),
                                    onTap: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                YoutubeChannelScreen(
                                              ytResult: ytResultPlaylist[0],
                                              apikey: API_Key, channelId: '',
                                            ),
                                          ),
                                          (Route<dynamic> route) => true);
                                    },
                                  )
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                child: const Text(
                                  "Our Playlists",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "CeraPro",
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.appBarColor),
                                ),
                              ),
                              /*traitWidget(),*/
                              makeItemEmissions(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(right: 10),
                                        child: const Text(
                                          "See more...",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: ColorPalette.appBarColor),
                                        )),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => YoutubeEmisionPage(
                                              ytResultPlaylist: ytResultPlaylist,
                                            )
                                        ),
                                      );
                                      var  logger = Logger();
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              )
            ],
          )),
    );
  }

  Widget makeGridView() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 95.0, 0, 0),
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          crossAxisSpacing: 8,
          mainAxisSpacing: 4,
          children: List.generate(
              ytResultPlaylist == null ? 0 : ytResultPlaylist.length, (index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => AllPlayListScreen(
                            ytResult: ytResultPlaylist[index],
                            //apikey: API_Key,
                          ),
                        ),
                        (Route<dynamic> route) => true);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      child: CachedNetworkImage(
                        imageUrl: ytResultPlaylist[index].thumbnail['high']
                            ['url'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          "assets/images/vignete.png",
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/vignete.png",
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "${ytResultPlaylist[index].title}",
                      style: TextStyle(fontSize: 14, color: ColorPalette.appBarColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            );
          }),
        ));
  }

  Widget makeItemVideos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 210,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => YtoubePlayerPage(
                          videoId: ytResult[position].url,
                          title: ytResult[position].title,
                          ytResult: ytResult, videos: [],
                        )),
                        (Route<dynamic> route) => true);
              },
              child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              imageUrl: ytResult[position].thumbnail['medium']
                              ['url'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/vignete.png",
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                //color: colorPrimary,
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    "assets/images/vignete.png",
                                    fit: BoxFit.cover,
                                    height: 120,
                                    width: 120,
                                    //color: colorPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Flexible(
                          child: Container(
                            child: Container(
                              alignment: Alignment.center,
                              //height: 70,
                              padding: EdgeInsets.all(5),
                              child: Text(
                                ytResult[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontSize: 13,

                                    color: ColorPalette.appBarColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Positioned(
              top: 40,
              left: 70,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => YtoubePlayerPage(
                              videoId: ytResult[position].url,
                              title: ytResult[position].title,
                              ytResult: ytResult, videos: [],
                            )),
                            (Route<dynamic> route) => true);
                  },
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
              ),
            )
          ],
        );
      },
      itemCount: ytResult.length > 8 ? 8 : ytResult.length,
    );
  }

  /*Widget makeShimmerVideos() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, position) {
          return FadeAnimation(
            0.5,
            Shimmer.fromColors(
                baseColor: Colors.grey[400],
                highlightColor: Colors.white,
                child: Container(
                  height: 160.0,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 10,
                        offset: Offset(0, 10.0),
                      ),
                    ],
                  ),
                )),
          );
        },
        itemCount: 6);
  }*/

  Widget makeItemEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      /* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => AllPlayListScreen(
                    ytResult: ytResultPlaylist[position],
                    //apikey: API_Key,
                  ),
                ),
                (Route<dynamic> route) => true);
          },
          child: Container(
              margin: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      //alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: ytResultPlaylist[position]
                                  .thumbnail["medium"]["url"],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 110,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/vignete.png",fit: BoxFit.cover
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/vignete.png",fit: BoxFit.cover
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                ytResultPlaylist[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontSize: 13,
                                    color: ColorPalette.appBarColor),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.playlist_play,
                                  size: 25,
                                  color: ColorPalette.appBarColor,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
      itemCount: ytResultPlaylist == null ? 0 : ytResultPlaylist.length,
    );
  }

  /*Widget makeShimmerEmissions() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, position) {
          return FadeAnimation(
            0.5,
            Shimmer.fromColors(
                baseColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  height: 160.0,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 10,
                        offset: Offset(0, 10.0),
                      ),
                    ],
                  ),
                )),
          );
        },
        itemCount: 6);
  }*/

  Widget appBar() {
    return AppBar(
      title: Image.asset("assets/images/1.png"),
      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.blue,
    );
  }

  traitWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            height: 3,
            width: 400,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
