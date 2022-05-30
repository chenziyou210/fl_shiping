/*
 *  Copyright (C), 2015-2021
 *  FileName: query_base
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'query_base_logic.dart';
import 'query_enum.dart';

abstract class QueryBase<T extends StatefulWidget> extends AppStateBase<T> with Toast {

  late final QueryBaseLogic controller;

  final TextEditingController _textEditingController = TextEditingController();

  List<QueryType> get queries => [
    QueryType.time,
    QueryType.all,
    QueryType.orderNo
  ];

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
  Widget build(BuildContext context) {
    // TODO: implement build
    return scaffold.gestureDetector(onTap: (){
      unFocus();
      controller.hide();
    });
  }

  @override
  // TODO: implement body
  Widget get body => Stack(
    children: [
      Positioned.fill(child: RefreshWidget(
          enablePullUp: true,
          onLoading: (c) async{
            await controller.loadMore();
            if (controller.hasMoreData) {
              c.loadComplete();
            }else {
              c.loadNoData();
            }
          },
          onRefresh: (c) async{
            await controller.dataRefresh();
            c.refreshCompleted();
            c.resetNoData();
          },
          children: [
            Obx((){
              if (controller.data.length == 0) {
                return SliverFillRemaining(
                  child: DataEmptyWidget()
                );
              }
              return SliverList(delegate: SliverChildBuilderDelegate((_, index) {
                return cellAtIndex(index);
              }, childCount: controller.data.length));
            })
          ]
      ), top: 56.pt),
      Column(
        children: [
          Container(
            height: 48.pt,
            width: this.width,
            color: Colors.white,
            child: Row(
                children: [
                  if (this.queries.contains(QueryType.time))
                    Obx((){
                      bool noneChoose = controller.index.value == -1;
                      return [CustomText("${noneChoose ? "--" :
                      "${AppManager.getInstance<GlobalSettingModel>().viewModel.
                      timeCondition[controller.index.value].name}"}",
                          fontSize: 16.pt,
                          fontWeight: w_500,
                          color: Colors.black
                      ), SizedBox(width: 8),
                        Image.asset(AppImages.dropdownNew)].
                      row(mainAxisAlignment: MainAxisAlignment.center);
                    }).cupertinoButton(
                        onTap: onTapTime,
                        miniSize: 48.pt
                    ).expanded(),
                  if (this.queries.contains(QueryType.all))
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText("${intl.all}",
                              fontSize: 16.pt,
                              fontWeight: w_500,
                              color: Colors.black
                          ),
                          SizedBox(width: 8),
                          Image.asset(AppImages.dropdownNew)
                        ]
                    ).cupertinoButton(
                        onTap: onTapAll,
                        miniSize: 48.pt
                    ).expanded(),
                  if (this.queries.contains(QueryType.orderNo))
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText("${intl.filter}",
                              fontSize: 16.pt,
                              fontWeight: w_500,
                              color: Colors.black
                          ),
                          SizedBox(width: 8),
                          Image.asset(AppImages.dropdownNew)
                        ]
                    ).cupertinoButton(
                        onTap: onTapOrder,
                        miniSize: 48.pt
                    ).expanded()
                ]
            )
          ),
          SizedBox(height: 1),
          Obx((){
            if (controller.showCondition.value) {
              return Obx((){
                if (controller.queryType.value == QueryType.orderNo) {
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 16.pt),
                        Row(
                          children: [
                            CustomText("${intl.orderNumber}",
                              fontSize: 17.pt,
                              fontWeight: w_400,
                              color: Colors.black
                            ),
                            SizedBox(width: 16),
                            CustomTextField(
                              controller: _textEditingController,
                              hintText: "${intl.pleaseEnter}",
                              style: TextStyle(
                                fontSize: 17.pt,
                                fontWeight: w_400,
                                color: Colors.black
                              ),
                              hintTextStyle: TextStyle(
                                fontSize: 17.pt,
                                fontWeight: w_400,
                                color: Color.fromARGB(255, 196, 196, 196)
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 232, 231, 231)
                                )
                              )
                            ).expanded()
                          ]
                        ),
                        SizedBox(height: 16),
                        Container(
                          alignment: Alignment.center,
                          width: this.width,
                          height: 46.pt,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: AppColors.buttonGradientColors),
                            borderRadius: BorderRadius.circular(23.pt)
                          ),
                          child: CustomText("${intl.query}",
                            fontSize: 16.pt,
                            fontWeight: w_500,
                            color: Colors.white
                          )
                        ).cupertinoButton(onTap: onSearch, miniSize: 46.pt),
                        SizedBox(height: 16)
                      ]
                    )
                  );
                }else if (controller.queryType.value == QueryType.time) {
                  var condition = AppManager.getInstance<GlobalSettingModel>()
                      .viewModel.timeCondition;
                  return Container(
                      color: Colors.white,
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Wrap(
                          children: condition.map((e) {
                            int index = condition.indexOf(e);
                            return Obx((){
                              bool atIndex = index == controller.index.value;
                              return Container(
                                width: 78.pt,
                                height: 44.pt,
                                decoration: BoxDecoration(
                                  gradient: atIndex ? LinearGradient(colors: AppColors.buttonGradientColors) : null,
                                  borderRadius: BorderRadius.circular(8),
                                  border: atIndex ? null : Border.all(
                                    color: Color.fromARGB(255, 226, 226, 232)
                                  )
                                ),
                                alignment: Alignment.center,
                                child: CustomText(e.name,
                                  fontSize: 16.pt,
                                  fontWeight: w_500,
                                  color: atIndex ? Colors.white :
                                    Color.fromARGB(255, 86, 85, 85)
                                )
                              );
                            }).cupertinoButton(onTap: ()=> onTapIndex(index),
                                miniSize: 44.pt);
                          }).toList(),
                          spacing: 8,
                          runSpacing: 8
                        ).expanded()
                      ]
                    )
                  );
                }
                return SizedBox();
              });
            }
            return SizedBox();
          })
        ]
      )
    ]
  );

  Widget cellAtIndex(int index){
    return SizedBox();
  }
  
  @override
  // TODO: implement bodyColor
  Color? get bodyColor => Color.fromARGB(255, 240, 240, 244);

  void onTapOrder(){
    controller.tapOrderNo();
  }

  void onTapAll() async{
    show();
    var value = await controller.tapAll();
    if (value) {
      dismiss();
    }
  }

  void onTapTime(){
    controller.tapTime();
  }

  void onTapIndex(int index) async{
    show();
    var value = await controller.setIndex(index);
    if (value) {
      dismiss();
    }
  }

  void onSearch() async{
    var text = _textEditingController.text;
    if (text.isEmpty) {
      showToast("${intl.pleaseEnter}");
      return;
    }
    show();
    var value = await controller.onSearch(condition: text);
    if (value) {
      dismiss();
    }
  }

  Widget copy(String? value) {
    return Container(
      height: 26.pt,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.pt),
          gradient: LinearGradient(
              colors: AppColors.buttonGradientColors
          )
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText("${intl.copy}",
                fontWeight: w_500,
                fontSize: 14.pt,
                color: Colors.white
            )
          ]
      ),
    ).cupertinoButton(
        onTap: (){
          var data = ClipboardData(text: value);
          Clipboard.setData(data);
          showToast("${intl.copySuccess}");
        },
        miniSize: 26.pt);
  }
}