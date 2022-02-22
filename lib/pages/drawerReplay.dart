import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
class DrawerReplay extends StatefulWidget {
  List<YT_APIPlaylist> ytResultPlaylist = [];
  var dataToLoad;
  var urls;
  DrawerReplay({Key? key,required this.ytResultPlaylist,this.dataToLoad,this.urls}) : super(key: key);

  @override
  _DrawerReplayState createState() => _DrawerReplayState();
}

class _DrawerReplayState extends State<DrawerReplay> {
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  var logger =Logger();
  var dataVOD;
  Future<void> getVODPrograms(String url) async {
    final response = await http.get(Uri.parse(url));
    setState(() {
      dataVOD = json.decode(response.body);
    });
    //getDirect(dataVOD['allitems'][0]['feed_url']);

    //logger.i(' Ghost-Elite 2022 ',dataVOD['allitems']);
    return dataVOD;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
  }

  @override
  Widget build(BuildContext context) {
    logger.i(' ghost-elite 14 ',widget.urls['allitems'].length);
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
    return widget.dataToLoad =="youtube"? GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        logger.i('ghost',widget.ytResultPlaylist[position].thumbnail['high']['url']);
        return GestureDetector(
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
                            imageUrl: widget.ytResultPlaylist[position].thumbnail['high']['url'],
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
                        widget.ytResultPlaylist[position].title,
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
      itemCount: widget.ytResultPlaylist.length,
    ):
    GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, position) {
       // logger.i('ghost',widget.ytResultPlaylist[position].thumbnail['high']['url']);
        return GestureDetector(
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
                            imageUrl: widget.urls['allitems'][position]['logo'],
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
                        widget.urls['allitems'][position]['title'],
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
      itemCount: widget.urls==null?0:widget.urls['allitems'].length,
    );
  }
}