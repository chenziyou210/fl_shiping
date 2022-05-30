/*
 *  Copyright (C), 2015-2021
 *  FileName: rank_page_base
 *  Author: Tonight丶相拥
 *  Date: 2021/12/8
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/rank_new_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:httpplugin/httpplugin.dart';
import 'rank_page_base_logic.dart';


class RankPageState<T extends StatefulWidget> extends AppStateBase<T> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late final TabController _tabController;

  List<String> get _lst => [
    intl.daily,
    intl.weekly,
    intl.monthly
  ];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return body;
  }

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  // @override
  // // TODO: implement appBar
  // PreferredSizeWidget? get appBar => DefaultAppBar(
  //     leading: SizedBox(),
  //     automaticallyImplyLeading: false,
  //     backgroundColor: Colors.transparent
  // );

  Widget indexWidget(int index){
    return SizedBox();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => SpecialAppBar([
      CustomBackButton(
        iconColor: Colors.white,
        alignment: Alignment.bottomLeft,
      )
    ]);

  @override
  // TODO: implement body
  Widget get body => Stack(
      children: [
        Container(),
        Positioned.fill(child: TabBarView(children: _lst.map((e) {
          int index = _lst.indexOf(e) + 1;
          return indexWidget(index);
        }).toList()
            , controller: _tabController)),
        CustomTabBar(
          tabs: (_)=> _lst.map((e) => Container(
              alignment: Alignment.bottomCenter,
              color: Colors.transparent,
              width: 95.pt,
              height: 40.pt,
              child: CustomText("$e")
          )).toList(),
          controller: _tabController,
          isScrollable: true,
          labelStyle: TextStyle(
            fontSize: 22.pt,
            fontWeight: w_600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.pt,
            fontWeight: w_400,
          ),
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          decoration: UnderlineTabLinearGradientIndicatorCustom(
              width: 25.pt,
              gradient: LinearGradient(colors: AppColors.buttonGradientColors)
          ),
          labelPadding: EdgeInsets.zero,
        ).padding(padding: EdgeInsets.symmetric(horizontal: 16))
      ]
  );
}


class RankPageStateBase<T extends StatefulWidget, T1 extends RankPageBaseLogic> extends AppStateBase<T>
    with AutomaticKeepAliveClientMixin, Toast {

  late final T1 controller;

  late final bool isAnchor;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(controller, tag: controller.type.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<T1>(tag: controller.type.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return body;
  }

  @override
  // TODO: implement body
  Widget get body => Stack(
    children: [
      Container(),
      Stack(
        children: [
          Image.asset(AppImages.rankBackground,
              width: this.width,
              height: 440.pt,
              fit: BoxFit.fill),
          Obx((){
            if (controller.data.length >= 2)
              return RankItem(bottom: 170.pt,
                  entity: controller.data[1],
                  image: AppImages.rankSecond,
                  left: 8.pt,
                  isAnchor: this.isAnchor,
                  onAttention: (){
                    _toggleAttentionAtIndex(1);
                  });
            return SizedBox();
          }),
          Obx((){
            if (controller.data.length >= 1)
              return RankItem(bottom: 210.pt,
                  entity: controller.data[0],
                  image: AppImages.rankFirst,
                  left: 140.pt,
                  isAnchor: this.isAnchor,
                  onAttention: (){
                    _toggleAttentionAtIndex(0);
                  });
            return SizedBox();
          }),
          Obx((){
            if (controller.data.length >= 3)
              return RankItem(bottom: 140.pt,
                  entity: controller.data[2],
                  image: AppImages.rankThird,
                  left: 260.pt,
                  isAnchor: this.isAnchor,
                  onAttention: (){
                    _toggleAttentionAtIndex(2);
                  });
            return SizedBox();
          })
        ]
      ),
      Positioned.fill(child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: RefreshWidget(
          onRefresh: (c) async{
            await controller.dataRefresh();
            c.refreshCompleted();
            c.resetNoData();
          },
          onLoading: (c) async{
            await controller.loadMore();
            if (controller.hasMoreData) 
              c.loadComplete();
            else 
              c.loadNoData();
          },
          enablePullUp: true,
          children: [
            Obx((){
              var values = controller.state.data as List;
              return SliverList(delegate: SliverChildBuilderDelegate((_, index) {
                var model = values[index + 3] as RankNewEntity;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      CustomText("${index + 4}", fontSize: 14.pt,
                       fontWeight: w_600,
                       color: Color.fromARGB(255, 48, 48, 48)
                      ),
                      SizedBox(width: 16),
                      if (model.header != null && model.header!.startsWith("http"))
                        ExtendedImage.network(model.header!,
                          width: 38.pt, 
                          enableLoadState: false,
                          height: 38.pt, fit: BoxFit.fill).clipRRect(
                          radius: BorderRadius.circular(19.pt)
                        )
                      else 
                        SizedBox(width: 38.pt, height: 38.pt),
                      SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          [CustomText("${model.username}",
                            fontSize: 16.pt,
                            fontWeight: w_500,
                            color: Color.fromARGB(255, 34, 40, 49)
                          ),
                          SizedBox(width: 4),
                          Image.asset(AppImages.gradeList + "${model.rank}.png",
                            width: 29.pt,
                            height: 14.pt,
                            fit: BoxFit.fill
                          )].row(),
                          SizedBox(height: 8),
                          CustomText("ID: ${model.memberid}",
                            fontSize: 12.pt,
                            fontWeight: w_500,
                            overflow: TextOverflow.ellipsis,
                            color: Color.fromARGB(255, 170, 164, 164)
                          )
                        ]
                      ).expanded(),
                      if (isAnchor)
                        _AttentionButton(intl, () {
                          _toggleAttentionAtIndex(index + 3);
                        }, model.attention ?? false,
                          color: Color.fromARGB(255, 170, 164, 164)
                        )
                    ]
                  ),
                  height: 76
                );
              }, childCount: values.length <= 3 ? 0 : values.length - 3));
            })
          ]
        ),
      ), top: 444.pt - 89.pt)
    ]
  );

  void _toggleAttentionAtIndex(int index){
    show();
    Future<HttpResultContainer> future;
    var id = controller.data[index].userId!;
    if (controller.isAttentionAtIndex(index)) {
      future = HttpChannel.channel.favoriteCancel(id);
    }else {
      future = HttpChannel.channel.favoriteInsert(id);
    }
    future.then((value) => value.finalize(
      wrapper: WrapperModel(),
      failure: (e)=> showToast(e),
      success: (_) {
        dismiss();
        controller.toggleAttentionAtIndex(index);
      }
    ));
  }
}


class RankItem extends StatelessWidget {
  RankItem({
    required this.bottom,
    required this.entity,
    required this.image,
    required this.left,
    required this.onAttention,
    required this.isAnchor
  });
  final double bottom;
  final double left;
  final String image;
  final RankNewEntity entity;
  final bool isAnchor;
  final VoidCallback onAttention;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var intl = AppInternational.of(context);
    return Positioned(
      child: Column(
        children: [
          if (isAnchor)
            _AttentionButton(intl, onAttention, entity.attention ?? false),
          Stack(
            alignment: Alignment.center,
            children: [
              if (entity.header != null && entity.header!.startsWith("http"))
                ExtendedImage.network(entity.header!,
                  enableLoadState: false,
                  width: 65.pt, height: 65.pt).clipRRect(
                  radius: BorderRadius.circular(32.5.pt)
                ),
              Image.asset(image, width: 106.pt,
                height: 105.pt,
                fit: BoxFit.fill
              ),
            ]
          ),
          Row(
            children: [
              CustomText("${entity.username}",
                fontSize: 12.pt,
                fontWeight: w_500,
                color: Colors.white
              ),
              SizedBox(width: 4),
              Image.asset(AppImages.gradeList + "${entity.rank}.png",
                width: 29.pt,
                height: 14.pt,
                fit: BoxFit.fill
              )
            ]
          ),
          CustomText("${isAnchor ?
            intl.obtain : intl.contribution}: ${entity.totalValue}",
            fontWeight: w_500,
            color: Colors.white,
            fontSize: 14.pt
          )
        ]
      ),
      bottom: bottom,
      left: left
    );
  }
}

class _AttentionButton extends StatelessWidget {
  _AttentionButton(this.intl, this.onAttention, this.attention, {
    this.color
  });
  final AppInternational intl;
  final VoidCallback onAttention;
  final bool attention;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onAttention,
        child: Container(
            width: 60.pt,
            height: 28.pt,
            decoration: BoxDecoration(
                border: Border.all(
                    color: !attention ? Colors.white : (color ?? Colors.white)
                ),
                borderRadius: BorderRadius.circular(14.pt),
                gradient: attention ? null : LinearGradient(colors: AppColors.buttonGradientColors)
            ),
            alignment: Alignment.center,
            child: CustomText("${attention ?
            intl.followed : intl.following}",
              fontWeight: w_500,
              fontSize: 14.pt,
              color: !attention ? Colors.white : (color ?? Colors.white)
            )
        )
    );
  }
}