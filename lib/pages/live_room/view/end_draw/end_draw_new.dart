/*
 *  Copyright (C), 2015-2021
 *  FileName: end_draw_new
 *  Author: Tonight丶相拥
 *  Date: 2021/12/10
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/anchor_list_model_entity.dart';

import 'end_draw_logic.dart';

class LivingRoomEndDrawNew extends StatefulWidget {
  LivingRoomEndDrawNew(this.id, {required this.onTap});
  final String id;
  final void Function(List<AnchorListModelEntity> data, int index) onTap;
  @override
  createState()=> _LivingRoomEndDrawNewState();
}

class _LivingRoomEndDrawNewState extends State<LivingRoomEndDrawNew> {

  late final EndDrawLogic _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EndDrawLogic(widget.id)..dataRefresh();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 150.pt,
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          // Column(
          //   children: [
          //     SizedBox(height: 110.pt),
          //     Hero(tag: "endDrawHero", child: IconButton(
          //       padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
          //       alignment: Alignment.centerRight,
          //       onPressed: (){
          //         Navigator.of(context).pop();
          //       },
          //       icon: Image.asset(AppImages.endDrawClose)))
          //   ]
          // ),
          RefreshWidget(
              enablePullUp: true,
              onLoading: (c) async{
                await _controller.loadMore();
                if (_controller.hasMoreData) {
                  c.loadComplete();
                }else {
                  c.loadNoData();
                }
              },
              onRefresh: (c) async{
                await _controller.dataRefresh();
                c.refreshCompleted();
                c.resetNoData();
              },
              children: [
                Obx((){
                  if (_controller.state.data.length == 0) {
                    return SliverFillRemaining();
                  }
                  return SliverList(delegate: SliverChildBuilderDelegate((_, index) {
                    var model = _controller.state.data[index];
                    return [Container(
                        // width: 79.pt,
                        height: 98.pt,
                        child: Stack(
                            children: [
                              Positioned.fill(
                                  child: ExtendedImage.network(model.roomCover ?? "",
                                      enableLoadState: false,
                                      fit: BoxFit.cover,
                                      // width: 79.pt,
                                      height: 98.pt,
                                      loadStateChanged: (state) {
                                        if (state.extendedImageLoadState == LoadState.loading
                                            || state.extendedImageLoadState == LoadState.failed) {
                                          return Image.asset(AppImages.imgPlaceHolder,
                                            fit: BoxFit.cover,
                                            width: 79.pt,
                                            height: 98.pt,
                                            // color: Colors.black12
                                          );
                                        }}
                                  )),
                              Positioned.fill(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Image.asset(AppImages.hot),
                                          CustomText("${model.heat}",
                                              fontSize: 9.pt,
                                              fontWeight: w_400,
                                              color: Colors.white
                                          )
                                        ]
                                    ),
                                    Spacer(),
                                    CustomText("${model.username}",
                                        fontWeight: w_400,
                                        fontSize: 9.pt,
                                        color: Colors.white
                                    ),
                                    SizedBox(height: 4),
                                    CustomText("${model.roomTitle}",
                                        fontSize: 7.pt,
                                        fontWeight: w_400,
                                        color: Colors.white
                                    )
                                  ]
                              ).paddingSymmetric(horizontal: 4, vertical: 4))
                            ]
                        )//.paddingOnly(bottom: 8)
                    ).clipRRect(radius: BorderRadius.circular(10)).gestureDetector(
                        onTap: (){
                          widget.onTap(_controller.state.data, index);
                          Navigator.of(context).pop();
                        }
                    ), SizedBox(height: 8)].column();
                  }, childCount: _controller.state.data.length));
                })
              ]
          ).container(
            height: 490.pt,
            width: 134.pt,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 21, 23, 35)
            )
          ).clipRRect(radius: BorderRadius.circular(20)).expanded(),
          SizedBox(width: 4)
        ]
      )
    );
  }
}