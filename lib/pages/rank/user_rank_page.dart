/*
 *  Copyright (C), 2015-2021
 *  FileName: user_rank_page
 *  Author: Tonight丶相拥
 *  Date: 2021/12/8
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'rank_page_base.dart';
import 'user_rank_logic.dart';


class UserRankPage extends StatefulWidget {
  @override
  createState() => _UserRankPageState();
}

class _UserRankPageState extends RankPageState<UserRankPage>{

  @override
  Widget indexWidget(int index) {
    // TODO: implement indexWidget
    return _UserRank(index);
  }
}


class _UserRank extends StatefulWidget {
  _UserRank(this.type);
  final int type;
  @override
  createState()=> _UserRankState(type);
}

class _UserRankState extends RankPageStateBase<_UserRank, UserRankLogic> {

  _UserRankState(int type) : controller = UserRankLogic(type);
  @override
  final UserRankLogic controller;

  @override
  // TODO: implement isAnchor
  bool get isAnchor => false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.dataRefresh();
  }
}