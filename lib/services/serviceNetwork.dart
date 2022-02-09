import 'dart:async';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Services{
  var logger = Logger();
  var dataUrl;
  var uri;
  var data ;

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
        dataUrl = jsonDecode(response.body);
        //fetchApi();

        logger.i('message 200',dataUrl);
        //fetchApi();
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
        logger.i(' ======== Pubg New State ======== ');
        //fetchDirectUrl();
        //widget.logger.i("guide url",dataUrl['results'][0]['gender']);
        // model= AlauneModel.fromJson(jsonDecode(response.body));
      }
    }catch(error, stacktrace){

    }
  }
  Future<List> getData() async {
    final response = await http.get(Uri.parse("https://tveapi.acan.group/myapiv2/appdetails/albayanetv/json"));
    data = json.decode(response.body);
    //this.videos.addAll(data["items"]);
    //logger.i(data["items"]==null?0:data["items"].length);

    //logger.i(data["items"][1]["snippet"]["title"]);
   logger.i('fdghj',data["ACAN_API"]);


    return data["ACAN_API"];
  }
}