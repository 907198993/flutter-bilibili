
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/tab_type.dart';
import 'package:pilipala/utils/storage.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin{

  bool flag = false;
  late List tabs;
  late List tabsCtrList;
  late List<Widget> tabsPageList;
  Box userInfoCache = GStorage.userInfo;
  RxBool userLogin = false.obs;
  RxString userFae = ''.obs;
  var userInfo;
  Box setting = GStorage.setting;
  late final StreamController<bool> searchBarStream = StreamController<bool>.broadcast();
  int initialIndex = 1;
  late bool hideSearchBar;
  late TabController tabController;



  void onRefresh() {
    int index = tabController.index;
    var ctr = tabsCtrList[index];
    ctr().onRefresh();
  }

  void animateToTop() {
    int index = tabController.index;
    var ctr = tabsCtrList[index];
    ctr().animateToTop();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfoCache != null;
    userFae.value = userInfo!=null?userInfo.face:'';
    //tab配置
    tabs = tabsConfig;
    tabsCtrList = tabs.map((e) => e['ctr']).toList();
    tabsPageList  = tabs.map<Widget>((e) => e['page']).toList();
    tabController = TabController(initialIndex: initialIndex, length: tabs.length, vsync: this);
    hideSearchBar  = setting.get(SettingBoxKey.hideSearchBar,defaultValue: true);
  }
}