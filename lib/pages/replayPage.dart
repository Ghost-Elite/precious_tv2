import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import 'AllPlayListScreen.dart';
import 'listVideoProg.dart';
class ReplayPage extends StatefulWidget {

  var dataToLoad;
  var dataUrl;
  ReplayPage({Key? key,this.dataToLoad,this.dataUrl}) : super(key: key);

  @override
  _ReplayPageState createState() => _ReplayPageState();
}

class _ReplayPageState extends State<ReplayPage> {
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  var logger =Logger();
  var data;
  var datas,dataVOD;
  Future<void> getDatas() async {
    final response = await http.get(Uri.parse(widget.dataUrl));
    datas = json.decode(response.body);
    //getDirect(data['allitems'][0]['feed_url']);

    //logger.i('Ghost-Elite',data['allitems'][0]['alaune_feed']);
    getVODPrograms(datas['allitems'][0]['vod_feed']);

    return datas;
  }
  Future<void> getVODPrograms(String url) async {
    final response = await http.get(Uri.parse(url));
    setState(() {
      dataVOD = json.decode(response.body);
    });
    //getDirect(dataVOD['allitems'][0]['feed_url']);

    //logger.i(' Ghost-Elite 2022 ',dataVOD['allitems']);
    return dataVOD;
  }
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  String? lien;
  bool isLoadingPlaylist = true;
  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UCcdz74VEvkzA71PeLYMyA_g';
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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());
    ytApi = YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
        YoutubeAPI(API_Key, maxResults: 50, type: "playlist");
    callAPI();
    getDatas();
  }

  Future<void> _asyncFunctionAfterBuild() async {
    setState(() {
      print("check if i'm printed several times!");
    });
  }
  @override
  Widget build(BuildContext context) {
    _asyncFunctionAfterBuild();
    return Scaffold(
      key: _refreshIndicatorKey,
      body: makeItemEmissions(),
    );
  }
  Widget makeItemEmissions() {
    final orientation = MediaQuery.of(context).orientation;
    return widget.dataToLoad=='youtube'? GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        logger.i('ghost',ytResultPlaylist[position].thumbnail['high']['url']);
        return GestureDetector(
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => AllPlayListScreen(
                    ytResult: ytResultPlaylist[position],
                    //apikey: API_Key,
                  ),
                ),
                    (Route<dynamic> route) => true);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius:  BorderRadius.circular(10),
                        child: Container(
                          child: CachedNetworkImage(
                            imageUrl: ytResultPlaylist[position].thumbnail['high']['url'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              "assets/images/vignete.png",
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/vignete.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration:  BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/carreImage.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      Text(
                        ytResultPlaylist[position].title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: ColorPalette.appColorWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          ),
        );
      },
      itemCount: ytResultPlaylist.length,
    ):GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        //logger.i('ghost',widget.ytResultPlaylist[position].thumbnail['high']['url']);
        return GestureDetector(
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => ListVideoPrograms(
                      urls: dataVOD['allitems'][position]['feed_url'],
                      dataToLoad: widget.dataToLoad,
                    )),
                    (Route<dynamic> route) => true);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius:  BorderRadius.circular(10),
                        child: Container(
                          child: CachedNetworkImage(
                            imageUrl: dataVOD['allitems'][position]['logo'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              "assets/images/vignete.png",
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/vignete.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        decoration:  BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/images/carreImage.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      Text(
                        dataVOD['allitems'][position]['title'],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: ColorPalette.appColorWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          ),
        );
      },
      itemCount:dataVOD==null?0: dataVOD['allitems'].length,
    );
  }
}

