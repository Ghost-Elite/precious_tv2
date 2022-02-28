import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../configs/size_config.dart';
import '../utils/constants.dart';
class AboutPage extends StatefulWidget {
  var appdescription;
  AboutPage({Key? key,this.appdescription}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var logger=Logger();
  var data;
  Future<void> getAbout() async {
    final response = await http.get(Uri.parse(widget.appdescription));
    setState(() {
      data = json.decode(response.body);
    });
    logger.i(' Ghost-Elite 2022 ',data['app_description']);
    return data;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAbout();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: ColorPalette.appColorWhite),
            onPressed: () {
              //PlayerInit(widget.dataUrls);
              //PlayerInit();
              Navigator.of(context).pop();
            }),
        //iconTheme: IconThemeData(color: ColorPalette.),
        title: Container(
          width: 100,
          height: 19.0,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/title.png'))),
        ),
      ),
      body: SingleChildScrollView(
        child: Prevacy(),
      ),
    );
  }
  Widget Prevacy(){
    return data!=null && data['app_description']!=0? Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: SizeConfi.screenWidth,
        child: HtmlWidget('${data['app_description']}'),
      ),
    ):Container();
  }
}
