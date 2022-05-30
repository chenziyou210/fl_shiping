/*
 *  Copyright (C), 2015-2021
 *  FileName: query_base_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/14
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'query_enum.dart';

abstract class QueryBaseLogic<T> extends GetxController with PagingMixin<T>, Toast {
  /// 时间查询位置
  RxInt _index = 0.obs;
  RxInt get index => _index;

  RxList<T> _data = RxList<T>();
  RxList<T> get data => _data;

  int? get id => index.value == -1 ? null :
    int.parse(AppManager.getInstance<GlobalSettingModel>().
      viewModel.timeCondition[index.value].id);

  String? _order;

  /// 是否显示
  RxBool _showCondition = false.obs;
  RxBool get showCondition => _showCondition;

  /// 查询条件
  Rx<QueryType> _queryType = Rx(QueryType.time);
  Rx<QueryType> get queryType => _queryType;

  void hide(){
    _showCondition.value = false;
  }

  void tapTime(){
    _showCondition.value = true;
    _queryType.value = QueryType.time;
  }

  void tapOrderNo(){
    _showCondition.value = true;
    _queryType.value = QueryType.orderNo;
  }

  Future<bool> setIndex(int index) async{
    _index.value = index;
    _showCondition.value = false;
    _order = null;
    return dataRefresh();
  }

  Future<bool> tapAll() async{
    _showCondition.value = false;
    _queryType.value = QueryType.all;
    _index.value = -1;
    _order = null;
    return dataRefresh();
  }

  Future<bool> onSearch({required String condition}) async{
    _showCondition.value = false;
    _order = condition;
    _index.value = -1;
    return dataRefresh();
  }

  Future<bool> getData(int page, {int? id, String? orderNo,
    required void Function(List<T>data) success});

  @override
  Future<bool> dataRefresh() {
    // TODO: implement dataRefresh
    page = 1;
    return getData(page, id: id, orderNo: _order, success: (data) {
      page ++;
      this._data.value = data;
    });
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return getData(page, id: id, orderNo: _order, success: (data) {
      page ++;
      this._data.value += data;
    });
  }
}