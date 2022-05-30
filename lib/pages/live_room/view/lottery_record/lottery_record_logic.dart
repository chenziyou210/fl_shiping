/*
 *  Copyright (C), 2015-2021
 *  FileName: lottery_record_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/11/27
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/generated/lottery_record_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

class LotteryRecordLogic extends GetxController with PagingMixin<LotteryRecordEntity> {
  LotteryRecordLogic(this.name): this._time = DateTime.now();
  DateTime _time;
  final String name;
  final _LotteryRecordState state = _LotteryRecordState();

  @override
  // TODO: implement data
  List<LotteryRecordEntity> get data => state._lottery;

  @override
  Future dataRefresh() {
    // TODO: implement refresh
    page = 1;
    return _getData(page, name, (data) {
      page ++;
      state._setData(data);
    });
  }

  @override
  Future loadMore(){
    return _getData(page, name, (data) {
      page ++;
      state._loadMore(data);
    });
  }

  /// 获取数据
  Future _getData(int page, String name, void Function(List<LotteryRecordEntity>) success) {
    return HttpChannel.channel.lotteryLog(page, gameName: name,
        created: _time.millisecondsSinceEpoch)
      .then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data){
          List lst = data["data"] ?? [];
          success(lst.map((e) => LotteryRecordEntity.fromJson(e)).toList());
        }
    ));
  }
}

class _LotteryRecordState {
  RxList<LotteryRecordEntity> _lottery = <LotteryRecordEntity>[].obs;
  RxList<LotteryRecordEntity> get lottery => _lottery;

  void _setData(List<LotteryRecordEntity> data){
    _lottery.value = data;
  }

  void _loadMore(List<LotteryRecordEntity> data){
    _lottery += data;
  }
}