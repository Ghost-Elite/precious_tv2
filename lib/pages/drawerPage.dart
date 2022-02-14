import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:precious_tv/pages/replayPage.dart';
import '../configs/size_config.dart';
import '../utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawerReplay.dart';
import 'home.dart';
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';
class DrawerPage extends StatefulWidget {
  var lien;
  var logger = Logger();
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  DrawerPage({Key? key,this.lien,required this.logger,this.ytApiPlaylist,this.ytApi,required this.ytResultPlaylist,required this.ytResult}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

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

