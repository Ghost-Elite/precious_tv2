
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:precious_tv/pages/ytoubeplayer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'AllPlayListScreen.dart';





class YoutubeChannelScreen extends StatefulWidget {
  String? apiKey,channelId;

  YT_APIPlaylist? ytResult;
  YoutubeChannelScreen({Key? key,this.apiKey, required this.channelId,required this.ytResult, required String apikey}) : super(key: key);

  @override
  _YoutubeChannelScreenState createState() => _YoutubeChannelScreenState();
}

class _YoutubeChannelScreenState extends State<YoutubeChannelScreen> with AutomaticKeepAliveClientMixin<YoutubeChannelScreen>{
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  String? lien;
  bool isLoadingPlaylist = true;
  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UCIby2pzNJkvQsbc38shuGTw';
  Color bg = const Color(0xFFEBEBEB);
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
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());
    ytApi = YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
    YoutubeAPI(API_Key, maxResults: 50, type: "playlist");
    callAPI();
    //print('hello');
  }
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Scaffold(

        appBar: AppBar(
          backgroundColor: ColorPalette.appBarColor,
          elevation: 0,
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

        ),
      body: Container(
       color: bg,
          child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: callAPI,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        makeItemVideos(),
                      ],
                    ),
                  ),

                ],
              )
          )
      ),
    );

  }

  Widget makeItemVideos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return GestureDetector(
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
          child: Stack(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      Stack(
                        children: [

                          CachedNetworkImage(
                            height: 110,
                            width: MediaQuery.of(context).size.width,
                            imageUrl:  ytResult[position].thumbnail['medium']
                            ['url'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              "assets/images/vignete.png",
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                              //color: colorPrimary,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/vignete.png",
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                              //color: colorPrimary,
                            ),
                          ),

                        ],
                      ),
                      Container(
                        child: Flexible(
                          child: Container(
                            child: Container(
                              alignment: Alignment.center,
                              //height: 70,
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                ytResult[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.appBarColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned.fill(
                bottom: 60,
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/play.png"))),
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: ytResult.length>8?8:ytResult.length,
    );
  }



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
                    apikey:API_Key,

                  )),
                  (Route<dynamic> route) => true,);
          },
          child: Container(
              margin: const EdgeInsets.all(10),
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: ytResultPlaylist[position].thumbnail["medium"]["url"],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 110,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    "assets/images/vignete.png",fit: BoxFit.cover
                                  ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    "assets/images/vignete.png",fit: BoxFit.cover,
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
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.appBarColor),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
      itemCount: 5,
    );
  }




  traitWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            height: 3,
            width: 400,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
  Widget makeVideos(){
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      crossAxisSpacing: 8,
      mainAxisSpacing: 5,
      children: List.generate(ytResult.length, (index) {
        return Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage('${ytResult[index]
                                .thumbnail["medium"]["url"]}'),
                            fit: BoxFit.cover
                        ),

                      ),
                      /*child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "${model.allitems[index].logo}",width: 250,height: 160,),
              ),*/
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/play_button.png")
                              )
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                /*onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => YoutubeVideoPlayer(
                            url: ytResult[index].url,
                            title: ytResult[index].title,
                            img: ytResult[index].thumbnail['medium']['url'],
                            related: "",
                            ytResult: ytResult,
                          )
                          )
                          ),*/
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              YtoubePlayerPage(
                                videoId: ytResult[index].url,
                                title: ytResult[index].title,

                                related: "",
                                ytResult: ytResult, videos: [],
                              )),
                          (Route<dynamic> route) => true);
                }
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.fromLTRB(17, 0, 10, 0),
                child: Text("${ytResult[index].title}",
                  style: const TextStyle(
                      fontSize: 13,
                      color: ColorPalette.appColorBg
                  ),
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
  Widget makeGridView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 95.0, 0, 0),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2 ,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        children: List.generate(ytResultPlaylist==null?0:ytResultPlaylist.length,(index){
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            AllPlayListScreen(
                              ytResult: ytResultPlaylist[index],
                              apikey:API_Key,


                            ),

                      ),
                          (Route<dynamic> route) => true);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    child: CachedNetworkImage(
                      imageUrl: ytResultPlaylist[index].thumbnail['high']['url'],width: 100,height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/vignete.png",width: 150,
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text("${ytResultPlaylist[index].title}",
                    style: const TextStyle(
                        fontSize: 14,
                        color: ColorPalette.appColorBg
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        }
        ),
      )
    );
  }

}


