import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomeWidgetState();
  }
}

class HomeWidgetState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    new Tab(text: "Featured"),
    new Tab(text: "Popular"),
    new Tab(text: "Latest")
  ];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: const Text('Bubble Tab Indicator'),
        bottom:  TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator:  const BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: Colors.blueAccent,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
            // Other flags
            // indicatorRadius: 1,
            // insets: EdgeInsets.all(1),
            // padding: EdgeInsets.all(10)
          ),
          tabs:  [
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
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:  [
          listItem,
          listItem,
          listItem,
        ],
      ),
    );
  }
  var listItem = CustomScrollView(
    slivers: <Widget>[
      /*SliverGrid(
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
          crossAxisCount: 1,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1.0,
        ),
      ),*/
      SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20,),
            Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20,),
            Container(
              width: 100,
              height: 300,
              color: Colors.green,
            ),
            SizedBox(height: 20,),
            Container(
              width: 100,
              height: 300,
              color: Colors.cyan,
            ),
            SizedBox(height: 100,),
            Container(
              width: 100,
              height: 300,
              color: Colors.pink,
            ),

          ],
        ),
      )

    ],
  );
}