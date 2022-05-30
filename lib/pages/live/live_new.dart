/*
 *  Copyright (C), 2015-2021
 *  FileName: live_new
 *  Author: Tonight丶相拥
 *  Date: 2021/12/7
 *  Description: 
 **/

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/business/home_pages/homepage/homepage_view.dart';
import 'package:hjnzb/business/home_pages/homepage/widget/homepage_widget.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live/live_detail/live_detail_page.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../business/home_pages/homepage/models/homepage_model.dart';
import '../../config/app_colors.dart';
import '../announcement_list_page/announcement_list_logic.dart';
import 'live_home_data.dart';
import 'live_new_logic.dart';

class LiveListPageNew extends StatefulWidget {
  @override
  createState() => _LiveListPageNewState();
}

class _LiveListPageNewState extends AppStateBase<LiveListPageNew>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin, Toast {
  final LiveNewLogic _controllers = LiveNewLogic();
  final LiveHomeData _controller = LiveHomeData();

  /// 数据
  TabController? _tabController;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controllers);
    Get.put(_controller);
    _controller.getHomeTabData(context);
    _controller.appBannerLoad();
    _controller.appAnnouncementLoad();
  }

  void _eventListener(int lenght) {
    _tabController?.dispose();
    _tabController = null;
    _tabController = TabController(length: lenght, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<LiveHomeData>();
    _tabController?.dispose();
  }

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;
  late var enableOpenLiving;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    enableOpenLiving = AppManager.getInstance<AppUser>().enableOpenLive;
    return scaffold;
  }

  @override
  // TODO: implement body
  Widget get body => Column(children: [
        Container(
          width: this.width,
          height: 100.pt,
          decoration: BoxDecoration(
            color: AppMainColors.backgroudColor,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(AppImages.appbar_bg),
            ),
          ),
          alignment: Alignment.bottomCenter,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Image.asset(AppImages.applogo, width: 32.pt, height: 32.pt),
            SizedBox(width: 12),
            Expanded(
                child: Container(
              height: 32,
              constraints: BoxConstraints(maxHeight: 32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppMainColors.separaLineColor6,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //设置四周边框
                border: new Border.all(
                    width: 1, color: AppMainColors.separaLineColor10),
              ),
              child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                    isCollapsed: true,
                    hintStyle: TextStyle(
                        fontWeight: w_400,
                        fontSize: 14.pt,
                        color: AppMainColors.whiteColor20),
                    hintText: intl.homeSearchHint,
                    enabled: true,
                    prefixIcon:
                        Icon(Icons.search, color: Colors.white, size: 16),
                    border: InputBorder.none),
                style: TextStyle(
                    fontWeight: w_400,
                    fontSize: 14.pt,
                    color: AppMainColors.whiteColor100),
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
              ),
            )),
            SizedBox(width: 10),
            Container(
              alignment: Alignment.center,
              height: 32,
              decoration: BoxDecoration(
                  color: AppMainColors.separaLineColor6,
                  borderRadius: BorderRadius.circular(14)),
              child: Image.asset(
                AppImages.icon_home_rank,
                width: 24.pt,
                height: 24.pt,
              ).paddingOnly(left: 12, right: 12, top: 2, bottom: 2),
            ).gestureDetector(onTap: () {
              pushViewControllerWithName(AppRoutes.rankIntegration);
            }),
            if (enableOpenLiving)
              Container(
                margin: EdgeInsets.only(left: 8.pt),
                alignment: Alignment.center,
                height: 32,
                decoration: BoxDecoration(
                    color: AppMainColors.separaLineColor6,
                    borderRadius: BorderRadius.circular(14)),
                child: Image.asset(
                  AppImages.icon_home_live,
                  width: 24.pt,
                  height: 24.pt,
                ).paddingOnly(left: 12, right: 12, top: 2, bottom: 2),
              ).gestureDetector(onTap: () async {
                await Permission.camera.request();
                await Permission.microphone.request();
                pushViewControllerWithName(AppRoutes.livingPreviewNew);
              }),
          ]).paddingOnly(left: 16, right: 16, bottom: 10),
        ),
        Container(
          color: AppMainColors.backgroudColor,
          child: Obx(() {
            var value = Get.find<LiveHomeData>().state.homeTabdata;
            if (value.length == 0) {
              return Container(color: AppMainColors.backgroudColor);
            } else {
              _eventListener(value.length);
            }
            return Column(
              children: [
                CustomTabBar(
                  tabs: (_) => value.map((e) {
                    return Container(
                        alignment: Alignment.bottomCenter,
                        child: CustomText(
                          "${e.name}",
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

                    children: value.map((e) {
                          return HomeListWidgets((items,index){
                            pushViewControllerWithName(AppRoutes.audiencePage,
                                arguments: {"index": index, "rooms": items});
                          });
                            //
                        return   LiveDetailPage(e.id, onTap1: (models, index) {
                            pushViewControllerWithName(AppRoutes.audiencePage,
                                arguments: {"index": index, "rooms": models});
                          });
                        }).toList(),
                        controller: _tabController)
                    .expanded()
              ],
            );
          }),
        ).expanded(),
      ]);
}