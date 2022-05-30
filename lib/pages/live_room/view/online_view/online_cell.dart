/*
 *  Copyright (C), 2015-2021
 *  FileName: online_cell
 *  Author: Tonight丶相拥
 *  Date: 2021/12/11
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/audience_online_entity.dart';

import '../grade_image.dart';

class OnlineCell extends StatelessWidget {
  OnlineCell(this.model);

  final AudienceOnlineEntity model;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ExtendedImage.network(model.header!,
            enableLoadState: false,
            width: 38.pt,
            height: 38.pt
          ).clipRRect(radius: BorderRadius.circular(19.pt)),
          SizedBox(width: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText("${model.username}",
                      fontWeight: w_500,
                      fontSize: 16.pt,
                    color: Colors.white
                  ),
                  SizedBox(width: 4),
                  GradeImageWidget(model.rank!)
                ]
              ),
              CustomText("ID:${model.memberid}",
               fontSize: 12.pt,
               fontWeight: w_500,
               color: Color.fromARGB(255, 170, 164, 164),
              )
            ]
          ).expanded()
        ]
      )
    );
  }
}