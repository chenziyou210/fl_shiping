/*
 *  Copyright (C), 2015-2021
 *  FileName: vip_grade
 *  Author: Tonight丶相拥
 *  Date: 2021/12/8
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'vip_grade_logic.dart';

class VipGradePage extends StatefulWidget {
  @override
  createState() => _VipGradePageState();
}

class _VipGradePageState extends AppStateBase<VipGradePage> {

  /// 数据控制器
  final VipGradeLogic _controller = VipGradeLogic();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controller);
    _controller.getGrade();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<VipGradeLogic>();
  }

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    backgroundColor: Colors.transparent,
    leading: CustomBackButton(
      iconColor: Colors.white
    ),
    title: CustomText("${intl.grade} ${intl.list}",
      fontWeight: w_500,
      fontSize: 16.pt,
      color: Colors.white,
    )
  );
  
  @override
  // TODO: implement body
  Widget get body => Column(
    children: [
      Stack(
        children: [
          Image.asset(AppImages.gradeListHeader,
            width: this.width,
            fit: BoxFit.fill
          ),
          Positioned(child: Container(
            width: 230.pt,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SelectorCustom<AppUser, String?>(
                      builder: (value) {
                        Widget w;
                        if (value == null || value.isEmpty) {
                          w = SizedBox(
                            width: 34.pt,
                            height: 34.pt
                          );
                        }else {
                          w = ExtendedImage.network(value, 
                            width: 34.pt, height: 34.pt, fit: BoxFit.cover).clipRRect(
                            radius: BorderRadius.circular(17.pt)
                          );
                        }
                        return w;
                      }, 
                      selector: (a)=> a.header),
                    SizedBox(width: 4),
                    CustomText("${intl.currentGrade}: ",
                      fontSize: 16.pt,
                      fontWeight: w_500,
                      color: Color.fromARGB(255, 218, 181, 129)
                    ),
                    Obx((){
                      var level = _controller.state.gradeEntity.value.userLevel;
                      if (level == null)
                        return SizedBox();
                      return Image.asset(AppImages.gradeList + "$level.png",
                        width: 40,
                        height: 20,
                        fit: BoxFit.fill
                      );
                    })
                  ]
                ),
                SizedBox(height: 16.pt),
                Obx((){
                  var value = _controller.state.gradeEntity.value.nowExperience;
                  var gradeValue = _controller.state.gradeEntity.value.upgradeExperience;
                  if (value == null || gradeValue == null)
                    return SizedBox();
                  return CustomPaint(
                    size: Size(230.pt, 6.pt),
                    painter: LineProgressPainter(colors: [
                      Color.fromARGB(255, 231, 184, 103),
                      Color.fromARGB(255, 231, 184, 103)
                    ],
                      color: Color.fromARGB(255, 67, 79, 91),//rgba(67, 79, 91, 1)
                      percent: value / (gradeValue + value),
                      radius: BorderRadius.circular(3.pt)
                    ),
                  );
                }),
                SizedBox(height: 8.pt),
                Row(
                  children: [
                    Obx((){
                      var value = _controller.state.gradeEntity.value.nowExperience;
                      var value1 = _controller.state.gradeEntity.value.upgradeExperience;
                      return CustomText("${intl.experienceValue}: $value/${value1! + value!}",
                        fontWeight: w_500,
                        fontSize: 12.pt,
                        color: Color.fromARGB(255, 225, 180, 121)
                      );
                    }),
                    Spacer(),
                    Obx((){
                      // var value = _controller.state.gradeEntity.value.nowExperience;
                      var value1 = _controller.state.gradeEntity.value.upgradeExperience;
                      return CustomText("${intl.rangeUpgradeDifference}: $value1",
                        fontWeight: w_500,
                        fontSize: 12.pt,
                        color: Color.fromARGB(255, 225, 180, 121)
                      );
                    }),
                  ]
                )
              ]
            )
          ), bottom: 40.pt, left: 32.pt)
        ]
      ),
      SizedBox(height: 16.pt),
      Stack(
        children: [
          Container(),
          Positioned.fill(
            child: Image.asset(AppImages.gradeListFooter,
              fit: BoxFit.fill),
            left: 18.pt,
            right: 18.pt
          ),
          Positioned.fill(child: Column(
              children: [
                CustomText("${intl.gradeRank}",
                    fontSize: 20.pt,
                    fontWeight: w_bold,
                    color: Color.fromARGB(255, 174, 43, 147)
                ),
                SizedBox(height: 4.pt),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText("${intl.gradeIcon}",
                      fontWeight: w_400,
                      fontSize: 14.pt,
                      color: Colors.black
                    ),
                    CustomText("${intl.gradeExperience}",
                      fontWeight: w_400,
                      fontSize: 14.pt,
                      color: Colors.black
                    ),
                  ]
                ),
                SizedBox(height: 16.pt),
                Obx((){
                  var lst = _controller.state.gradeEntity.value.levelLst;
                  return ListView.builder(itemBuilder: (_, index) {
                    var model = lst![index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(AppImages.gradeList + "${model.level}.png",
                          width: 40,
                          height: 20,
                          fit: BoxFit.fill),
                        CustomText("${model.experience}",
                          fontSize: 16.pt,
                          fontWeight: w_400,
                          color: Color.fromARGB(255, 174, 44, 147)
                        )
                      ]
                    ).sizedBox(height: 40);
                  }, itemCount: lst?.length ?? 0, padding: EdgeInsets.zero);
                }).expanded()
              ]
          ), left: 60.pt, right: 60.pt, top: 24.pt)
        ]
      ).expanded()
    ]
  );
}