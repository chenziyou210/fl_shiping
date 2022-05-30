/*
 *  Copyright (C), 2015-2021
 *  FileName: grade_image
 *  Author: Tonight丶相拥
 *  Date: 2021/12/11
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';

class GradeImageWidget extends StatelessWidget {
  GradeImageWidget(this.grade);
  final int grade;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image.asset(AppImages.gradeList + "$grade.png",
      width: 42.pt,
      height: 20.pt,
      fit: BoxFit.fill
    );
  }
}