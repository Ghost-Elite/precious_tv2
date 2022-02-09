import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:precious_tv/network/youtube_api.dart';
import 'package:precious_tv/network/yt_video.dart';

import 'package:precious_tv/pages/home.dart';
import 'package:precious_tv/services/serviceNetwork.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  Services _services =new Services();
  var dataUrl;
  var uri;
  var logger = Logger();
  var data;
  var datas;
  var playBackUrl;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = false;
  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UCIby2pzNJkvQsbc38shuGTw';

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

  bool isLoadingPlaylist = true;

  Future<void>cheked()async {
    getall();
    logger.i('message 200');
  }

  Future<void> getall() async {

    try {

      var response = await http
          .get(Uri.parse("https://tveapi.acan.group/myapiv2/appdetails/albayanetv/json"))
          .timeout(const Duration(seconds: 10), onTimeout: () {

        throw TimeoutException("connection time out try agian");
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //logger.w(listChannelsbygroup);

        setState(() {
          dataUrl = jsonDecode(response.body);
        });
        fetchApi();


        //logger.i("guide url",dataUrl['results'][0]['gender']);
        // model= AlauneModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      //print("response time out");
      //navigationPage();\

    }
  }
  Future<void> fetchApi() async {
    try{
      var url = Uri.parse(dataUrl['ACAN_API'][0]['app_data_url']);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //logger.w(listChannelsbygroup);

        uri = jsonDecode(response.body);
        setState(() {
          uri;
        });
        navigationPage();
      }
    }catch(error, stacktrace){

    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getall();
    callAPI();
    //logger.i('message ghost',ytResult[0].title);
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //var assetsImage = new AssetImage('assets/images/logo.png');
    var assetsBg = const AssetImage(
      'assets/images/splash.png',);
    //var assetsBgLogo = new AssetImage('assets/images/bglogo.png');
    //var image = new Image(image: assetsImage, height: 100);
    //var bgLogo = new Image(image: assetsBgLogo, height: 100);
    var bg = Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/SplashScreen.png"),
                fit: BoxFit.cover
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: const Text('Website'),
          ),
        )
      ],
    ); //<- Creates a widget that displays an image.

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          bg,
          Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Platform.isIOS?200:300,),

                ],
              )
          ),
        ],
        ), //<- place where the image appears
      ),
    );
  }
  Future<void> navigationPage()async {
    if(dataUrl !=null && dataUrl!=0){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(
          lien: uri, key: null,
        ),
        ),
            (Route<dynamic> route) => false,
      );
    }else{
     _services.logger.i(' ghost-elite 2022 ');
    }

  }
}
