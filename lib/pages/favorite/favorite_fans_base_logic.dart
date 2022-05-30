/*
 *  Copyright (C), 2015-2021
 *  FileName: favorite_fans_base_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/favorite_new_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

abstract class FavoriteFansBaseLogic extends GetxController with PagingMixin<FavoriteNewEntity>, Toast {
  RxList<FavoriteNewEntity> _data = RxList<FavoriteNewEntity>();
  RxList<FavoriteNewEntity> get data => _data;

  Future<bool> getData(int page, {required void Function(List<FavoriteNewEntity>data) success});

  void onDataDelete(int index) {
    // TODO: implement onDelete
    var model = data[index];
    show();
    HttpChannel.channel.favoriteCancel(model.userId!).then((value) =>
        value.finalize(
            wrapper: WrapperModel(),
            failure: (e) => showToast(e),
            success: (_) {
              dismiss();
              data.removeAt(index);
            }
        ));
  }

  @override
  Future<bool> dataRefresh() {
    // TODO: implement dataRefresh
    page = 1;
    return getData(page, success: (data) {
      page ++;
      this._data.value = data;
    });
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return getData(page, success: (data) {
      page ++;
      this._data.value += data;
    });
  }
}