import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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


  Future<void> getall() async {

    try {
      var response = await http
          .get(Uri.parse("https://tveapi.acan.group/myapiv2/appdetails/albayanetv/json"))
          .timeout(const Duration(seconds: 10), onTimeout: () {
        logger.i('message 200');
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
        //fetchDirectUrl();
        //widget.logger.i("guide url",dataUrl['results'][0]['gender']);
        // model= AlauneModel.fromJson(jsonDecode(response.body));
      }
    }catch(error, stacktrace){

    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getall();

    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }
  @override
  Widget build(BuildContext context) {
    _services.logger.i('message',dataUrl['ACAN_API'][0]['app_data_url']);
    return Scaffold();
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
