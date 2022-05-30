/*
 *  Copyright (C), 2015-2022
 *  FileName: baccarat_game_widget
 *  Author: Tonight丶相拥
 *  Date: 2022/2/18
 *  Description: 
 **/

import 'package:flutter/material.dart';

import '../../../../common/app_common_widget.dart';
import '../game_view/game_item.dart';

class BaccaratGameCell extends StatelessWidget {
  BaccaratGameCell({required this.gameName, required this.r});
  final String gameName;
  final List<String> r;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
          Size size = Size(30, 45);
    return Row(
        children: [
            ...r[0].split(",").map((e) => [
              getItem(gameName, e),
              SizedBox(width: 4)
            ]).reduce((value, element) => value + element)..removeLast(),
            [SizedBox(width: 4),//.map((e) => "_" + e)
              ...r[1].split(",").map((e) => [
                getItem(gameName, e, size: size, fit: BoxFit.fill),
                // SizedBox(width: 4)
              ]).reduce((value, element) => value + element)//..removeLast()
            ].row(),
            [
              SizedBox(width: 8),
              ...r[2].split(",").map((e) => [
                getItem(gameName, e, size: size, fit: BoxFit.fill),
                // SizedBox(width: 4)
              ]).reduce((value, element) => value + element)//..removeLast()
            ].row(),
            [
              SizedBox(width: 4),
              ...r[3].split(",").map((e) => [
                getItem(gameName, e),
                SizedBox(width: 4)
              ]).reduce((value, element) => value + element)..removeLast()].row(),
        ]
    );
  }
}