import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:precious_tv/pages/replayPage.dart';
import 'package:precious_tv/pages/youtubeVideoPlaylist.dart';
import '../configs/size_config.dart';
import '../utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawerReplay.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';
class DrawerPage extends StatefulWidget {
  var lien;
  var logger = Logger();
  var urlPrevacy;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  YT_APIPlaylist? ytResults;
  var dataUrl;
  var dataToLoad;
  DrawerPage({Key? key,this.lien,required this.logger,this.ytApiPlaylist,this.ytApi,required this.ytResultPlaylist,required this.ytResult,this.ytResults,this.dataUrl,this.dataToLoad,this.urlPrevacy}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  var data,dataVOD;
  Future<void> getData() async {
    final response = await http.get(Uri.parse(widget.dataUrl));
    data = json.decode(response.body);
    //getDirect(data['allitems'][0]['feed_url']);

    //logger.i('Ghost-Elite',data['allitems'][0]['alaune_feed']);
    getVODPrograms(data['allitems'][0]['vod_feed']);

    return data;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: SizeConfi.screenWidth,
        height: SizeConfi.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/drawer.png'),
            fit: BoxFit.fill
          )
        ),
        child: ListView(
          children: [
            const DrawerHeader(child: null,
            ),
            const SizedBox(height: 50),
            ListTile(
              onTap: (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(
                    ytResult: widget.ytResult,
                    ytResultPlaylist: widget.ytResultPlaylist,
                    ytApiPlaylist: widget.ytApiPlaylist,
                    ytApi: widget.ytApi,
                    logger: widget.logger,
                    lien: widget.lien,

                  ),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              leading: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.tv,
                  size: 24,
                  color: ColorPalette.appColorWhite,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(
                      ytResult: widget.ytResult,
                      ytResultPlaylist: widget.ytResultPlaylist,
                      ytApiPlaylist: widget.ytApiPlaylist,
                      ytApi: widget.ytApi,
                      logger: widget.logger,
                      lien: widget.lien,

                    ),
                    ),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
              title:  Text(
                "Live TV",
                style: GoogleFonts.roboto(
                    color: ColorPalette.appColorWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColorWhite
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(
                      ytResult: widget.ytResult,
                      ytResultPlaylist: widget.ytResultPlaylist,
                      ytApiPlaylist: widget.ytApiPlaylist,
                      ytApi: widget.ytApi,
                      logger: widget.logger,
                      lien: widget.lien,

                    ),
                    ),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DrawerReplay(
                    ytResultPlaylist: widget.ytResultPlaylist,
                    urls: dataVOD,
                    dataToLoad: widget.dataToLoad,
                  ),
                  ),

                );
              },
              child: ListTile(
                leading: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.tv,
                    size: 24,
                    color: ColorPalette.appColorWhite,
                  ), onPressed: () {

                },
                ),
                title:  Text(
                  "Replay TV",
                  style: GoogleFonts.roboto(
                      color: ColorPalette.appColorWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),
                trailing: IconButton(
                  icon: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: 17,
                      color: ColorPalette.appColorWhite
                  ),
                  onPressed: () {

                  },
                ),
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YoutubeVideoPlayList(


                  ),
                  ),

                );
              },
              leading: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.youtube,
                  size: 28,
                  color: ColorPalette.appColorWhite,
                ),
                onPressed: () { },
              ),
              title:  Text(
                "YouTube",
                style: GoogleFonts.roboto(
                    color: ColorPalette.appColorWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColorWhite
                ),
                onPressed: () { },
              ),
            ),
            SizedBox(height: 100),
            ListTile(

              leading: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.facebook,
                  size: 28,
                  color: ColorPalette.appColorWhite,
                ),
                onPressed: () { },
              ),
              title:  Text(
                "Facebook",
                style: GoogleFonts.roboto(
                    color: ColorPalette.appColorWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColorWhite
                ),
                onPressed: () { },
              ),
            ),
            ListTile(

              leading: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.lock,
                  size: 28,
                  color: ColorPalette.appColorWhite,
                ),
                onPressed: () { },
              ),
              title:  Text(
                "privacy policy",
                style: GoogleFonts.roboto(
                    color: ColorPalette.appColorWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColorWhite
                ),
                onPressed: () { },
              ),
            ),
            ListTile(

              leading: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.exclamationCircle,
                  size: 28,
                  color: ColorPalette.appColorWhite,
                ),
                onPressed: () { },
              ),
              title:  Text(
                "About",
                style: GoogleFonts.roboto(
                    color: ColorPalette.appColorWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColorWhite
                ),
                onPressed: () { },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

