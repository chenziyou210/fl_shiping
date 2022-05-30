/*
 *  Copyright (C), 2015-2022
 *  FileName: gift_card
 *  Author: Tonight丶相拥
 *  Date: 2022/4/25
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_styles.dart';
import '../../../../generated/gift_entity.dart';


class GiftDescriptionEntity {
  GiftDescriptionEntity(this.number, this.description);
  final int number;
  final String description;
}

class GiftCard extends StatelessWidget {
  GiftCard(this.entity);
  final GiftEntity entity;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        alignment: Alignment.center,
        child: Column(
            children: [
              ExtendedImage.network(entity.picurl ?? "",
                  enableLoadState: false,
                  width: 60, height: 60, fit: BoxFit.cover),
              SizedBox(height: 4),
              Text("${entity.name}", style: AppStyles.f14w400c255_255_255),
              SizedBox(height: 4),
              Text("${entity.coins}", style: AppStyles.f14w400c255_255_255)
            ]
        )
    );
  }
}

class GiftIndex {
  int page = -1;
  int index = -1;

  void reset(){
    this.page = -1;
    this.index = -1;
  }

  bool isZero(){
    return page != -1 && index != -1;
  }

  void setLocation(int page, int index){
    this.page = page;
    this.index = index;
  }
}

class GiftModel {
  GiftModel(this.id, this.number, this.name, this.type);
  String id;
  int type;
  String number;
  String name;
}