import 'package:flutter/cupertino.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
class PrevacyPage extends StatefulWidget {
  const PrevacyPage({Key? key}) : super(key: key);

  @override
  _PrevacyPageState createState() => _PrevacyPageState();
}

class _PrevacyPageState extends State<PrevacyPage> {
  WebViewController? _controller;
  String viewport = '<head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>';
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
