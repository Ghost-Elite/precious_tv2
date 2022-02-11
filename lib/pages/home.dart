import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:precious_tv/pages/preciousTvPage.dart';
import 'package:precious_tv/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawerPage.dart';
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
class HomePage extends StatefulWidget {
  var lien;
  var logger=Logger();
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  HomePage({Key? key,this.lien,required this.logger,this.ytApi,required this.ytResult,required this.ytResultPlaylist,this.ytApiPlaylist}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  var scaffold = GlobalKey<ScaffoldState>();
  TabController? tabController;
  bool? _isConnected;
  Future<void> test() async {
    // Simple check to see if we have Internet
    // ignore: avoid_print
    widget.logger.i('''The statement 'this machine is connected to the Internet' is: ''');
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    widget.logger.i(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    widget.logger.i(
        'Current status: ${await InternetConnectionChecker().connectionStatus}');
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
          // ignore: avoid_print
            widget.logger.i('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            widget.logger.i('You are disconnected from the internet.');
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(
        const Duration(seconds: 10)
    );
    await listener.cancel();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_checkInternetConnection();
    test();
    //widget.logger.i(' ghost-elite 221 ',widget.ytResult[0].title);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();


  }

  @override
  Widget build(BuildContext context) {
    //widget.logger.i(' Ghost-Elite ',_isConnected == true ? 'Connected' : 'Not Connected',)
    tabController = TabController(length: 3, vsync: this);
    var tabBarItem = TabBar(
      labelStyle: GoogleFonts.rowdies(fontSize: 13,fontWeight: FontWeight.bold),
      labelColor: ColorPalette.appBarColor,
      unselectedLabelColor: ColorPalette.appYellowColor,
      padding: const EdgeInsets.only(top: 10),
      indicator: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)), // Creates border
        color: ColorPalette.appYellowColor),
      tabs: const [
        Tab(
          text: 'Precious TV',
        ),
        Tab(
          text: 'Replay TV',
        ),
        Tab(
          text: 'YouTube',
        ),
      ],
      controller: tabController,
      //indicatorColor: ColorPalette.appColorBg,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffold,
        drawer: DrawerPage(
          ytResult: widget.ytResult,
          ytResultPlaylist: widget.ytResultPlaylist,
          ytApi: widget.ytApi,
          ytApiPlaylist: widget.ytApiPlaylist,
          lien: widget.lien,
          logger: widget.logger,
        ),
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
          leading: GestureDetector(
            onTap: (){
              scaffold.currentState?.openDrawer();
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/menu.png')
                  )
              ),
            ),
          ),
          bottom: tabBarItem,
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            PreciousTvPage(dataUrl: widget.lien['allitems'][0]['feed_url'],ytResult: widget.ytResult,ytResultPlaylist: widget.ytResultPlaylist,ytApi: widget.ytApi,ytApiPlaylist: widget.ytApiPlaylist),
            listItem,
            listItem

          ],
        ),
      ),
    );


      /*Scaffold(
      drawer: DrawerPage(),
      key: scaffold,
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
        leading: GestureDetector(
          onTap: (){
            scaffold.currentState?.openDrawer();
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/menu.png')
              )
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 200,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            key: _betterPlayerKey,
            child: BetterPlayer(controller: betterPlayerController!),
          ),
        ),
      ),
    )*/;
  }

  var listItem = ListView.builder(
    itemCount: 20,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Card(
          elevation: 5.0,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text("ListItem $index"),
          ),
        ),

      );
    },
  );
}

