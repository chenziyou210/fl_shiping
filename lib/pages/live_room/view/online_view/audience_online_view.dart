/*
 *  Copyright (C), 2015-2021
 *  FileName: audience_online_view
 *  Author: Tonight丶相拥
 *  Date: 2021/12/11
 *  Description: 
 **/


import 'package:flutter/material.dart';
import 'online_view.dart';
import 'audience_online_logic.dart';
import 'online_cell.dart';

class AudienceOnlineView extends StatefulWidget {
  AudienceOnlineView(this.anchorId);
  final String anchorId;
  @override
  createState()=> _AudienceOnlineView();
}

class _AudienceOnlineView extends OnlineViewState<AudienceOnlineView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AudienceOnlineLogic()..anchorId = widget.anchorId;
    controller.dataRefresh();
  }

  @override
  Widget cellAtIndex(int index) {
    // TODO: implement cellAtIndex
    return OnlineCell(controller.data[index]);
  }
}