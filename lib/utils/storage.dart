

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class GStorage{

  static late final Box userInfo;
  static late final Box setting;
  static late final Box localCache;
  static Future<void> init() async{
    final dir = await getApplicationSupportDirectory();
    final path = dir.path;
    await Hive.initFlutter('$path/hive');

    //登录用户信息
    userInfo = await Hive.openBox(
      'userInfo',compactionStrategy: (entries,deletedEntries){
        return deletedEntries>2;
    }
    );

    //设置
    setting  = await Hive.openBox('setting');

    //本地缓存
    localCache = await Hive.openBox('localCache',compactionStrategy: (entries,deletedEntries){
      return deletedEntries>4;
    });
  }
}

class SettingBoxKey{
  static const String defaultTextScale = 'textScale';
  static const String feedBackEnable = 'feedBackEnable';
  static const String customColor = 'customColor';//自定义主题色
  static const String displayMode = 'displayMode';
  static const String hideTabBar = 'hideTabBar';//收起底栏
  static const String enableMYBar = 'enableMYBar';
  static const String hideSearchBar = 'hideSearchBar'; // 收起顶栏

  /// 外观
  static const String themeMode = 'themeMode';
  static const String iosTransition = 'iosTransition'; // ios路由
}