
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/pages/home/controller.dart';
import 'package:pilipala/pages/home/view.dart';
import 'package:pilipala/utils/storage.dart';

import 'controller.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {

  final MainController _mainController = Get.put(MainController());
  final HomeController _homeController = Get.put(HomeController());

  PageController? _pageController;

  late AnimationController? _animationController;
  late Animation<double>? _fadeAnimation;
  late Animation<double>? _slideAnimation;
  int? _lastSelectTime; //上次点击时间
  int selectedIndex = 0;
  late bool enableMYBar;
  Box setting = GStorage.setting;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration:  Duration(milliseconds: 800),
        reverseDuration: Duration(milliseconds: 0),
        value: 1,
        vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.8,end: 1.0).animate(_animationController!);
    _slideAnimation = Tween(begin: 0.8,end: 1.0).animate(_animationController!);

    _lastSelectTime = DateTime.now().millisecondsSinceEpoch;

    _pageController = PageController(initialPage: selectedIndex);
    enableMYBar = setting.get(SettingBoxKey.enableMYBar, defaultValue: true);
  }

  void setIndex(int value) async{
    if(selectedIndex != value){
      selectedIndex = value;
      _animationController?.reverse().then((_){
        selectedIndex = value;
        _animationController?.forward();
      });
      setState(() {});
    }
    _pageController!.jumpToPage(value);
    var currentPage = _mainController.pages[value];
    if (currentPage is HomePage) {
      if (_homeController.flag) {
        // 单击返回顶部 双击并刷新
        if (DateTime.now().millisecondsSinceEpoch - _lastSelectTime! < 500) {
          _homeController.onRefresh();
        } else {
          _homeController.animateToTop();
        }
        _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
      }
      _homeController.flag = true;
    } else {
      _homeController.flag = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Box localCache  = GStorage.localCache;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double sheetHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).size.width * 9 / 16;
    localCache.put('sheetHeight', sheetHeight);
    localCache.put('statusBarHeight', statusBarHeight);
    return PopScope(
        onPopInvoked: (bool status)=>_mainController.onBackPressed(context),
        child: Scaffold(
          extendBody: true,
          //表示body可以延伸到底部导航栏的底部。如果你有底部导航栏，这样设置可以让body部分覆盖底部导航栏。
          //FadeTransition和SlideTransition，这两者组合起来实现了一个渐变和滑动的动画效果
          body:  FadeTransition(//实现淡入淡出的动画效果
            opacity: _fadeAnimation!,
            child: SlideTransition(//实现滑动过渡的动画效果
              position: Tween<Offset>(
                  begin:  Offset(0,0.5),
                  end: Offset.zero
              ).animate( CurvedAnimation(
                parent: _slideAnimation!,
                curve: Curves.fastOutSlowIn,
                reverseCurve: Curves.linear,
              ),),
              child:PageView(
                physics:  const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index){
                  selectedIndex = index;
                  setState(() {
                  });
                },
                children: _mainController.pages,
              ) ,
            ),
          ),
          bottomNavigationBar:  StreamBuilder(
            stream: _mainController.hideTabBar? _mainController.bottomBarStream.stream:StreamController<bool>.broadcast().stream,
            initialData: true,
            builder: (context,AsyncSnapshot snapshot){
              return  AnimatedSlide(offset: Offset(0, snapshot.data ? 0 : 1), duration: const Duration(milliseconds: 500),
                  child: enableMYBar
                      ?NavigationBar(
                      onDestinationSelected: (value)=>setIndex(value),
                      selectedIndex: selectedIndex,
                      destinations: [
                        ..._mainController.navigationBars.map((e){
                          return NavigationDestination(icon: e['icon'], label: e['label'],selectedIcon: e['selectIcon'],);
                        })
                      ]):BottomNavigationBar(
                    currentIndex: selectedIndex,
                    onTap: (value) => setIndex(value),
                    iconSize: 16,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
                    items: [
                      ..._mainController.navigationBars.map((e) {
                        return BottomNavigationBarItem(
                          icon: e['icon'],
                          activeIcon: e['selectIcon'],
                          label: e['label'],
                        );
                      }).toList(),
                    ],
                  )
              );
            },
          ),
        ));
  }
}
