

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class GStorage{

  static late final Box setting;

  static Future<void> init() async{
    final dir = await getApplicationSupportDirectory();
    final path = dir.path;
    await Hive.initFlutter('$path/hive');

    //设置
    setting  = await Hive.openBox('setting');
  }
}

class SettingBoxKey{
  static const String defaultTextScale = 'textScale';
  static const String customColor = 'customColor';//自定义主题色
  static const String displayMode = 'displayMode';



  /// 外观
  static const String themeMode = 'themeMode';
  static const String iosTransition = 'iosTransition'; // ios路由
}