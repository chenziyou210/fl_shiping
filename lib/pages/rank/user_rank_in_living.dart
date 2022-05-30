/*
 *  Copyright (C), 2015-2021
 *  FileName: user_rank_in_living
 *  Author: Tonight丶相拥
 *  Date: 2021/12/20
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'rank_page_base.dart';
import 'user_rank_in_living_logic.dart';


class UserRankInLivingPage extends StatefulWidget {
  UserRankInLivingPage({dynamic arguments}): this.anchorId = arguments["id"];
  final String anchorId;
  @override
  createState() => _UserRankInLivingState(this.anchorId);
}

// class _UserRankInLivingPageState extends RankPageState<UserRankInLivingPage>{
//
//   @override
//   Widget indexWidget(int index) {
//     // TODO: implement indexWidget
//     return _UserRankInLiving(index);
//   }
// }
//
//
// class _UserRankInLiving extends StatefulWidget {
//   _UserRankInLiving(this.type);
//   final int type;
//   @override
//   createState()=> _UserRankInLivingState(type);
// }

class _UserRankInLivingState extends RankPageStateBase<UserRankInLivingPage, UserRankInLivingLogic> {

  _UserRankInLivingState(String type) : controller = UserRankInLivingLogic(type);
  @override
  final UserRankInLivingLogic controller;

  @override
  // TODO: implement isAnchor
  bool get isAnchor => false;

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.contributionList}",
      fontWeight: w_400,
      color: Color.fromARGB(255, 49, 49, 49),
      fontSize: 15.pt
    ),
  );

  // @override
  // // TODO: implement extendBodyBehindAppBar
  // bool get extendBodyBehindAppBar => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.dataRefresh();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return scaffold;
  }
}