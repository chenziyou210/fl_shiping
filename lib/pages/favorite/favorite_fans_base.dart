/*
 *  Copyright (C), 2015-2021
 *  FileName: favorite_fans_base
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/pages/live_room/view/grade_image.dart';
import 'favorite_fans_base_logic.dart';

abstract class FavoriteFansBase<T extends StatefulWidget> extends AppStateBase<T> with Toast{

  late final FavoriteFansBaseLogic controller;

  bool get isFavorite => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    show();
    controller.dataRefresh().then((value) {
      if (value)
        dismiss();
    });
  }

  @override
  // TODO: implement body
  Widget get body => Container(
    height: this.height,
    width: this.width,
    color: Colors.white,
    // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    child: RefreshWidget(
      enablePullUp: true,
      onRefresh: (c) async{
        await controller.dataRefresh();
        c.refreshCompleted();
        c.resetNoData();
      },
      onLoading: (c) async{
        await controller.loadMore();
        if (controller.hasMoreData) {
          c.loadComplete();
        }else {
          c.loadNoData();
        }
      },
      children: [
        Obx((){
          if(controller.data.length == 0) {
            return SliverFillRemaining(
              child: DataEmptyWidget()
            );
          }
          return SliverList(delegate: SliverChildBuilderDelegate((_, index) {
            var model = controller.data[index];
            return Container(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        ExtendedImage.network("${model.header}",
                          width: 38.pt,
                          height: 38.pt,
                          fit: BoxFit.fill
                        ).clipRRect(radius: BorderRadius.circular(19.pt)),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomText("${model.username}",
                                    fontSize: 16.pt,
                                    fontWeight: w_500,
                                    color: Color.fromARGB(255, 34, 40, 49)
                                ),
                                SizedBox(width: 4),
                                GradeImageWidget(model.rank!)
                              ]
                            ),
                            SizedBox(height: 8),
                            CustomText("ID: ${model.memberid}",
                              fontSize: 12.pt,
                              fontWeight: w_500,
                              color: Color.fromARGB(255, 170, 164, 164)
                            )
                          ]
                        ).expanded(),
                        if (isFavorite)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 28.pt,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 223, 223, 223),
                            borderRadius: BorderRadius.circular(14.pt)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText("${intl.cancelFavorite}",
                                fontWeight: w_400,
                                fontSize: 14.pt,
                                color: Color.fromARGB(255, 155, 155, 155)
                              )
                            ]
                          )
                        ).cupertinoButton(
                          onTap: (){
                            controller.onDataDelete(index);
                          },
                          miniSize: 28.pt
                        ).padding(padding: EdgeInsets.only(right: 16))
                      ]
                    )
                  ),
                  CustomDivider(
                    indent: 8,
                    color: Color.fromARGB(255, 245, 245, 245),
                  )
                ]
              ),
            );
          }, childCount: controller.data.length));
        })
      ]
    ),
  ).clipRRect(radius: BorderRadius.circular(20)).padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8));
}