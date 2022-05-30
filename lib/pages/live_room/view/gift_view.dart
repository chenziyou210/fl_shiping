/*
 *  Copyright (C), 2015-2021
 *  FileName: gift_view
 *  Author: Tonight丶相拥
 *  Date: 2021/9/15
 *  Description: 
 **/

// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'gift_card/gift_card.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/generated/gift_entity.dart';
// import 'package:extended_image/extended_image.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class GiftView extends StatefulWidget {
  GiftView({required this.gifts});
  final List<GiftEntity> gifts;
  @override
  createState()=> _GiftViewState();
}

class _GiftViewState extends AppStateBase<GiftView> with AutomaticKeepAliveClientMixin {

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  /// 页码控制器
  final PageController _controller = PageController();

  /// 礼物坐标
  GiftIndex _index = GiftIndex();
  /// 数量
  int _number = 1;
  bool _offstage = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Stack(
      children: [
        Container(
            height: 360,
            // decoration: BoxDecoration(
            //     color: Color.fromARGB(255, 21, 23, 35),
            //     borderRadius: BorderRadius.vertical(top: Radius.circular(8))
            // ),
            width: double.infinity,
            child: widget.gifts.length == 0 ? Container(
              child: Center(
                  child: Text("", style: AppStyles.f14w400c255_255_255)
              ),
            ) : Column(
                children: [
                  SizedBox(height: 8),
                  Expanded(
                      child: PageView.builder(
                          itemCount: widget.gifts.length % 8 != 0 ?
                          (widget.gifts.length ~/ 8 + 1)
                              : widget.gifts.length ~/ 8,
                          itemBuilder: (_, int page) {
                            List<GiftEntity> data = (page + 1) * 8 > widget.gifts.length ?
                            widget.gifts.getRange(page * 8, widget.gifts.length).toList()
                                : widget.gifts.getRange(page * 8, (page + 1) * 8).toList();
                            // var e = widget.gifts[index];
                            return GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    mainAxisExtent: 113
                                ),
                                itemBuilder: (_, index) {
                                  Widget widget = GiftCard(data[index]);
                                  if (page == _index.page && index == _index.index) {
                                    widget = Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(255, 31, 34, 51).withOpacity(0.5)
                                      ),
                                      child: widget,
                                    );
                                    widget = CustomGradientBorderContainer(
                                      child: widget,
                                      strokeWidth: 0.5,
                                      radius: 10,
                                      gradient: LinearGradient(colors: AppColors.buttonGradientColors),
                                    );
                                    widget = CustomGradientBorderContainer(
                                      child: widget,
                                      strokeWidth: 0.5,
                                      radius: 10,
                                      gradient: LinearGradient(colors: AppColors.buttonGradientColors),
                                    );
                                  }else {
                                    widget = GestureDetector(
                                        child: widget,
                                        onTap: (){
                                          _index.setLocation(page, index);
                                          unFocus();
                                          setState(() {});
                                        }
                                    );
                                  }
                                  return widget;
                                }, //physics: NeverScrollableScrollPhysics(),
                                itemCount: data.length
                            );
                          }, controller: _controller)),
                  SizedBox(height: 8),
                  DotsIndicatorNormal(controller: _controller,
                      unSelectColor: Colors.red,
                      onPageSelected: (index) {
                        _controller.animateToPage(index, duration: Duration(
                            milliseconds: 100
                        ), curve: Curves.easeIn);
                      },
                      itemCount: widget.gifts.length % 8 != 0 ? (widget.gifts.length ~/ 8 + 1)
                          : widget.gifts.length ~/ 8),
                  SizedBox(height: 8),
                  SizedBox(
                    child: Row(
                        children: [
                          SizedBox(width: 8),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectorCustom<AppUser, double?>(builder: (value) {
                                  return Text.rich(TextSpan(
                                      text: intl.diamond,
                                      style: AppStyles.f15w500c255_255_255,
                                      children: [
                                        TextSpan(
                                            text: ": ${value ?? 0}",
                                            style: AppStyles.f15w500c255_199_0
                                        )
                                      ]
                                  ));
                                }, selector: (a) => a.lockMoney),
                                SizedBox(height: 4),
                                SelectorCustom<AppUser, double?>(builder: (value) {
                                  return Text.rich(TextSpan(
                                      text: intl.balance,
                                      style: AppStyles.f15w500c255_255_255,
                                      children: [
                                        TextSpan(
                                            text: ": ${value ?? 0}",
                                            style: AppStyles.f15w500c255_199_0
                                        )
                                      ]
                                  ));
                                }, selector: (a) => a.coins)
                              ]
                          ),
                          Spacer(),
                          SelectorCustom<SettingViewModel, bool>(
                              builder: (value) {
                                if (value)
                                  return SizedBox();
                                return Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: AppColors.c255_225_0
                                      )
                                  ),
                                  child: CustomText("${intl.recharge} >",
                                      style: AppStyles.f14w400c255_255_255),
                                )
                                    .gestureDetector(onTap: (){
                                  pushViewControllerWithName(AppRoutes.chargePage);
                                });
                              },
                              selector: (s) => s.isSameVersion),
                          Spacer(),
                          CustomGradientBorderContainer(gradient: LinearGradient(colors: AppColors.buttonGradientColors),
                            strokeWidth: 1,
                            radius: 20,
                            child: Container(
                              height: 40,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: AppColors.c0_0_0.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                  // border: Border.all(
                                  //     color: AppColors.c106_69_255
                                  // )
                              ),
                              child: Row(
                                  children: [
                                    Expanded(child: InkWell(
                                        onTap: (){
                                          _offstage = !_offstage;
                                          setState(() {});
                                        },
                                        child: Row(
                                            children: [
                                              SizedBox(width: 12),
                                              Text("$_number", style: AppStyles.f14w400c255_255_255,
                                                  overflow: TextOverflow.ellipsis),
                                              SizedBox(width: 4),
                                              Image.asset(AppImages.dropDown)
                                            ]
                                        )
                                    )),
                                    GestureDetector(
                                        onTap: (){
                                          if (!_index.isZero()) {
                                            popViewController();
                                            return;
                                          }
                                          var model = widget.gifts[_index.page * 8 + _index.index];
                                          popViewController(GiftModel(model.id!, "$_number", model.name!, 1));
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 40,
                                          margin: EdgeInsets.symmetric(vertical: 3) + EdgeInsets.only(right: 3),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: AppColors.buttonGradientColors),
                                              // color: AppColors.c252_103_250,
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Text(intl.giving, style: AppStyles.f14w400c255_255_255),
                                        )
                                    )
                                  ]
                              )
                          )),
                          SizedBox(width: 8)
                        ]
                    ),
                  ),
                  SizedBox(height: 8)
                ]
            )
        ),
        Positioned(child: Offstage(
          offstage: _offstage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _gift.map((e) => Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText("${e.number}",
                        fontSize: 12,
                        fontWeight: w_400,
                        color: Colors.white,
                      ).sizedBox(width: 30),
                      SizedBox(width: 16),
                      CustomText("${e.description}",
                          fontSize: 12,
                          fontWeight: w_400,
                          color: Color.fromARGB(255, 255, 89, 95)
                      )
                    ]
                )
            ).cupertinoButton(onTap: (){
              _offstage = !_offstage;
              _number = e.number;
              setState(() {});
            }, miniSize: 30)).toList(),
          ).singleScrollView().container(
            // width: 100,
            decoration: ShapeDecoration(
              color: Color.fromARGB(255, 57, 61, 81),
              shape: BottomTriangleBorder(
                offsetX: 40,
                borderRadius: BorderRadius.circular(7),
                triangleWidth: 20,
                fillColor: Color.fromARGB(255, 57, 61, 81)
              )
            ),
            height: 175
          ),
        ), right: 8, bottom: 92)
        // Positioned(child: Offstage(
        //   offstage: _offstage,
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 8),
        //     child: AnimatedPaddingTextFiled(
        //       controller: _txtController,
        //       node: _node,
        //       action: TextInputAction.done,
        //       style: AppStyles.f14w400c0_0_0,
        //       onChange: (value) {
        //         _number = int.tryParse(value) ?? 1;
        //       },
        //       onSubmit: (value){
        //         _number = int.tryParse(value) ?? 1;
        //         _offstage = true;
        //         setState(() {});
        //       },
        //       formatter: [
        //         OnlyInputInt(),
        //         FilteringTextInputFormatter.digitsOnly
        //       ]
        //     )
        //   )
        // ), left: 0, right: 0, bottom: 0)
      ]
    );
  }


  /*
  *   String get inAllOnesLife => "一生一世";
  String get iLoveYou => "我爱你";
  String get wantToHug => "要抱抱";
  String get sixSixLucky => "六六大顺";
  String get perfect => "十全十美";
  String get undividedAttention => "一心一意";*/
  List<GiftDescriptionEntity> get _gift => [
    GiftDescriptionEntity(1314, "${intl.inAllOnesLife}"),
    GiftDescriptionEntity(520, "${intl.iLoveYou}"),
    GiftDescriptionEntity(188, "${intl.wantToHug}"),
    GiftDescriptionEntity(66, "${intl.sixSixLucky}"),
    GiftDescriptionEntity(10, "${intl.perfect}"),
    GiftDescriptionEntity(1, "${intl.undividedAttention}")
  ];
}