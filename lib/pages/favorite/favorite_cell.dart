/*
 *  Copyright (C), 2015-2021
 *  FileName: favorite_cell
 *  Author: Tonight丶相拥
 *  Date: 2021/7/19
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/pages/component_widget/level_widget.dart';

const double _rowHeight = 77;

class FavoriteModel {
  FavoriteModel({
    required this.avatar,
    required this.name,
    required this.signature,
    required this.level
  });
  final String avatar;
  final String signature;
  final String name;
  final int level;
}

class FavoriteCell extends StatelessWidget {
  FavoriteCell(this.entity);
  final FavoriteModel entity;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: _rowHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.c239_239_239
          )
        )
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ClipRRect(
            child: ExtendedImage.network(
                entity.avatar,
                enableLoadState: false,
                height: 48,
                width: 48,
                fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(24)
          ),
          SizedBox(width: 16),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${entity.name}", style: AppStyles.f15w500c0_0_0.copyWith(
                    color: AppColors.c38_38_40
                  )),
                  SizedBox(width: 4),
                  LevelWidget(AppImages.vipBackground, entity.level)
                ]
              ),
              SizedBox(height: 4),
              Text("${entity.signature}", style: AppStyles.f15w400c193_192_201)
            ]
          ))
        ]
      )
    );
  }
}