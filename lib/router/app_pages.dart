

import 'package:flutter/animation.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hive/hive.dart';

import '../pages/home/view.dart';
import '../utils/storage.dart';
Box setting = GStorage.setting;
bool iosTransition =
setting.get(SettingBoxKey.iosTransition, defaultValue: false);
class Routes{
  static final List<GetPage> getPages = [
    //首页
    CustomGetPage(name: '/',page: ()=>const HomePage())

  ];
}

class CustomGetPage extends GetPage{
  bool? fullscreen = false;
  CustomGetPage({name,page,this.fullscreen,transitionDuration}):super(
      name: name,
      page: page,
      curve: Curves.linear,
      transition: iosTransition? Transition.cupertino:Transition.native,
      showCupertinoParallax: false,// 如果使用了 Cupertino 风格的过渡动画，禁用页面切换的视差效果。
      popGesture: false,//禁用页面返回手势。
      transitionDuration: transitionDuration,// 设置页面切换动画的持续时间
      fullscreenDialog: fullscreen!=null &&fullscreen//如果设置了 fullscreen 为 true，则表示页面是一个全屏对话框。
  );

}