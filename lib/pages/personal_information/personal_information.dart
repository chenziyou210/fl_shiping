/*
 *  Copyright (C), 2015-2021
 *  FileName: personal_information
 *  Author: Tonight丶相拥
 *  Date: 2021/7/15
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/index_rank_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/component_widget/level_widget.dart';
import 'package:hjnzb/util_tool/util_tool.dart';
import 'package:provider/provider.dart';

class PersonalInformation extends StatefulWidget {

  @override
  createState() => PersonalInformationState<PersonalInformation>();
}

class PersonalInformationState<T extends StatefulWidget> extends AppStateBase<T> {

  final bool showToolBar = true;

  String get id => AppManager.getInstance<AppUser>().userId ?? "";

  late Future _future;
  List<IndexRankEntity> _entities = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = HttpChannel.channel.anchorContributionList(id, 1)..then((value) =>
      value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data["data"] ?? [];
          _entities = lst.map((e) => IndexRankEntity.fromJson(e)).toList();
        }
      ));
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    backwardsCompatibility: false,
    leading: CustomBackButton(
      icon: Image.asset(AppImages.backIconWhite)
    ),
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    actions: actions
  );

  List<Widget>? get actions => [
    if (showToolBar)
      Padding(
          padding: EdgeInsets.only(right: 8),
          child: Center(
              child: GestureDetector(
                  onTap: (){
                    // customShowModalBottomSheet(context: context, builder: (_) {
                    //   return Container(
                    //     height: 100,
                    //     color: Colors.black.withOpacity(0.01),
                    //     child: CustomText("say hi", fontSize: 14,
                    //         fontWeight: w_400, color: Colors.orange,).center.gestureDetector(
                    //         onTap: (){
                    //           print(44444444444);
                    //           customShowModalBottomSheet(context: context, builder: (_) {
                    //             return Container(
                    //               height: 600,
                    //               color: Colors.red.withOpacity(0.01),
                    //               child: CustomText("say hi1", fontSize: 14,
                    //                 fontWeight: w_400, color: Colors.orange,).padding(padding: EdgeInsets.all(20)).center.gestureDetector(
                    //                   onTap: (){
                    //
                    //                   }
                    //               ),
                    //             );
                    //           }, fixedOffsetHeight: 600,isScrollControlled: false,
                    //               barrierColor: Colors.transparent);
                    //         }
                    //     ),
                    //   );
                    // }, fixedOffsetHeight: 100,isScrollControlled: false,
                    //     barrierColor: Colors.transparent);

                    var user = AppManager.getInstance<AppUser>();
                    pushViewControllerWithName(AppRoutes.editPersonalInformation,
                        arguments: user.toJson()).then((value) {
                      if (value != null && value is Map<String, dynamic>) {
                        user.updateData(value);
                      }
                    });
                  },
                  child: Image.asset(AppImages.personalEdit)
              )
          ))
  ];

  @override
  // TODO: implement body
  Widget get body => Consumer<AppUser>(builder: (_, viewModel, __) {
    return view;
  });

  get viewModel => AppManager.getInstance<AppUser>();

  Widget get view {
    String? avatar = viewModel.header;
    bool backgroundIsNull = avatar == null || avatar.replaceAll(" ", "").isEmpty;
    return Stack(
        children: [
          Positioned(
              child: backgroundIsNull ? Image.asset(AppImages.personalPlaceHolder,
                  fit: BoxFit.cover) : ExtendedImage.network(avatar, fit:
              BoxFit.cover, enableLoadState: false),
              left: 0, right: 0, top: 0,
              height: 375
          ),
          Positioned(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.c0_0_0.withOpacity(0.5),
                      AppColors.c0_0_0.withOpacity(0),
                      AppColors.c0_0_0.withOpacity(0.5)
                    ], begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                    )
                ),
              ),
              left: 0, right: 0, top: 0,
              height: 375
          ),
          Positioned.fill(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("${viewModel.name}", style: AppStyles.f22w500c255_255_255,),
                ),
                SizedBox(height: 7),
                Row(
                    children: [
                      SizedBox(width: 15),
                      LevelWidget(AppImages.vipBackground, viewModel.rank ?? 0),
                      SizedBox(width: 8),
                      Container(
                          height: 15,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              color: AppColors.c252_103_250,
                              borderRadius: BorderRadius.circular(7.5)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Builder(builder: (_) {
                                  String constellation = "";
                                  if(viewModel.birthday != null) {
                                    constellation = getConstellation(DateTime.parse(viewModel.birthday), intl);
                                  }
                                  return Text("$constellation", style: AppStyles.f10w400c255_255_255);
                                })
                              ]
                          )
                      )
                    ]
                ),
                SizedBox(height: 18),
                Expanded(child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.c255_255_255,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 15
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Row(
                              children: [
                                Text(intl.following, style: AppStyles.f12w400c0_0_0.copyWith(
                                    color: AppColors.c0_0_0.withOpacity(0.6)
                                )),
                                SizedBox(width: 8),
                                Text("${viewModel.attentionNum}", style: AppStyles.f18w400c0_0_0),
                                SizedBox(width: 35),
                                Text(intl.followers, style: AppStyles.f12w400c0_0_0.copyWith(
                                    color: AppColors.c0_0_0.withOpacity(0.6)
                                )),
                                SizedBox(width: 8),
                                Text("${viewModel.fansNum}", style: AppStyles.f18w400c0_0_0)
                              ]
                          ),
                          SizedBox(height: 24),
                          // Container(
                          //     height: 60,
                          //     decoration: BoxDecoration(
                          //         color: AppColors.c255_71_182.withOpacity(0.06),
                          //         borderRadius: BorderRadius.circular(6)
                          //     ),
                          //     padding: EdgeInsets.symmetric(horizontal: 12),
                          //     child: Row(
                          //         children: [
                          //           Expanded(
                          //               child: Text(intl.contributionList,
                          //                   style: AppStyles.f16w500c165_59_227)),
                          //           SizedBox(width: 8),
                          //           InkWell(
                          //               onTap: (){
                          //                 pushViewControllerWithName(AppRoutes.totalList, arguments: {
                          //                   "id": id
                          //                 });
                          //               },
                          //               child: Row(
                          //                   children: [
                          //                     LoadingWidget(builder: (_, __) {
                          //                       if (_entities.length == 0)
                          //                         return Text(intl.noGift, style: AppStyles.f14w400c165_59_227);
                          //                       else {
                          //                         if (_entities.length > 3) {
                          //                           return Row(
                          //                               children: _entities.getRange(0, 3)
                          //                                 .map((e) => ExtendedImage.network(e.header ?? "",
                          //                                   height: 30, width: 30, enableLoadState: false)
                          //                                 .padding(padding: EdgeInsets.only(right: 10)))
                          //                                 .toList()
                          //                           );
                          //                         }else {
                          //                           return Row(
                          //                               children: _entities.getRange(0, _entities.length)
                          //                                 .map((e) => ExtendedImage.network(e.header ?? "",
                          //                                 height: 40, width: 40, fit: BoxFit.cover, enableLoadState: false)
                          //                                 .clipRRect(radius: BorderRadius.circular(20))
                          //                                 .padding(padding: EdgeInsets.only(right: 10)))
                          //                                 .toList()
                          //                           );
                          //                         }
                          //                       }
                          //                     },
                          //                       future: _future),
                          //                     SizedBox(width: 10),
                          //                     Image.asset(AppImages.giftForward)
                          //                   ]
                          //               )
                          //           )
                          //         ]
                          //     )
                          // ),
                          SizedBox(
                            height: 20
                          ),
                          Text(intl.personalInformation, style: AppStyles.f16w500c0_0_0),
                          SizedBox(
                              height: 20
                          ),
                          Expanded(child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Table(
                                        columnWidths: {
                                          0: IntrinsicColumnWidth(),
                                          1: FlexColumnWidth()
                                        },
                                        children: [
                                          TableRow(
                                              children: [
                                                Row(
                                                    children: [
                                                      Image.asset(AppImages.member),
                                                      SizedBox(width: 4),
                                                      Text(intl.memberID + "：", style: AppStyles.f14w400c141_141_141)
                                                    ]
                                                ),
                                                Row(
                                                    children: [
                                                      Text("${viewModel.memberId}", style: AppStyles.f14w400c0_0_0),
                                                      SizedBox(width: 4),
                                                      GestureDetector(
                                                          onTap: (){
                                                            Clipboard.setData(ClipboardData(text: viewModel.memberId));
                                                          },
                                                          child: Image.asset(AppImages.idCopy)
                                                      )
                                                    ]
                                                )
                                              ]
                                          ),
                                          TableRowMargin(2, 13),
                                          TableRow(
                                              children: [
                                                Row(
                                                    children: [
                                                      Image.asset(AppImages.profession),
                                                      SizedBox(width: 4),
                                                      Text(intl.profession + "：  ", style: AppStyles.f14w400c141_141_141)
                                                    ]
                                                ),
                                                Text("${viewModel.profession}", style: AppStyles.f14w400c0_0_0)
                                              ]
                                          ),
                                          TableRowMargin(2, 13),
                                          TableRow(
                                              children: [
                                                Row(
                                                    children: [
                                                      Image.asset(AppImages.constellation),
                                                      SizedBox(width: 4),
                                                      Text(intl.constellation + "：  ", style: AppStyles.f14w400c141_141_141)
                                                    ]
                                                ),
                                                Builder(builder: (_) {
                                                  String constellation = "";
                                                  if(viewModel.birthday != null) {
                                                    constellation = getConstellation(DateTime.parse(viewModel.birthday), intl);
                                                  }
                                                  return Text("$constellation", style: AppStyles.f14w400c0_0_0);
                                                })
                                              ]
                                          ),
                                          TableRowMargin(2, 13),
                                          TableRow(
                                              children: [
                                                Row(
                                                    children: [
                                                      Image.asset(AppImages.homeTown),
                                                      SizedBox(width: 4),
                                                      Text(intl.homeTown + "：  ", style: AppStyles.f14w400c141_141_141)
                                                    ]),
                                                Text("${viewModel.hometown}", style: AppStyles.f14w400c0_0_0)
                                              ]
                                          ),
                                          TableRowMargin(2, 13),
                                          TableRow(
                                              children: [
                                                Row(
                                                    children: [
                                                      Image.asset(AppImages.feeling),
                                                      SizedBox(width: 4),
                                                      Text(intl.feeling + "：  ", style: AppStyles.f14w400c141_141_141)
                                                    ]),
                                                Text("${viewModel.feeling}", style: AppStyles.f14w400c0_0_0)
                                              ]
                                          ),
                                          TableRowMargin(2, 13),
                                          TableRow(
                                              children: [
                                                Row(
                                                    children: [
                                                      Image.asset(AppImages.signature),
                                                      SizedBox(width: 4),
                                                      Text(intl.signature + "：  ", style: AppStyles.f14w400c141_141_141)
                                                    ]),
                                                Text("${viewModel.signature ?? "Forgot to sign"}", style: AppStyles.f14w400c0_0_0)
                                              ]
                                          )
                                        ]
                                    ),
                                    SizedBox(height: 25),
                                    Text(intl.otherInformation, style: AppStyles.f16w500c0_0_0),
                                    SizedBox(height: 16),
                                    Row(
                                        children: [
                                          Expanded(child: Column(
                                              children: [
                                                Text("${viewModel.sendOut ?? 0}", style: AppStyles.f18w400c0_0_0),
                                                SizedBox(height: 4),
                                                Text(intl.sendOut, style: AppStyles.f12w400c0_0_0.copyWith(
                                                    color: AppColors.c0_0_0.withOpacity(0.6)
                                                ))
                                              ]
                                          )),
                                          Expanded(child: Column(
                                              children: [
                                                // todo: viewModel.rogerThat ?? 0
                                                Text("${viewModel.reward ?? 0}", style: AppStyles.f18w400c0_0_0),
                                                SizedBox(height: 4),
                                                Text(intl.rogerThat, style: AppStyles.f12w400c0_0_0.copyWith(
                                                    color: AppColors.c0_0_0.withOpacity(0.6)
                                                ))
                                              ]
                                          ))
                                        ]
                                    ),
                                    SizedBox(height: 16)
                                  ]
                              )
                          ))
                        ]
                    )
                )),
                Offstage(
                    offstage: showToolBar,
                    child: Column(
                        children: [
                          SizedBox(height: 30),
                          Container(
                              height: 1,
                              color: AppColors.c0_0_0.withOpacity(0.1),
                              width: double.infinity
                          ),
                          SizedBox(height: 15),
                          Row(
                              children: [
                                Expanded(child: GestureDetector(
                                    onTap: sayHi,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(AppImages.sayHi),
                                          SizedBox(width: 4),
                                          Text(intl.sayHi, style: AppStyles.f16w400c0_0_0.copyWith(
                                              color: AppColors.c0_0_0.withOpacity(0.8)
                                          ))
                                        ]
                                    )
                                ), flex: 10),
                                Container(
                                    width: 1,
                                    height: 18,
                                    color: AppColors.c0_0_0.withOpacity(0.1)
                                ),
                                Expanded(child: GestureDetector(
                                    onTap: message,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(AppImages.message),
                                          SizedBox(width: 4),
                                          Text(intl.message, style: AppStyles.f16w400c0_0_0.copyWith(
                                              color: AppColors.c0_0_0.withOpacity(0.8)
                                          ))
                                        ]
                                    )
                                ), flex: 11),
                                Container(
                                    width: 1,
                                    height: 18,
                                    color: AppColors.c0_0_0.withOpacity(0.1)
                                ),
                                Expanded(child: GestureDetector(
                                    onTap: attention,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: attentionWidget
                                    )
                                ), flex: 10)
                              ]
                          )
                        ]
                    )
                )
              ]
          ), top: 285)
        ]
    );
  }

  Widget get attentionWidget => Text("+${intl.attention}", style: AppStyles.f16w400c165_59_227);

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c255_255_255;

  void sayHi(){

  }

  void message(){

  }

  void attention(){

  }
}