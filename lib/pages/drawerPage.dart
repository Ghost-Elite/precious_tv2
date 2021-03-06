import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:precious_tv/pages/prevacy_page.dart';
import 'package:precious_tv/pages/replayPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:precious_tv/pages/youtubeVideoPlaylist.dart';
import '../configs/size_config.dart';
import '../utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'aboutPage.dart';
import 'drawerReplay.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';
class DrawerPage extends StatefulWidget {
  var lien;
  var logger = Logger();
  var urlPrevacy,appfburl;
  var appdescription;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  YT_APIPlaylist? ytResults;
  var dataUrl;
  var dataToLoad;
  YoutubePlayerController? controller;
  DrawerPage({Key? key,this.controller,this.appfburl,this.appdescription,this.lien,required this.logger,this.ytApiPlaylist,this.ytApi,required this.ytResultPlaylist,required this.ytResult,this.ytResults,this.dataUrl,this.dataToLoad,this.urlPrevacy}) : super(key: key);

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
    widget.logger.i(' Ghost-Elite ',  widget.appfburl);
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
                    dataToLoad: widget.dataToLoad,


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
            ListTile(
              onTap: (){
                //widget.controller!.pause();
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
              leading: GestureDetector(
                onTap: (){
                  //widget.controller!.pause();
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
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: SizeConfi.screenWidth!/9,
                  height: 44,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/replayer.png')
                      )
                  ),
                ),
              )

              /*IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.tv,
                    size: 24,
                    color: ColorPalette.appColorWhite,
                  ), onPressed: () {

                },
                )*/,
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YoutubeVideoPlayList(


                    ),
                    ),

                  );
                },
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
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage(
                    appdescription: widget.appdescription,
                  ),
                  ),

                );
              },
              child: GestureDetector(
                onTap: ()=>_launchURL(),
                child: ListTile(

                  leading: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      size: 28,
                      color: ColorPalette.appColorWhite,
                    ),
                    onPressed: ()=>_launchURL(),
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
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrevacyPage(
                    urlPrevacy: widget.urlPrevacy,
                  ),
                  ),

                );
              },
              child: ListTile(
                leading: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.lock,
                    size: 28,
                    color: ColorPalette.appColorWhite,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrevacyPage(
                        urlPrevacy: widget.urlPrevacy,
                      ),
                      ),

                    );
                  },
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
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage(
                    appdescription: widget.appdescription,
                  ),
                  ),

                );
              },
              child: ListTile(

                leading: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.exclamationCircle,
                    size: 28,
                    color: ColorPalette.appColorWhite,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage(
                        appdescription: widget.appdescription,
                      ),
                      ),

                    );
                  },
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
            ),
          ],
        ),
      ),
    );
  }
  void _launchURL() async =>
      await canLaunch(widget.appfburl) ? await launch(widget.appfburl) : throw 'Could not launch ${widget.appfburl}';

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}

