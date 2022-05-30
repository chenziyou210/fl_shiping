/*
 *  Copyright (C), 2015-2021
 *  FileName: list_page_model
 *  Author: Tonight丶相拥
 *  Date: 2021/7/16
 *  Description: 
 **/

import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/generated/index_rank_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:httpplugin/httpplugin.dart';


class ListPageModel extends AppModel with PagingMixin<IndexRankEntity>{

  final ListPageViewModel viewModel = ListPageViewModel();

  /// 主播id
  String? anchorId;

  /// 数据源
  List<IndexRankEntity> get data {
    if (viewModel.isDaily) {
      return viewModel.daily;
    }
    if (viewModel.isWeekly) {
      return viewModel.week;
    }
    if (viewModel.isMonthly) {
      return viewModel.month;
    }
    return [];
  }

  /// 记录
  final Map<_ListRank, int> _pageRecord = {
    _ListRank.daily: 1,
    _ListRank.weekly: 1,
    _ListRank.monthly: 1
  };

  @override
  Future dataRefresh() {
    // TODO: implement refresh
    // show();
    _pageRecord[viewModel._listRank] = 1;
    this.page = 1;
    return _getData(page, success: (data) {
      viewModel.setData(data, page: page);
      _pageRecord[viewModel._listRank] = ++page;
      // dismiss();
    });
  }

  Future loadMore(){
    page = _pageRecord[viewModel._listRank]!;
    return _getData(page, success: (data){
      viewModel.setData(data, page: page);
      _pageRecord[viewModel._listRank] = ++page;
      // dismiss();
    });
  }

  Future _getData(int page,
      {required void Function(List<IndexRankEntity> data) success}){
    Future<HttpResultContainer> future;
    // show();
    if (this.anchorId == null) {
      if (viewModel.isDaily) {
        future = HttpChannel.channel.indexDailyRank(page);
      }else if (viewModel.isWeekly) {
        future = HttpChannel.channel.indexWeekRank(page);
      }else {
        future = HttpChannel.channel.indexMonthRank(page);
      }
    }else {
      if (viewModel.isDaily) {
        future = HttpChannel.channel.dailyRank(anchorId: anchorId!, pageNum: page);
      }else if (viewModel.isWeekly) {
        future = HttpChannel.channel.weekRank(anchorId: anchorId!, pageNum: page);
      }else {
        future = HttpChannel.channel.monthRank(anchorId: anchorId!, pageNum: page);
      }
    }
    return future..then((value) => value.finalize(
        wrapper: WrapperModel(),
        failure: (e) => showToast(e),
        success: (data) {
          List lst = data["data"] ?? [];
          List<IndexRankEntity> dataList = lst.map(
            (e) => IndexRankEntity.fromJson(e)).toList();
          success(dataList);
        }
    ));
  }

  /// 更换index
  void changeIndex(int index){
    viewModel.changeIndex(index);
  }
}

enum _ListRank {
  daily,
  weekly,
  monthly
}

class ListPageViewModel extends CommonNotifierModel {

  // 排行分类
  _ListRank _listRank = _ListRank.daily;
  bool get isDaily => _listRank == _ListRank.daily;
  bool get isMonthly => _listRank == _ListRank.monthly;
  bool get isWeekly => _listRank == _ListRank.weekly;

  /// 数据
  List<IndexRankEntity> _daily = [];
  List<IndexRankEntity> get daily => _daily;
  List<IndexRankEntity> _week = [];
  List<IndexRankEntity> get week => _week;
  List<IndexRankEntity> _month = [];
  List<IndexRankEntity> get month => _month;

  /// 日排行
  void changeIndex(int index){
    // _listRank = _ListRank.daily;
    _listRank = _ListRank.values[index];
    updateState();
  }

  /// 设置数据
  void setData(List<IndexRankEntity> data, {int page = 1}){
    if(isDaily) {
      if (page == 1) {
        _daily = data;
      }else {
        _daily += data;
      }
      updateState();
      return;
    }

    if(isWeekly) {
      if (page == 1) {
        _week = data;
      }else {
        _week += data;
      }
      updateState();
      return;
    }

    if(isMonthly) {
      if (page == 1) {
        _month = data;
      }else {
        _month += data;
      }
      updateState();
      return;
    }
  }
}