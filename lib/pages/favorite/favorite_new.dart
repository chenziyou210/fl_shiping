/*
 *  Copyright (C), 2015-2021
 *  FileName: favorite_new
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/favorite_new_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'favorite_fans_base.dart';
import 'favorite_fans_base_logic.dart';

class FavoriteNewPage extends StatefulWidget {
  @override
  createState()=> _FavoriteNewPageState();
}

class _FavoriteNewPageState extends FavoriteFansBase<FavoriteNewPage> {

  final _FavoriteNewLogic controller = _FavoriteNewLogic();

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.favoriteList}",
      fontWeight: w_500,
      fontSize: 16.pt,
      color: Color.fromARGB(255, 34, 40, 49)
    )
  );

}


class _FavoriteNewLogic extends FavoriteFansBaseLogic {
  @override
  Future<bool> getData(int page, {required void Function(List<FavoriteNewEntity> data) success}) {
    return HttpChannel.channel.favoritePaging(page).then((value) {
      return value.finalize<WrapperModel>(
        wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (data) {
          List lst = data["data"] ?? [];
          success(lst.map((e) => FavoriteNewEntity.fromJson(e)).toList());
        }
      ).isSuccess;
    });
  }
}
