// import 'dart:convert';
//
// import 'package:better_player/better_player.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'package:logger/logger.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:http/http.dart' as http;
//
//
//
// class LecteursReplayers extends StatefulWidget {
//   String vodemi, ul, img, desc,typ,youtubeUri;
//   String idUrl;
//
//   LecteursReplayers(
//       {Key key, this.alauneByGroup, this.vodemi, this.ul, this.img, this.desc,this.idUrl,this.typ,this.youtubeUri,this.listChannelsbygroup})
//       : super(key: key);
//
//   @override
//   _LecteursReplayersState createState() => _LecteursReplayersState();
// }
//
// class _LecteursReplayersState extends State<LecteursReplayers> {
//   BetterPlayerController _betterPlayerController;
//   GlobalKey _betterPlayerKey = GlobalKey();
//   ListChannelsbygroup listChannelsbygroup;
//   YoutubePlayerController _controller=YoutubePlayerController(initialVideoId: "");
//   TextEditingController _idController;
//   TextEditingController _seekToController;
//   bool _isPlayerReady = false;
//   YoutubeMetaData _videoMetaData;
//   PlayerState _playerState;
//   bool _muted = false;
//   var logger = Logger();
//   LiveApi liveApi;
//   Duration timeout = Duration(seconds: 30);
//   bool isVideoLoading;
//   RelatedApi relatedApi;
//
//   String urId,titre,image,typeVideo,youtubeUl;
//
//
//   var betterPlayerConfiguration = BetterPlayerConfiguration(
//     autoPlay: true,
//     looping: false,
//     fullScreenByDefault: false,
//     allowedScreenSleep: false,
//     autoDetectFullscreenDeviceOrientation: true,
//     translations: [
//       BetterPlayerTranslations(
//         languageCode: "fr",
//         generalDefaultError: "Impossible de lire la vidéo",
//         generalNone: "Rien",
//         generalDefault: "Défaut",
//         generalRetry: "Réessayez",
//         playlistLoadingNextVideo: "Chargement de la vidéo suivante",
//         controlsNextVideoIn: "Vidéo suivante dans",
//         overflowMenuPlaybackSpeed: "Vitesse de lecture",
//         overflowMenuSubtitles: "Sous-titres",
//         overflowMenuQuality: "Qualité",
//         overflowMenuAudioTracks: "Audio",
//         qualityAuto: "Auto",
//       ),
//     ],
//     deviceOrientationsAfterFullScreen: [
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ],
//     //autoDispose: true,
//     controlsConfiguration: BetterPlayerControlsConfiguration(
//         iconsColor: Colors.white,
//         //controlBarColor: colorPrimary,
//         liveTextColor: Colors.red,
//         playIcon: Icons.play_arrow,
//         enablePip: true,
//         enableFullscreen: true,
//         enableSubtitles: false,
//         enablePlaybackSpeed: false,
//         loadingColor: Colors.white,
//         enableSkips: false,
//         overflowMenuIconsColor: Colors.white,
//         overflowModalColor: Colors.red
//         //enableOverflowMenu: false,
//         ),
//   );
//
//   Future<void> testUrl() async {
//     //String url = "${widget.vodemi}";
//     final response = await http.get(Uri.parse(urId));
//     print(response.body);
//
//     VideoUrl videoUrl = VideoUrl.fromJson(jsonDecode(response.body));
//     logger.w(videoUrl.videoUrl);
//    // urId= videoUrl.videoUrl;
//     BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//         BetterPlayerDataSourceType.network, videoUrl.videoUrl,
//         //liveStream: true,
//
//         notificationConfiguration: BetterPlayerNotificationConfiguration(
//           showNotification: true,
//
//           //notificationChannelName: "7TV Direct",
//           //activityName: "7TV Direct",
//           title: "Vous suivez MALIKIA TV en direct",
//           imageUrl:
//               "https://telepack.net/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-03-at-15.12.32.jpeg",
//         ));
//
//     _betterPlayerController.setupDataSource(dataSource);
//     _betterPlayerController.setupDataSource(dataSource);
//     _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
//   }
//
//
//
//   Future<RelatedApi> FetchRelated() async {
//     var postListUrl =
//     Uri.parse("${widget.ul}");
//     final response = await http.get(postListUrl);
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       //logger.w(listChannelsbygroup);
//       setState(() {
//         relatedApi = RelatedApi.fromJson(jsonDecode(response.body));
//       });
//       logger.w("000",relatedApi.allitems[0].videoUrl);
//       // model= AlauneModel.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception();
//     }
//   }
//
//   playerYoutube(){
//
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.youtubeUri.split("=")[1],
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: true,
//       ),
//     )..addListener(listener);
//     _idController = TextEditingController();
//     _seekToController = TextEditingController();
//     _videoMetaData = const YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//   }
//   void listener() {
//     if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller.value.playerState;
//         _videoMetaData = _controller.metadata;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //logger.w("video url :)",widget.youtubeUri.split("=")[1]);
//     urId=widget.vodemi;
//     titre=widget.desc;
//     image=widget.img;
//     typeVideo=widget.typ;
//     youtubeUl=widget.youtubeUri;
//
//
//     betterPlayerConfiguration;
//     _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
//     _betterPlayerController.addEventsListener((event) {
//       if (event.betterPlayerEventType == BetterPlayerEventType.play) {}
//     });
//     FetchRelated();
//     testUrl();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //typeVideo=="youtube"?YoutubeVideo():Player(),
//     return typeVideo =="youtube"?YoutubePlayerBuilder(
//
//       player: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//
//
//       ),
//       builder: (context, player) => Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: true,
//           flexibleSpace: Image(
//             image: AssetImage('assets/images/headers.png'),
//             fit: BoxFit.cover,
//           ),
//           title: Container(
//             child: Text("YouTube",style: GoogleFonts.roboto(fontSize: 22,color: Palette.color4,fontWeight: FontWeight.bold),),
//           ),
//
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             color: Palette.colorAlbayaneBg
//           ),
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 height: MediaQuery.of(context).size.height,
//                 //padding: EdgeInsets.only(top: 10),
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(
//                       height: 80,
//                     ),
//
//                     Container(
//                       height: 200,
//                       child: player,
//                     ),
//                     //typeVideo=="youtube"?YoutubeVideo():Player(),
//                     card(),
//                     SizedBox(height: 5,),
//                     Expanded(
//                         child: SingleChildScrollView(
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(),
//                             child: Wrap(
//                               children: [
//                                 videoSimilaire(),
//                                 makeVideo(),
//                               ],
//                             ),
//                           ),
//                         )
//                     )
//
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//     ):Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         flexibleSpace: Image(
//           image: AssetImage('assets/images/headers.png'),
//           fit: BoxFit.cover,
//         ),
//         title: Container(
//           child: Text("YouTube",style: GoogleFonts.roboto(fontSize: 22,color: Palette.color4,fontWeight: FontWeight.bold),),
//         ),
//
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           color: Palette.colorAlbayaneBg,
//         ),
//         child: Stack(
//           children: <Widget>[
//             Container(
//               height: MediaQuery.of(context).size.height,
//               //padding: EdgeInsets.only(top: 10),
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: 80,
//                   ),
//
//                   Player(),
//                   //typeVideo=="youtube"?YoutubeVideo():Player(),
//                   card(),
//                   SizedBox(height: 5,),
//                   Expanded(
//                       child: SingleChildScrollView(
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(),
//                           child: Wrap(
//                             children: [
//                               videoSimilaire(),
//                               makeVideo(),
//                             ],
//                           ),
//                         ),
//                       )
//                   )
//
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//
//   }
//
//   Widget card() {
//     return Container(
//       padding: EdgeInsets.all(8),
//       width: double.infinity,
//       height: 40,
//       color: Palette.color4,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 40,
//             height: 50,
//             decoration: BoxDecoration(
//                 image: DecorationImage(image: NetworkImage(image))),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           Flexible(
//             child: Container(
//               child: Text(
//
//               titre,
//               style: TextStyle(
//                 color: Palette.colorAlbayaneLeft,
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: "helvetica",
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget YoutubeVideo(){
//     return YoutubePlayerBuilder(
//         player: YoutubePlayer(
//           controller: _controller,
//         ),
//         builder: (context, player) {
//           return Column(
//             children: [
//               // some widgets
//               player,
//               //some other widgets
//             ],
//           );
//         }
//           );
//
//
//   }
//
//   Widget Player() {
//     return Container(
//       //padding: EdgeInsets.all(10),
//       height: 200,
//       width: double.infinity,
//       //color: Colors.black,
//       child: AspectRatio(
//         aspectRatio: 16 / 9,
//         child: BetterPlayer(controller: _betterPlayerController),
//         //key: _betterPlayerKey,
//       ),
//       //child: playerVideo(),
//     );
//   }
//   Widget videoSimilaire() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10.2),
//           //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               Container(
//                 child: Text(
//                   "Vidéos Similaires",
//                   style: TextStyle(
//                     color: Palette.colorAlbayaneLeft,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "helvetica",
//                   ),
//                 ),
//               ),
//              // SizedBox(width: 3,),
//             ],
//           ),
//         ),
//
//
//       ],
//     );
//   }
//
//   Widget makeVideo() {
//     return ListView.builder(
//       padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//       shrinkWrap: true,
//       physics: ClampingScrollPhysics(),
//       itemBuilder: (context, position) {
//         return Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           elevation: 4.0,
//           shadowColor: Colors.grey,
//           child: Container(
//             margin: EdgeInsets.all(5),
//             child: Column(
//               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       urId=relatedApi.allitems[position].videoUrl;
//                       titre=relatedApi.allitems[position].title;
//                       image=relatedApi.allitems[position].logo;
//                       typeVideo=relatedApi.allitems[position].type;
//                     });
//
//                     if (typeVideo == "vod") {
//
//                       testUrl();
//                     }  else if (typeVideo == "youtube") {
//                       _controller.load(relatedApi.allitems[position].videoUrl.split("=")[1]);
//                     } else {
//
//                     }
//
//                     FetchRelated();
//                     var  logger = Logger();
//                     logger.w(relatedApi.allitems[position].feedUrl);
//
//                     logger.d(titre);
//                   },
//                   child: Row(
//                     children: [
//                       Flexible(
//                         child: Column(
//                           children: [
//                             Container(
//                               margin: EdgeInsets.all(5),
//                               alignment: Alignment.topLeft,
//                               child: Text(
//                                 '${relatedApi.allitems[position].title}',
//                                 style: GoogleFonts.roboto(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 13,
//                                     color: Palette.colorBlack),maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 3,
//                             ),
//                             Container(
//                               margin: EdgeInsets.all(5),
//                               child: Text(
//                                 '${relatedApi.allitems[position].desc}',
//                                 style: GoogleFonts.roboto(
//                                     fontSize: 13.0,
//                                     color: Palette.colorBlack),maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Stack(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 urId=relatedApi.allitems[position].feedUrl;
//                                 titre=relatedApi.allitems[position].title;
//                                 image=relatedApi.allitems[position].logo;
//                               });
//                               testUrl();
//                               FetchRelated();
//                               var  logger = Logger();
//                               logger.w(relatedApi.allitems[position].feedUrl);
//
//                               logger.d(titre);
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               width: 140,
//                               height: 90,
//                               child: ClipRRect(
//                                 clipBehavior: Clip.antiAlias,
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: CachedNetworkImage(
//                                   imageUrl:
//                                   relatedApi.allitems[position].logo,
//                                   fit: BoxFit.cover,
//                                   width: 180,
//                                   height: 90,
//                                   placeholder: (context, url) =>
//                                       Image.asset(
//                                         "assets/images/vignete.png",
//                                       ),
//                                   errorWidget: (context, url, error) =>
//                                       Image.asset(
//                                         "assets/images/vignete.png",
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned.fill(
//                             child: Center(
//                               child: Container(
//                                 width: 40,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                         image: AssetImage(
//                                             "assets/images/play_button.png"))),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//
//               ],
//             ),
//           ),
//         );
//       },
//       itemCount: relatedApi==null?0:relatedApi.allitems.length,
//     );
//   }
// }
