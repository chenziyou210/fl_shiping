/*
 *  Copyright (C), 2015-2021
 *  FileName: anchor_rank_page
 *  Author: Tonight丶相拥
 *  Date: 2021/12/8
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'rank_page_base.dart';
import 'anchor_rank_logic.dart';


class AnchorRankPage extends StatefulWidget {
  @override
  createState() => _AnchorRankPageState();
}

class _AnchorRankPageState extends RankPageState<AnchorRankPage>{

  @override
  Widget indexWidget(int index) {
    // TODO: implement indexWidget
    return _AnchorRank(index);
  }
}


class _AnchorRank extends StatefulWidget {
  _AnchorRank(this.type);
  final int type;
  @override
  createState()=> _AnchorRankState(type);
}

class _AnchorRankState extends RankPageStateBase<_AnchorRank, AnchorRankLogic> {

  _AnchorRankState(int type) : controller = AnchorRankLogic(type);
  @override
  final AnchorRankLogic controller;

  @override
  // TODO: implement isAnchor
  bool get isAnchor => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.dataRefresh();
  }
}