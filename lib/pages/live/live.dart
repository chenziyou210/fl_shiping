/*
 *  Copyright (C), 2015-2021
 *  FileName: live
 *  Author: Tonight丶相拥
 *  Date: 2021/7/13
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/app_common_widget.dart';
// import 'package:hjnzb/common/common_widget/app_common_widget.dart';
import 'package:hjnzb/generated/banner_entity.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live_room/mute_model.dart';
import 'package:provider/provider.dart';
import 'live_detail/live_detail_page.dart';
import 'live_enum.dart';
import 'live_model.dart';
import 'anchor_type.dart';

class LivePage extends StatefulWidget {
  @override
  createState() => _LivePageState();
}

class _LivePageState extends AppStateBase<LivePage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  
  late TabController _controller;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    model.loadData();
  }

  @override
  LiveModel? initializeModel() {
    // TODO: implement initializeModel
    return LiveModel();
  }

  @override
  // TODO: implement scaffold
  Widget get scaffold => ChangeNotifierProvider.value(value: model.viewModel,
      child: super.scaffold);

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    automaticallyImplyLeading: false,
    leading: GestureDetector(
      onTap: (){
        pushViewControllerWithName(AppRoutes.listPage);
      },
      child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 9),
                child: Image.asset(AppImages.ranking)
            ),
            SizedBox(width: 6),
            // Expanded(child: Stack(
            //     children: [
            //       Positioned(child: _AvatarItem(), left: (24 - 3) * 2),
            //       Positioned(child: _AvatarItem(), left: (24 - 3)),
            //       _AvatarItem()
            //     ]
            // ))
          ]
      )
    ),
    // leadingWidth: 77 + 24,
    title: GestureDetector(
      onTap: (){
        // pushViewControllerWithName(AppRoutes.liveSearchPage);
      },
      child: Container(
          height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.c142_142_147.withOpacity(0.12)
          ),
          child: Row(
              children: [
                SizedBox(width: 13),
                Image.asset(AppImages.search),
                SizedBox(width: 10),
                Text(intl.search,
                    style: AppStyles.f15wnormalc78_88_110)
              ]
          )
      )
    ),
    actions: [
      // Padding(
      //   padding: EdgeInsets.only(right: 16),
      //   child: Center(
      //     child: GestureDetector(
      //       onTap: (){
      //         pushViewControllerWithName(AppRoutes.conversationList);
      //       },
      //       child: Image.asset(AppImages.message)
      //     )
      //   )
      // )
    ]
  );

  @override
  // TODO: implement body
  Widget get body => Container(
    child: Column(
      children: [
        SizedBox(height: 12),
        SizedBox(
          height: 30,
          width: double.infinity,
          child: CustomTabBar1(
              tabs: (_) => [
                // SizedBox(width: 70,
                //  child: Text(intl.attention)),
                // SizedBox(width: 70,
                //     child: Text(intl.popular)),
                // SizedBox(width: 70,
                //     child: Text(intl.game)),
                // SizedBox(width: 70,
                //     child: Text(intl.nearby)),
                Text(intl.attention),
                Text(intl.popular),
                Text(intl.game),
                // Text(intl.nearby)
              ],
              isScrollable: true,
              controller: _controller,
              labelStyle: AppStyles.f16w400c0_0_0,
              unselectedLabelStyle: AppStyles.f14w400c0_0_0,
              labelColor: AppColors.c0_0_0,
              unselectedLabelColor: AppColors.c0_0_0.withOpacity(0.7),
              decoration: UnderlineTabLinearGradientIndicatorCustom(
                  isCircle: true,
                  gradient: LinearGradient(colors: [
                    AppColors.c165_59_227,
                    AppColors.c106_69_255
                  ], begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                  width: 12,
                  borderSide: BorderSide(width: 1.5)
              )
          )
        ),
        SizedBox(height: 11),
        SelectorCustom<LiveViewModel, List<BannerEntity>>(builder: (data) {
          return NullWidget<List<BannerEntity>>(data, builder: (_, value) {
            return Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Swiper(
                        autoplay: value.length == 1 ? false : true,
                        itemHeight: 134,
                        itemCount: value.length,
                        pagination: SwiperPagination(),
                        itemBuilder: (_, index) {
                          return ExtendedImage.network(value[index].pic!,
                              enableLoadState: false,
                              width: this.width,
                              fit: BoxFit.cover, height: 134);
                        },
                      ).clipRRect(radius: BorderRadius.circular(8))
                  ).sizedBox(height: 134),
                  SizedBox(height: 9)
                ]
            );
          }, predict: (value) => value.length == 0);
        }, selector: (l) => l.banner),
        Expanded(child: TabBarView(children: [
          LiveDetailPage(1, onTap: (model) async {
            var type = LiveEnum.common.getLiveType(model.roomType ?? 0);
            dynamic v;
            if (type == LiveEnum.secret) {
              v = await alertViewController(InputDialog(
                  cancel: () {
                    popViewController();
                  },
                  confirm: (text){
                    popViewController(text);
                  }
              ));
              if (v == null || (v as String).isEmpty) {
                return;
              }
            }else if (type == LiveEnum.ticker){
              v = model.ticketAmount;
            }else if (type == LiveEnum.timer){
              v = model.timeDeduction;
            }else {
              v = "";
            }

            // var result = await this.model.verify(model.userid!, model.trySee ?? false, v);
            // if (result.isSuccess) {
            //   pushViewControllerWithName(AppRoutes.liveRoom, arguments: {
            //     "channelId": result.object["channelId"],
            //     "roomId": result.object["roomid"],
            //     "roomName": model.roomtitle,
            //     "ownerId": model.userid,
            //     "token": result.object["token"],//result.object["utoken"],//
            //     "uid": result.object["uid"],//result.object["uuid"],//
            //     "userId": model.userid,
            //     "value": v,
            //     "chatId": result.object["imRoomId"],
            //     "isTimer": type == LiveEnum.timer,
            //     "muteModel": result.object["time"] != null
            //         && result.object["banOpentime"] != null ? MuteModel(result.object["time"],
            //         DateTime.parse(result.object["banOpentime"]))
            //         : null
            //   });
            // }
            //this.channelId = arguments["channelId"] ?? "",
            //         this.isAnchor = arguments["anchor"] ?? false,
            //         this.roomId = arguments["roomId"],
            //         this.roomName = arguments["roomName"],
            //         this.ownerId = arguments["ownerId"],
            //         this.isNeedCreateRoom = arguments["isNeedCreateRoom"] ?? false,
            //         this.isStandardQuality = arguments["isStandardQuality"] ?? true

          }),
          LiveDetailPage(2, onTap: (model) async {
            var type = LiveEnum.common.getLiveType(model.roomType ?? 0);
            dynamic v;
            if (type == LiveEnum.secret) {
              v = await alertViewController(InputDialog(
                  cancel: () {
                    popViewController();
                  },
                  confirm: (text){
                    popViewController(text);
                  }
              ));
              if (v == null || (v as String).isEmpty) {
                return;
              }
            }else if (type == LiveEnum.ticker){
              v = model.ticketAmount;
            }else if (type == LiveEnum.timer){
              v = model.timeDeduction;
            }else {
              v = "";
            }

            // var result = await this.model.verify(model.userid!, model.trySee ?? false, v);
            // if (result.isSuccess) {
            //   pushViewControllerWithName(AppRoutes.liveRoom, arguments: {
            //     "channelId": result.object["channelId"],
            //     "roomId": result.object["roomid"],
            //     "roomName": model.roomtitle,
            //     "ownerId": model.userid,
            //     "chatId": result.object["imRoomId"],
            //     "token": result.object["token"],//result.object["utoken"],//
            //     "uid": result.object["uid"],//result.object["uuid"],//
            //     "userId": model.userid,
            //     "value": v,
            //     "isTimer": type == LiveEnum.timer,
            //     "muteModel": result.object["time"] != null
            //         && result.object["banOpentime"] != null ? MuteModel(result.object["time"],
            //         DateTime.parse(result.object["banOpentime"]))
            //         : null
            //   });
            // }
          }),
          LiveDetailPage(3, onTap: (model) async {
            var type = LiveEnum.common.getLiveType(model.roomType ?? 0);
            dynamic v;
            if (type == LiveEnum.secret) {
              v = await alertViewController(InputDialog(
                  cancel: () {
                    popViewController();
                  },
                  confirm: (text){
                    popViewController(text);
                  }
              ));
              if (v == null || (v as String).isEmpty) {
                return;
              }
            }else if (type == LiveEnum.ticker){
              v = model.ticketAmount;
            }else if (type == LiveEnum.timer){
              v = model.timeDeduction;
            }else {
              v = "";
            }

            // var result = await this.model.verify(model.userid!, model.trySee ?? false, v);
            // if (result.isSuccess) {
            //   pushViewControllerWithName(AppRoutes.liveRoom, arguments: {
            //     "channelId": result.object["channelId"],
            //     "roomId": result.object["roomid"],
            //     "roomName": model.roomtitle,
            //     "ownerId": model.userid,
            //     "token": result.object["token"],//result.object["utoken"],//
            //     "uid": result.object["uid"],//result.object["uuid"],//
            //     "userId": model.userid,
            //     "value": v,
            //     "chatId": result.object["imRoomId"],
            //     "isTimer": type == LiveEnum.timer,
            //     "muteModel": result.object["time"] != null
            //         && result.object["banOpentime"] != null ? MuteModel(result.object["time"],
            //         DateTime.parse(result.object["banOpentime"]))
            //         : null
            //   });
            // }
          }),
          // SizedBox()
        ], controller: _controller))
      ]
    )
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return scaffold;
  }

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c255_255_255;

  @override
  // TODO: implement model
  LiveModel get model => super.model as LiveModel;
}

class InputDialog extends AlertDialog {
  InputDialog({required this.cancel, required this.confirm});
  final VoidCallback cancel;
  final void Function(String) confirm;
  final TextEditingController controller = TextEditingController();

  @override
  // TODO: implement title
  Widget? get title => CustomText("please enter secret", 
    fontSize: 14, fontWeight: w_400);

  @override
  // TODO: implement content
  Widget? get content => CustomTextField(
    controller: controller,
    hintText: "please enter secret",
    hintTextStyle: AppStyles.f15w400c193_192_201.copyWith(
      fontSize: 14
    ),
    style: AppStyles.f14w400c0_0_0
  ).container(
    height: 40,
    padding: EdgeInsets.symmetric(horizontal: 8),
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(10)
    )
  );

  @override
  // TODO: implement actions
  List<Widget>? get actions => [
    CustomText("cancel").container(
      color: Colors.transparent,
      width: 60
    ).gestureDetector(onTap: cancel),
    CustomText("confirm").container(
        color: Colors.transparent,
        width: 60
    ).gestureDetector(onTap: ()=> confirm(controller.text))
  ];

  @override
  // TODO: implement actionsPadding
  EdgeInsetsGeometry get actionsPadding => EdgeInsets.symmetric(horizontal: 8);
}

// class _AvatarItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(
//       height: 24,
//       width: 24,
//       decoration: BoxDecoration(
//         color: AppColors.c228_228_228,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppColors.c255_255_255,
//           width: 0.6
//         ),
//         boxShadow: [
//           BoxShadow(
//             spreadRadius: 0.3,
//             color: AppColors.c106_69_255
//           )
//         ]
//       )
//     );
//   }
// }