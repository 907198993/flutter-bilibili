

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/feed_back.dart';
import 'controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin,TickerProviderStateMixin {
  final HomeController _homeController = Get.put(HomeController());
  List videoList = [];
  late Stream<bool> stream;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = _homeController.searchBarStream.stream;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0,elevation: 0),
      body: Column(
        children: [
          CustomAppBar(stream:_homeController.hideSearchBar?stream:StreamController<bool>.broadcast().stream,
            ctr: _homeController,
          ),
          SizedBox(height: 0 ),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                 controller: _homeController.tabController,
                 tabs: [
                   for(var i in _homeController.tabs) Tab(text: i['label'])
                 ],
                 isScrollable: true,
                 dividerColor: Colors.transparent,
                 enableFeedback: true,
                 splashBorderRadius: BorderRadius.circular(10),
                 onTap: (value){
                 feedBack();
                 if(_homeController.initialIndex == value){
                   _homeController.tabsCtrList[value]().animateToTop();
                 }
                 _homeController.initialIndex = value;
                }
              ),
            ),
          )
        ],
      ),
    );
  }


}



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final double height;
  final Stream<bool>? stream;
  final HomeController? ctr;
  final Function? callback;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight,
    this.stream,
    this.ctr,
    this.callback
  });


  @override
  // TODO: implement preferredSize
  Size get preferredSize =>Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: stream,initialData: true, builder: (context,AsyncSnapshot snapshot){
      return AnimatedOpacity(opacity: snapshot.data?1:0, duration: Duration(milliseconds: 300),child: AnimatedContainer(
        curve: Curves.easeInOutCubicEmphasized, duration: Duration(milliseconds: 500),
        height: snapshot.data
            ? MediaQuery.of(context).padding.top + 52
            : MediaQuery.of(context).padding.top - 10,

      ));
    });
  }
}
