/*
 *  Copyright (C), 2015-2021
 *  FileName: announcement_list_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/15
 *  Description: 
 **/

import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/announcement_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:get/get.dart';

class AnnouncementPageLogic with PagingMixin<AnnouncementEntity>, Toast {
  AnnouncementPageLogic(this.type);
  RxList<AnnouncementEntity> _data = RxList();
  RxList<AnnouncementEntity> get data => _data;
  final int type;

  @override
  Future<bool> dataRefresh() {
    // TODO: implement dataRefresh
    return HttpChannel.channel.announcementList(type).then((value) {
      return value.finalize<WrapperModel>(
          wrapper: WrapperModel(),
          failure: (e)=> showToast(e),
          success: (data) {
            List lst = data ?? [];
            _data.value = lst.map((e) => AnnouncementEntity.fromJson(e)).toList();
          }
      ).isSuccess;
    });
  }
}