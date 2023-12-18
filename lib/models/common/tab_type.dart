
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/banguumi/controller.dart';
import '../../pages/banguumi/view.dart';
import '../../pages/hot/controller.dart';
import '../../pages/hot/view.dart';
import '../../pages/live/controller.dart';
import '../../pages/live/view.dart';
import '../../pages/rcmd/controller.dart';
import '../../pages/rcmd/view.dart';

enum TabType{ live, rcmd, hot, bangumi }

extension TabTypeDesc on TabType{
  String get description => ['直播', '推荐', '热门', '番剧'][index];
}

List tabsConfig = [
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '直播',
    'type': TabType.live,
    'ctr': Get.find<LiveController>,
    'page': const LivePage(),
  },
  {
    'icon': const Icon(
      Icons.thumb_up_off_alt_outlined,
      size: 15,
    ),
    'label': '推荐',
    'type': TabType.rcmd,
    'ctr': Get.find<RcmdController>,
    'page': const RcmdPage(),
  },
  {
    'icon': const Icon(
      Icons.whatshot_outlined,
      size: 15,
    ),
    'label': '热门',
    'type': TabType.hot,
    'ctr': Get.find<HotController>,
    'page': const HotPage(),
  },
  {
    'icon': const Icon(
      Icons.play_circle_outlined,
      size: 15,
    ),
    'label': '番剧',
    'type': TabType.bangumi,
    'ctr': Get.find<BangumiController>,
    'page': const BangumiPage(),
  },
];
