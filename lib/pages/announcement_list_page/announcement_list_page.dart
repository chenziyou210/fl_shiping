/*
 *  Copyright (C), 2015-2021
 *  FileName: announcement_list_page
 *  Author: Tonight丶相拥
 *  Date: 2021/12/15
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:get/get.dart';
import 'package:hjnzb/util_tool/string_extension.dart';
import 'announcement_list_logic.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  createState()=> _AnnouncementPageState();
}

class _AnnouncementPageState extends AppStateBase<AnnouncementPage> with SingleTickerProviderStateMixin {

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
    _tabController.dispose();
    super.dispose();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.messageCenter}",
      fontSize: 16.pt,
      fontWeight: w_500,
      color: Color.fromARGB(255, 34, 40, 49)
    )
  );

  @override
  // TODO: implement body
  Widget get body => Container(
    child: Column(
      children: [
        Container(
          width: this.width,
          height: 91.pt,
          color: Colors.white,
          child: CustomTabBar(tabs: (_) {
            return [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(AppImages.announcement),
                  SizedBox(height: 4),
                  CustomText("${intl.announcement}"),
                  SizedBox(height: 4)
                ]
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(AppImages.standInsideLetter),
                  SizedBox(height: 4),
                  CustomText("${intl.standInsideLetter}"),
                  SizedBox(height: 4)
                ]
              )
            ];
          }, 
            controller: _tabController,
            labelStyle: TextStyle(
              fontSize: 16.pt,
              fontWeight: w_500,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16.pt,
              fontWeight: w_500,
            ),
            unselectedLabelColor: Colors.black,
            labelColor: Color.fromARGB(255, 244, 559, 148),
            decoration: UnderlineTabLinearGradientIndicatorCustom(
                width: 25.pt,
                isCircle: true,
                gradient: LinearGradient(colors: AppColors.buttonGradientColors)
            ),
            labelPadding: EdgeInsets.zero,
          )
        ),
        SizedBox(height: 8),
        TabBarView(children: [
          _AnnouncementPage(1),
          _AnnouncementPage(2)
        ], controller: _tabController).expanded()
      ]
    )
  );
}

class _AnnouncementPage extends StatefulWidget {
  _AnnouncementPage(this.type);
  final int type;
  @override
  createState()=> _AnnouncementPageState1(type);
}

class _AnnouncementPageState1 extends State<_AnnouncementPage> with Toast, AutomaticKeepAliveClientMixin {
  _AnnouncementPageState1(int type): this._controller = AnnouncementPageLogic(type);
  final AnnouncementPageLogic _controller;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    show();
    _controller.dataRefresh().then((value) {
      if (value) {
        dismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return RefreshWidget(
        // enablePullDown: false,
        onRefresh: (c) async{
          await _controller.dataRefresh();
          c.refreshCompleted();
        },
        children: [
          Obx((){
            if (_controller.data.length == 0) {
              return SliverFillRemaining(
                  child: DataEmptyWidget()
              );
            }
            return SliverList(delegate: SliverChildBuilderDelegate((_, index) {
              var model = _controller.data[index];
              return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 8),
                        Container(
                            alignment: Alignment.center,
                            child: CustomText("${model.created}".getDateTime),
                            width: 179.pt,
                            height: 33.pt,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 232, 232, 238),
                                borderRadius: BorderRadius.circular(16.5.pt)
                            )
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: 343.pt,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                              children: [
                                Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      CustomText("${model.content}",
                                          fontWeight: w_400,
                                          fontSize: 14.pt,
                                          color: Color.fromARGB(255, 67, 74, 79)
                                      )
                                    ]
                                ).expanded()
                              ]
                          ),
                        )
                      ]
                  )
              );
            }, childCount: _controller.data.length));
          })
        ]
    );
  }
}

