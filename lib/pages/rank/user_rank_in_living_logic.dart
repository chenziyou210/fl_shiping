/*
 *  Copyright (C), 2015-2021
 *  FileName: user_rank_in_living_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/20
 *  Description: 
 **/
import 'package:get/get.dart';
import 'package:hjnzb/generated/rank_new_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'rank_page_base_logic.dart';

class UserRankInLivingLogic extends RankPageBaseLogic<_UserRankInLivingLogic> {
  UserRankInLivingLogic(this.type);
  @override
  _UserRankInLivingLogic state = _UserRankInLivingLogic();

  final String type;

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

  Future _loadData(int page, String type, void Function(List<RankNewEntity>) success){
    return HttpChannel.channel.contributionListInLiving(page, anchorId: type)
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

class _UserRankInLivingLogic {
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