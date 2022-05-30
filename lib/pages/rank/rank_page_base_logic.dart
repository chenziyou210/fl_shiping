/*
 *  Copyright (C), 2015-2021
 *  FileName: rank_page_base_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/8
 *  Description: 
 **/

import 'package:get/get.dart';
import 'package:hjnzb/generated/rank_new_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

abstract class RankPageBaseLogic<T> extends GetxController with PagingMixin<RankNewEntity> {
  late final T state;

  late dynamic type;

  void toggleAttentionAtIndex(int index) {

  }

  bool isAttentionAtIndex(int index);
}
