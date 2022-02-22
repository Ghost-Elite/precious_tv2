/*
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'lecteur_emisions.dart';



class EmisionsPage extends StatefulWidget {

  String?  test, lien;

  EmisionsPage({required Key key, this.lien, this.test, listChannelsbygroup})
      : super(key: key);

  @override
  _EmisionsPageState createState() => _EmisionsPageState();
}

class _EmisionsPageState extends State<EmisionsPage> {
  String? query;
  TextEditingController nameController = TextEditingController();
  var logger =Logger();

  String? videoId, title, time,api,idVideo,json,related,texte,heure,descpt,tpe,vido_url;


  Future<ListChannelsbygroup> fetchReplay() async {
    var postListUrl = Uri.parse(widget.lien);

    final response = await http.get(postListUrl);
    if (response.statusCode == 200 ) {
      final data = jsonDecode(response.body);
      //logger.d(data);
      // print(widget.listChanel.allitems[0].feedUrl);

      return ListChannelsbygroup.fromJson(jsonDecode(response.body));

    } else {
      throw Exception();
    }
  }
  */
/*Future<ListItemsByChannel> fetchEmission() async {
    var postListUrl =
    Uri.parse("https://7tv.acangroup.org//myapi//listItemsByChannel//79");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      //final data = jsonDecode(response.body);
      return ListItemsByChannel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }*//*



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Image(
          image: AssetImage('assets/images/headers.png'),
          fit: BoxFit.cover,
        ),
        title: Container(
          child: Text("Replay",style: GoogleFonts.roboto(fontSize: 22,color: Palette.color4,fontWeight: FontWeight.bold),),
        ),

      ),
      body: Container(
        decoration: BoxDecoration(
          color: Palette.colorAlbayaneBg,
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              //padding: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 90,
                  ),

                  //typeVideo=="youtube"?YoutubeVideo():Player(),
                  SizedBox(height: 5,),
                  Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: Wrap(
                            children: [
                              //videoSimilaire(),
                              //makeVideo(),

                              _buildCard()
                            ],
                          ),
                        ),
                      )
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(){
    return Container(
      child:ConstrainedBox(
        constraints: BoxConstraints(),
        child:  FutureBuilder(
            future: fetchReplay(),
            builder: (context,snapshot){

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.transparent,
                  ),
                );
              } else {
                return GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2 ,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 4,
                  children: List.generate(snapshot.data.allitems.length,(index){
                    return GestureDetector(
                        onTap: () {
                          //logger.d(snapshot.data.allitems[index].video_url);


                          var  logger = Logger();
                          logger.d("Ghost-Elite 2021",snapshot.data.allitems[index].videoUrl);
                        },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(

                                      child: snapshot.data.allitems.length == 0 ? Container(child: Text("Erreur"),) :CachedNetworkImage(
                                        imageUrl: snapshot.data.allitems[index].logo,width: 100,height: 100,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Image.asset(
                                          "assets/images/vignete.png.png",width: 150,
                                          fit: BoxFit.contain,
                                        ),
                                        errorWidget: (context, url, error) => Image.asset(
                                          "assets/images/vignete.png.png",width: 150,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: 150,
                                    ),
                                  ),
                                  onTap: () {
                                    //logger.d(snapshot.data.allitems[index].video_url);
                                    if(snapshot.data.allitems[index].type == "youtube"){
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => LecteurDesReplayes(
                                                ul: snapshot.data.allitems[index].relatedItems,
                                                img: snapshot.data.allitems[index].logo,
                                                desc: snapshot.data.allitems[index].title,
                                                vodemi: snapshot.data.allitems[index].videoUrl,
                                                typ: snapshot.data.allitems[index].type,
                                                listChannelsbygroup: snapshot.data,
                                              )
                                          ),
                                              (Route<dynamic> route) => true);
                                    }else{
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => LecteurDesReplayes(
                                                ul: snapshot.data.allitems[index].relatedItems,
                                                vodemi: snapshot.data.allitems[index].videoUrl,
                                                typ: snapshot.data.allitems[index].type,
                                                listChannelsbygroup: snapshot.data,
                                              )
                                          ),
                                              (Route<dynamic> route) => true);
                                    }

                                    var  logger = Logger();
                                    logger.d("Ghost-Elite 2021",snapshot.data.allitems[index].videoUrl);
                                  }
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/play_button.png"))),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text("${snapshot.data.allitems[index].title}",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Palette.colorAlbayaneLeft
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                );
              }

            }

        ),
      ),
    );
  }
}*/
