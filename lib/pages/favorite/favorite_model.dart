/*
 *  Copyright (C), 2015-2021
 *  FileName: favorite_model
 *  Author: Tonight丶相拥
 *  Date: 2021/8/5
 *  Description: 
 **/


import 'package:hjnzb/generated/favorite_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import '../black_list/black_list_model.dart';

class FavoriteModel extends BlackListModel {

  @override
  Future dataRequest(int page, {void Function(String p1)? failure, Function? success}) {
    // TODO: implement dataRequest
    return HttpChannel.channel.favoritePaging(page)..then((value) =>
        value.finalize(
          wrapper: WrapperModel(),
          failure: failure,
          success: (data) {
            List lst = data["data"] ?? [];
            // this.data = lst.map((e) => FavoriteEntity().fromJson(e)).toList();
            success?.call(lst.map((e) => FavoriteEntity.fromJson(e)).toList());
          }
        ));
  }

  @override
  void onDelete(int index) {
    // TODO: implement onDelete
    var model = data[index];
    show();
    HttpChannel.channel.favoriteCancel(model.id!).then((value) =>
      value.finalize(
        wrapper: WrapperModel(),
        failure: (e) => showToast(e),
        success: (_) {
          dismiss();
          data.removeAt(index);
          data = List.from(data);
          if (hasListeners) {
            notifyListeners();
          }
        }
      ));
  }
}