import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:precious_tv/services/serviceNetwork.dart';

class HomePage extends StatefulWidget {
  var lien;
  HomePage({Key? key,this.lien}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Services s = new Services();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pubg New State ${widget.lien['allitems'][0]['title']}',style: TextStyle(
          fontFamily: 'Poppins Bold',
          fontSize: 18,
        ),),
      ),
    );
  }
}

