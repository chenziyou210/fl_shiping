import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/pages/game/jump_game_state.dart';
import 'package:provider/provider.dart';

import '../../app_images/app_images.dart';
import '../../base/app_base.dart';
import '../../common/app_common_widget.dart';
import '../../config/app_colors.dart';
import '../../manager/app_manager.dart';
import '../../page_config/page_config.dart';
import '../components/components_view.dart';
import '../live/live_home_data.dart';
import '../recharge/recharge_page.dart';
import '../tab/tab_model.dart';
import 'jump_game_detail_list.dart';
import 'jump_game_logic.dart';

class JumpGamePage extends StatefulWidget {
  @override
  createState() => _JumpGamePageState();
}

class _JumpGamePageState extends AppStateBase<JumpGamePage>
    with TickerProviderStateMixin {
  final logic = Get.put(JumpGameLogic());
  final state = Get.find<JumpGameLogic>().state;

  /// 数据
  TabController? _tabController;

  void _eventListener(int lenght) {
    _tabController?.dispose();
    _tabController = null;
    _tabController = TabController(length: lenght, vsync: this);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logic.getGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox.shrink(),
        title: CustomText("${intl.game}", fontSize: 16, color: Colors.white),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 10, top: 6),
            child: CustomText("${intl.customService}",
                fontSize: 14, color: Colors.white),
          ).gestureDetector(onTap: () {
            pushViewControllerWithName(AppRoutes.contactServicePage,
                arguments: {
                  "url": AppManager.getInstance<GlobalSettingModel>()
                          .viewModel
                          .serviceUrl ??
                      "https://www.baidu.com",
                  "title": "${intl.customService}",
                });
          }),
        ],
      ),
      body: Column(
        children: [
          UniversalBanner(),
          UniversalAnnouncement(),
          Container(
            alignment: Alignment.center,
            height: 120,
            padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 10),
            child: Material(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText("${AppManager.getInstance<AppUser>().name}",
                            fontSize: 13, color: Colors.white),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            CustomText(
                                "￥${AppManager.getInstance<AppUser>().lockMoney}",
                                fontSize: 14,
                                color: Colors.yellow),
                            SizedBox(width: 20),
                            CustomText("刷新",
                                fontSize: 14, color: Colors.yellow),
                          ],
                        ),
                      ]),
                ),
                Consumer<TabModelNotifier>(builder: (_, model, __) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.announcement,
                            width: 26, height: 26),
                        SizedBox(height: 8),
                        CustomText("${intl.deposit}",
                            fontSize: 14, color: Colors.yellow),
                      ]).gestureDetector(onTap: () {
                    model.updateIndex(2);
                  }).expanded();
                }),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(AppImages.announcement, width: 26, height: 26),
                  SizedBox(height: 8),
                  CustomText("${intl.withdraw}",
                      fontSize: 14, color: Colors.yellow),
                ]).expanded(),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(AppImages.announcement, width: 26, height: 26),
                  SizedBox(height: 8),
                  CustomText("${intl.discount}",
                      fontSize: 14, color: Colors.yellow),
                ]).expanded(),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(AppImages.announcement, width: 26, height: 26),
                  SizedBox(height: 8),
                  CustomText("${intl.record}",
                      fontSize: 14, color: Colors.yellow),
                ]).expanded(),
              ]),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.red,
              elevation: 5.0,
            ),
          ),
          Obx(() {
            var gameTabList = state.gameTabList;
            if (gameTabList.length == 0) {
              return Container(color: AppMainColors.backgroudColor);
            } else {
              _eventListener(gameTabList.length);
            }
            return Column(
              children: [
                CustomTabBar(
                  tabs: (_) => gameTabList.map((e) {
                    return Container(
                        alignment: Alignment.bottomCenter,
                        child: CustomText(
                          "${e.gameName}",
                        ) //, textAlign: TextAlign.center
                        );
                  }).toList(),
                  labelStyle: TextStyle(
                    fontSize: 18.pt, //22.pt,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.pt, //14.pt,
                  ),
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  controller: _tabController!,
                  borderSide: BorderSide(width: 0, color: Colors.transparent),
                  isScrollable: true,
                ),
                CustomTabBarView(
                    children: gameTabList.map((e) {
                      return JumpGameDetailPage(e.gameType);
                    }).toList(),
                    controller: _tabController)
                    .expanded()
              ],
            ).expanded();
          })
        ],
      ),

    );
  }
}
