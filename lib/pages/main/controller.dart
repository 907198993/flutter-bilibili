import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/pages/home/view.dart';
import 'package:pilipala/utils/storage.dart';

class MainController extends GetxController {
  List<Widget> pages = [const HomePage(), const HomePage(), const HomePage()];

  RxList navigationBars = [
    {
      'icon': Icon(Icons.favorite_outline, size: 21),
      'selectIcon': Icon(
        Icons.favorite,
        size: 21,
      ),
      'label': "首页",
    },
    {
      'icon': const Icon(
        Icons.motion_photos_on_outlined,
        size: 21,
      ),
      'selectIcon': const Icon(
        Icons.motion_photos_on,
        size: 21,
      ),
      'label': "动态",
    },
    {
      'icon': const Icon(
        Icons.folder_outlined,
        size: 20,
      ),
      'selectIcon': const Icon(
        Icons.folder,
        size: 21,
      ),
      'label': "媒体库",
    }
  ].obs;
  DateTime? _lastPressedAt;

  final StreamController<bool> bottomBarStream =
  StreamController<bool>.broadcast();
  Box setting = GStorage.setting;
  late bool hideTabBar;
  @override
  void onInit() {
    super.onInit();
    hideTabBar = setting.get(SettingBoxKey.hideTabBar, defaultValue: true);
  }

  Future<bool> onBackPressed(BuildContext context) {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 2)) {
      _lastPressedAt = DateTime.now();
      SmartDialog.showToast("再按一次退出");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
