/*
 *  Copyright (C), 2015-2021
 *  FileName: total_list_page_model
 *  Author: Tonight丶相拥
 *  Date: 2021/10/11
 *  Description: 
 **/

import 'package:hjnzb/generated/index_rank_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'list_page_model.dart';

class TotalListPageModel extends ListPageModel {
  final TotalListPageViewModel viewModel1 = TotalListPageViewModel();

  @override
  // TODO: implement data
  List<IndexRankEntity> get data => viewModel1._data;

  @override
  Future dataRefresh() {
    // TODO: implement refresh
    page = 1;
    return _getData(page, success: (data) {
      page ++;
      viewModel1._setData(data);
    });
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return _getData(page, success: (data) {
      page ++;
      viewModel1._addData(data);
    });
  }
  Future _getData(int page, {required void Function(List<IndexRankEntity> data) success}){
    var future = HttpChannel.channel.anchorContributionList(anchorId!, page);
    return future..then((value) => value.finalize(
        wrapper: WrapperModel(),
        failure: (e) => showToast(e),
        success: (data) {
          List lst = data["data"] ?? [];
          List<IndexRankEntity> dataList = lst.map(
                  (e) => IndexRankEntity.fromJson(e)).toList();
          dismiss();
          success(dataList);
        }
    ));
  }
}

class TotalListPageViewModel extends ListPageViewModel {

  List<IndexRankEntity> _data = [];
  List<IndexRankEntity> get daily => _data;
  List<IndexRankEntity> get week => _data;
  List<IndexRankEntity> get month => _data;

  void _setData(List<IndexRankEntity> data){
    this._data = data;
    updateState();
  }

  void _addData(List<IndexRankEntity> data){
    this._data += data;
    updateState();
  }
}