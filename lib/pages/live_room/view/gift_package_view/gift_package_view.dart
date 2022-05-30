/*
 *  Copyright (C), 2015-2022
 *  FileName: gift_package_view
 *  Author: Tonight丶相拥
 *  Date: 2022/4/25
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/pages/live_room/view/gift_view.dart';
import 'package_view.dart';

import '../../../../generated/gift_entity.dart';

class GiftPackageView extends StatefulWidget {
  GiftPackageView({required this.gifts});
  final List<GiftEntity> gifts;
  @override
  createState()=> _PackageViewState();
}

class _PackageViewState extends State<GiftPackageView> with TickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var intl = AppInternational.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 21, 23, 35),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          CustomTabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: (_) => [
              CustomText(intl.gift),
              CustomText(intl.package)
            ],
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: w_500
            ),
            unselectedLabelColor: Color.fromARGB(255, 115, 117, 131),
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: w_500
            ),
            decoration: UnderlineTabLinearGradientIndicatorCustom(
              gradient: LinearGradient(
                colors: AppColors.buttonGradientColors
              )
            )
          ),
          SizedBox(height: 8),
          TabBarView(children: [
            GiftView(gifts: widget.gifts),
            PackageView()
          ], controller: _tabController).expanded()
        ]
      )
    );
  }
}