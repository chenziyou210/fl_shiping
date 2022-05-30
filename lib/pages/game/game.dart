/*
 *  Copyright (C), 2015-2021
 *  FileName: game
 *  Author: Tonight丶相拥
 *  Date: 2021/7/13
 *  Description: 
 **/
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/business/home_pages/homepage/homepage_view.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:get/get.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/pages/game/test_game_model.dart';
import 'package:marquee/marquee.dart';
import 'package:hjnzb/pages/live/live_new_logic.dart';

import '../../app_images/app_images.dart';
import '../../generated/announcement_entity.dart';
import '../../manager/app_manager.dart';
import '../../page_config/page_config.dart';
import '../announcement_list_page/announcement_list_logic.dart';
import '../live/live_home_data.dart';

class GamePage extends StatefulWidget {
  @override
  createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with AutomaticKeepAliveClientMixin {

  List<HomePageItems> listData = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // DefalutData(listData);
    // listData.add(HomePageItems(itemViewType: "SingleColumn"));

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Scaffold(
      appBar: DefaultAppBar(
        leading: SizedBox(),
        automaticallyImplyLeading: false,
      ),
    );
    return Scaffold(
      appBar: DefaultAppBar(
        leading: SizedBox(),
        automaticallyImplyLeading: false,
      ),
      body: Obx((){
        var value = Get.find<LiveNewLogic>().state.banner;
        if (value.length == 0) {
          return SizedBox();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8),
              Row(
                  children: [
                    Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Image.asset(AppImages.announcementLeft,
                              width: 88.pt, height: 34.pt,
                              fit: BoxFit.fill
                          ),
                          CustomText("${AppInternational.of(context).newAnnouncement}",
                              fontSize: 14.pt,
                              fontWeight: w_500,
                              color: Colors.white
                          ).paddingOnly(left: 4)
                        ]
                    ).sizedBox(width: 88.pt, height: 34.pt),
                    Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Image.asset(AppImages.announcementRight, fit: BoxFit.fill,
                              width: 259.pt, height: 34.pt
                          ),
                          [Obx((){
                            var value = Get.find<LiveHomeData>().state.homeAnnouncement;
                            if (value.length == 0) {
                              return SizedBox();
                            }
                            var model = value[0];
                            return Marquee(text: "${model.content}".replaceAll("\r", "").replaceAll("\n", ""),
                                style: TextStyle(
                                    fontSize: 12.pt,
                                    fontWeight: w_500,
                                    color: Color.fromARGB(255, 23, 23, 23)
                                ),
                                scrollAxis: Axis.horizontal,
                                velocity: 100.0,
                                blankSpace: 259.pt,
                                // pauseAfterRound: Duration(seconds: 1),
                                // startPadding: 10.0,
                                // accelerationDuration: Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                // decelerationDuration: Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut
                            ).sizedBox(height: 34.pt).paddingOnly(left: 16);
                            // return CustomText("${model.content}",
                            //     overflow: TextOverflow.ellipsis,
                            //     fontSize: 12.pt,
                            //     fontWeight: w_500,
                            //     color: Color.fromARGB(255, 23, 23, 23)
                            // ).paddingSymmetric(horizontal: 16);
                          }).expanded(),
                            SizedBox(width: 4),
                            Image.asset(AppImages.announcementForward).paddingOnly(right: 16)].row()
                              .sizedBox(width: 259.pt)
                        ]
                    ).gestureDetector(onTap: (){
                      Navigator.of(context).pushNamed(AppRoutes.announcementList);
                    }).expanded()
                    // Container(
                    //   height: 34.pt,
                    //   padding: EdgeInsets.symmetric(horizontal: 16),
                    //   decoration: ShapeDecoration(
                    //     shape: _NewAnnouncementContent(
                    //       radius: BorderRadius.circular(4),
                    //       width: 16
                    //     )
                    //   ),
                    //   alignment: Alignment.centerLeft,
                    //   child: ,
                    // ).gestureDetector(onTap: (){
                    //   print(3333333);
                    //   pushViewControllerWithName(AppRoutes.announcementList);
                    // }).expanded()
                  ]
              ).padding(padding: EdgeInsets.symmetric(horizontal: 16.pt)),
              SizedBox(height: 8),
              for (int index = 0; index < value.length; index ++)
                if (value[index].mobilePic != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.pt),
                    child: ExtendedImage.network(value[index].mobilePic!,
                        enableLoadState: false,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover, height: MediaQuery.of(context).size.height).gestureDetector(
                        onTap: (){
                          Navigator.of(context).pushNamed(AppRoutes.imageUrlDisplay, arguments: {
                            // "url": "https://www.111live.live/active/rebate"
                            "url": (value[index].pic ?? "") + "?id=${value[index].id}&userid=${AppManager.getInstance<AppUser>().userId}"
                            // AppManager.getInstance<GlobalSettingModel>()
                            //     .viewModel.serviceUrl ?? ""
                          });
                        }
                    ).clipRRect(radius: BorderRadius.circular(8))
                ).sizedBox(height: 134.pt).marginOnly(bottom: 16.pt)
            ]
          ),
        );
      }),
        // body: SelectorCustom<SettingViewModel, String?>(builder: (String? value) {
        //   if (value == null)
        //     return SizedBox();
        //   return WebView(
        //       initialUrl: value
        //   );
        // }, selector:(s) => s.url2)
    );
  }
}

