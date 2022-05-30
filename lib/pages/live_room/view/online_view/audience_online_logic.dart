/*
 *  Copyright (C), 2015-2021
 *  FileName: audience_online_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/11
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/audience_online_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

class AudienceOnlineLogic extends GetxController with PagingMixin<AudienceOnlineEntity>, Toast {

  final _AudienceOnlineState state = _AudienceOnlineState();
  late final String anchorId;

  @override
  // TODO: implement data
  RxList<AudienceOnlineEntity> get data => state._data;

  @override
  Future dataRefresh() {
    // TODO: implement dataRefresh
    page = 1;
    return _getData(page, anchorId, (data) {
      page ++;
      state._setData(data);
    });
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return _getData(page, anchorId, (data) {
      page ++;
      state._moreData(data);
    });
  }

  Future _getData(int page, String anchorId,
      void Function(List<AudienceOnlineEntity>) success){
    return HttpChannel.channel.audienceNumber(anchorId).then((value) {
      return value.finalize(
        wrapper: WrapperModel(),
        failure: (e) => showToast(e),
        success: (data) {
          List lst = data["audienceList"] ?? [];
          success(lst.map((e) => AudienceOnlineEntity.fromJson(e)).toList());
        }
      );
    });
  }
}

class _AudienceOnlineState {
  RxList<AudienceOnlineEntity> _data = RxList();

  void _setData(List<AudienceOnlineEntity> data){
    _data.value = data;
  }

  void _moreData(List<AudienceOnlineEntity> data){
    _data += data;
  }
}

class AnchorOnlineLogic extends AudienceOnlineLogic {

  Future _getData(int page, String anchorId,
      void Function(List<AudienceOnlineEntity>) success){
    return HttpChannel.channel.anchorOnlineNumber(anchorId).then((value) {
      return value.finalize(
          wrapper: WrapperModel(),
          failure: (e) => showToast(e),
          success: (data) {
            List lst = data["audienceList"] ?? [];
            success(lst.map((e) => AudienceOnlineEntity.fromJson(e)).toList());
          }
      );
    });
  }
}