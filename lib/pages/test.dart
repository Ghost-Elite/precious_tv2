import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class NestedScrollViewSampleOne extends StatelessWidget {
  const NestedScrollViewSampleOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NestedScrollView first sample',
      home: NestedScrollViewFirstHome(),
    );
  }
}

class NestedScrollViewFirstHome extends StatelessWidget {
  const NestedScrollViewFirstHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NestedScrollView Sample'),
      ),
      body: /*NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              //forceElevated: innerBoxIsScrolled,
              //floating: true,

              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Container(
                  color: Colors.blue,
                  child: const Text(
                    "The Collapsing Toolbar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                background: Image.network(
                  'https://cdn.pixabay.com/photo/2016/09/10/17/18/book-1659717_960_720.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.orange[100 * (index % 20)],
                    child: Text('grid item $index'),
                  );
                },
                childCount: 30,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 2.0,
              ),
            ),
          ],
        ),
      )*/
      WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          controller.loadString(r"""
           <html lang="en">
              <body>
                  <script src="https://geo.dailymotion.com/libs/player/5b4b33dcca31c0674bff"></script>
        
        
                  <div id="my-dailymotion-player">My Player placeholder</div>

            <script>
              dailymotion
                .createPlayer("my-dailymotion-player", {
                  video: "x84sh87",
              })
              .then((player) => console.log(player))
              .catch((e) => console.error(e));
            </script>
            </body>
           </html>
      """);
        },
      ),
    );
  }
}
