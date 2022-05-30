/*
 *  Copyright (C), 2015-2021
 *  FileName: rank_integration
 *  Author: Tonight丶相拥
 *  Date: 2021/12/21
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'user_rank_page.dart';
import 'anchor_rank_page.dart';

class RankIntegrationPage extends StatefulWidget {
  @override
  createState()=> _RankIntegrationPageState();
}

class _RankIntegrationPageState extends AppStateBase<RankIntegrationPage> with SingleTickerProviderStateMixin {

  late final TabController _controller;
  final _RankLogic _logic = _RankLogic();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    leadingWidth: 30,
    title: Obx((){
      bool isFirst = _logic.select[0];
      return ToggleButtons(children: [
        Container(
          width: 152.pt,
          height: 34.pt,
          decoration: BoxDecoration(
            gradient: isFirst ? LinearGradient(
              colors: AppColors.buttonGradientColors,
              begin: Alignment.centerRight,
              end: Alignment.centerLeft
            ) : null,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
            border: isFirst ? null : Border.all(color: Colors.black12)
          ),
          alignment: Alignment.center,
          child: CustomText("${intl.starList}",
            fontSize: 15.pt, fontWeight: w_400,
            color: isFirst ? Colors.white : Color.fromARGB(255, 49, 49, 49)
          )
        ),
        Container(
            width: 152.pt,
            height: 34.pt,
            decoration: BoxDecoration(
                gradient: !isFirst ? LinearGradient(
                    colors: AppColors.buttonGradientColors
                ) : null,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                border: !isFirst ? null : Border.all(color: Colors.black12)
            ),
            alignment: Alignment.center,
            child: CustomText("${intl.richList}",
                fontSize: 15.pt, fontWeight: w_400,
                color: !isFirst ? Colors.white : Color.fromARGB(255, 49, 49, 49)
            )
        )
      ], isSelected: _logic.select,
          renderBorder: false,
          fillColor: Colors.transparent,
          splashColor: Colors.transparent,
          selectedColor: Colors.transparent,
          onPressed: (index) {
            _logic.onTapIndex(index);
            _controller.animateTo(index);
          },
          color: Colors.transparent);
    })
  );

  @override
  // TODO: implement body
  Widget get body => TabBarView(children: [
    AnchorRankPage(),
    UserRankPage()
  ], controller: _controller);
}

class _RankLogic extends GetxController {
  RxList<bool> _select = [true, false].obs;
  RxList<bool> get select => _select;

  void onTapIndex(int index){
    _select.value = List.generate(2, (index) => false);
    _select[index] = true;
  }
}