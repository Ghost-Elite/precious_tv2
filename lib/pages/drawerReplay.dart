import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';

import '../utils/constants.dart';
class DrawerReplay extends StatefulWidget {
  List<YT_APIPlaylist> ytResultPlaylist = [];
  DrawerReplay({Key? key,required this.ytResultPlaylist}) : super(key: key);

  @override
  _DrawerReplayState createState() => _DrawerReplayState();
}

class _DrawerReplayState extends State<DrawerReplay> {
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  var logger =Logger();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
  }

  @override
  Widget build(BuildContext context) {
    logger.i(' ghost-elite 14 ',widget.ytResultPlaylist[0].id);
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
    return GridView.builder(
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
                            image: DecorationImage(
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
                        style: TextStyle(
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
    );
  }
}