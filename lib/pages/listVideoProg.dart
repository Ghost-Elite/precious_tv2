import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
class ListVideoPrograms extends StatefulWidget {
  var urls;
  ListVideoPrograms({Key? key,this.urls}) : super(key: key);

  @override
  _ListVideoProgramsState createState() => _ListVideoProgramsState();
}

class _ListVideoProgramsState extends State<ListVideoPrograms> {
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  var logger =Logger();
  var dataVOD;
  Future<void> getVODPrograms() async {
    final response = await http.get(Uri.parse(widget.urls));
    setState(() {
      dataVOD = json.decode(response.body);
    });


    //logger.i(' Ghost-Elite 2022 ',dataVOD['allitems']);
    return dataVOD;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    getVODPrograms();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('ghost-elite 22', dataVOD);
    return Scaffold(
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
      ),
      body: makeItemEmissions(),
    );
  }
  Widget makeItemEmissions() {
    final orientation = MediaQuery.of(context).orientation;
    return Container(

        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2 ,
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          crossAxisSpacing: 8,
          mainAxisSpacing: 4,
          children: List.generate(dataVOD==null?0: dataVOD['allitems'].length,(index){
            //print(data["items"]["snippet"][index]["thumbnails"]["maxres"]["url"]);
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    /*Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                youtubeplayerListPage(
                                  url: data["items"][index]["snippet"]["resourceId"]["videoId"],
                                  titre: data["items"][index]["snippet"]["title"],
                                  image: data["items"][index]["snippet"]["thumbnails"]["medium"]["url"],
                                  desc: data["items"][index]["snippet"]["title"],
                                  //title: data["items"][index]["snippet"]["title"],

                                  data: data,
                                )),
                            (Route<dynamic> route) => true);*/
                  },
                  child: Stack(
                    children: [

                      GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(

                            child: CachedNetworkImage(
                              imageUrl: dataVOD['allitems'][index]['logo'],width: 100,height: 100,
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
                            height: 110,
                          ),
                        ),

                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/jouer.png"))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("${dataVOD['allitems'][index]['title']}",
                      style: GoogleFonts.poppins(fontSize: 12,color: ColorPalette.appBarColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            );
          }),
        )
      /*widget.apimalikia.aCANAPI[0].appDataToload == "youtube"?GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2 ,
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        children: List.generate(data["items"]==null?0:data["items"].length,(index){
         print(data["items"]["snippet"][index]["thumbnails"]["maxres"]["url"]);
          return Column(
            children: [
              GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    child: CachedNetworkImage(
                      imageUrl: data["items"][index]["snippet"]["thumbnails"]["medium"]["url"],width: 100,height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.contain,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.contain,
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
                  child: Text("${data["items"][index]["snippet"]["title"]}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Palette.color4
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        }),
      ):GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2 ,
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        children: List.generate(widget.listChannelsbygroup.allitems.length,(index){
          return Column(
            children: [
              GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    child: CachedNetworkImage(
                      imageUrl: widget.listChannelsbygroup.allitems[index].logo,width: 100,height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.contain,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/vignete.png",width: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                  ),
                ),

              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text("${widget.listChannelsbygroup.allitems[index].title}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Palette.color4
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        }),
      ),*/
    );
  }
}