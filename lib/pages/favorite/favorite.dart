/*
 *  Copyright (C), 2015-2021
 *  FileName: favorite
 *  Author: Tonight丶相拥
 *  Date: 2021/7/19
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/generated/favorite_entity.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:provider/provider.dart';
import '../black_list/black_list.dart';
import 'favorite_model.dart';

class FavoritePage extends StatefulWidget {
  @override
  createState()=> _FavoritePageState();
}

class _FavoritePageState extends BlackListState<FavoritePage> {

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.attention, style: AppStyles.f17w400c0_0_0)
  );

  @override
  // TODO: implement model
  FavoriteModel get model => super.model as FavoriteModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
        value: model,
        child: super.scaffold);
  }

  @override
  // TODO: implement selector
  Widget get selector => SelectorCustom<FavoriteModel, List<FavoriteEntity>>(
    builder: (_) {
      return sliverList;
    },
    selector: (f) => f.data
  );

  @override
  FavoriteModel initializeModel() {
    // TODO: implement initializeModel
    return FavoriteModel()..loadData();
  }

  @override
  void onDelete(int index) {
    // TODO: implement onDelete
    model.onDelete(index);
  }

  @override
  void onTap(int index) {
    // TODO: implement onTap
    super.onTap(index);
    var m = model.data[index];
    Navigator.of(context).pushNamed(AppRoutes.userById, arguments: {
      "id": m.id
    });
  }
}