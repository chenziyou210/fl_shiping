/*
 *  Copyright (C), 2015-2021
 *  FileName: end_draw_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/11/26
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/generated/anchor_list_model_entity.dart';
import 'package:hjnzb/http/http_channel.dart';


class EndDrawLogic extends GetxController with PagingMixin<AnchorListModelEntity> {
  EndDrawLogic(this.id);
  final String id;
  final _EndDrawState state = _EndDrawState();

  @override
  // TODO: implement data
  List<AnchorListModelEntity> get data => state._data;

  @override
  Future dataRefresh() {
    // TODO: implement refresh
    page = 1;
    return _getData(page, id, (data) {
      state._setData(data);
      page ++;
    });
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return _getData(page, id, (data) {
      state._addMoreData(data);
      page ++;
    });
  }

  /// 获取数据
  Future _getData(int page, String id, void Function(List<AnchorListModelEntity>) callBack){
    return HttpChannel.channel.livingRoomRecommend(id, page)
      ..then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List d = data["data"] ?? [];
          callBack(d.map((e) => AnchorListModelEntity.fromJson(e)).toList());
        }
      ));
  }
}

class _EndDrawState {
  RxList<AnchorListModelEntity> _data = <AnchorListModelEntity>[].obs;
  RxList<AnchorListModelEntity> get data => _data;

  void _setData(List<AnchorListModelEntity> data){
    _data.value = data;
  }

  void _addMoreData(List<AnchorListModelEntity> data){
    _data += data;
  }
}