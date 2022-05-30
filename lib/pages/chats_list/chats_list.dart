/*
 *  Copyright (C), 2015-2021
 *  FileName: chats_list
 *  Author: Tonight丶相拥
 *  Date: 2021/9/27
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:provider/provider.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
// import 'package:tencent_im_sdk_plugin/models/v2_tim_conversation.dart';
import 'chats_list_model.dart';
import 'conversation_item.dart';

class ChatsListPage extends StatefulWidget{
  @override
  createState() => _ChatsListPageState();
}

class _ChatsListPageState extends AppStateBase<ChatsListPage> {

  @override
  // TODO: implement model
  ChatsListModel get model => super.model as ChatsListModel;

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => Colors.white;

  @override
  // TODO: implement scaffold
  Widget get scaffold => ChangeNotifierProvider.value(value: model.viewModel,
    child: super.scaffold);

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.message, style: AppStyles.f17w400c0_0_0)
  );

  @override
  // TODO: implement body
  Widget get body => Container(
    child: RefreshWidget(
      enablePullUp: true,
      enablePullDown: true,
      onRefresh: (c) async{
        await model.refreshChats();
        c.refreshCompleted();
      },
      onLoading: (c) async{
        await model.loadMoreChats();
        c.loadComplete();
      },
      children: [
        // SelectorCustom<ChatsListViewModel, List<V2TimConversation>>(
        //   builder: (values) {
        //     return SliverList(
        //       delegate: SliverChildBuilderDelegate((context, index) {
        //         var e = values[index];
        //         String name = e.showName!.replaceAll("ID:", "");
        //         return ConversionItem(
        //           name: name,
        //           faceUrl: e.faceUrl,
        //           lastMessage: e.lastMessage,
        //           unreadCount: e.unreadCount,
        //           type: e.type,
        //           conversationID: e.conversationID,
        //           userID: e.userID,
        //           onTap: (id){
        //             Navigator.of(context).pushNamed(AppRoutes.conversation,
        //                 arguments: {
        //                   "name": name,
        //                   "id": id,
        //                   "isFollowed": true
        //                 });
        //           },
        //         );
        //     }, childCount: values.length));
        //   }, selector: (c) => c.chatsList)
      ]
    )
  );

  @override
  AppModel? initializeModel() {
    // TODO: implement initializeModel
    return ChatsListModel()..refreshChats();
  }
}