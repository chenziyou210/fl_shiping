/*
 *  Copyright (C), 2015-2021
 *  FileName: anchor_rank_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/8
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/generated/rank_new_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'rank_page_base_logic.dart';

class AnchorRankLogic extends RankPageBaseLogic<_AnchorRankLogic> {
  AnchorRankLogic(this.type);
  @override
  _AnchorRankLogic state = _AnchorRankLogic();

  final int type;

  @override
  // TODO: implement data
  List<RankNewEntity> get data => state.data;

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return _loadData(page, type, (data) {
      page ++;
      state._loadMore(data);
    });
  }

  @override
  Future dataRefresh() {
    // TODO: implement refresh
    page = 1;
    return _loadData(page, type, (data) {
      page ++;
      state._setData(data);
    });
  }

  Future _loadData(int page, int type, void Function(List<RankNewEntity>) success){
    return HttpChannel.channel.anchorRank(page: page, type: type)
      .then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data["data"] ?? [];
          success(lst.map((e) => RankNewEntity.fromJson(e)).toList());
        }
    ));
  }

  void toggleAttentionAtIndex(int index){
    state._toggleAttentionAtIndex(index);
  }

  @override
  bool isAttentionAtIndex(int index) {
    return data[index].attention ?? false;
  }
}

class _AnchorRankLogic {
  RxList<RankNewEntity> _data = RxList();
  RxList<RankNewEntity> get data => _data;

  void _setData(List<RankNewEntity> lst){
    this._data.value = lst;
  }

  void _loadMore(List<RankNewEntity> lst){
    this._data.value += lst;
  }

  void _toggleAttentionAtIndex(int index){
    var value = _data[index].attention!;
    _data[index] = _data[index]..attention = !value;
  }
}