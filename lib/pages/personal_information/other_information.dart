/*
 *  Copyright (C), 2015-2021
 *  FileName: other_information
 *  Author: Tonight丶相拥
 *  Date: 2021/10/9
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:provider/provider.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/user_message_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'personal_information.dart';

class OtherUserInfo extends StatefulWidget {
  OtherUserInfo({dynamic arguments}): this.id = arguments["id"];
  final String id;
  @override
  createState()=> _OtherUserInfoState();
}
class _OtherUserInfoState extends PersonalInformationState<OtherUserInfo> with Toast {

  late Future _future;
  UserMessageEntity? _messageEntity;
  final _AttentionModel _model = _AttentionModel();

  String get id => widget.id;

  @override
  // TODO: implement scaffold
  Widget get scaffold => WillPopScope(child: ChangeNotifierProvider.value(
    value: _model, child: super.scaffold), onWillPop: () async {
    popViewController(_messageEntity?.isAttrntion);
    return true;
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = HttpChannel.channel.getUserById(widget.id)..then((value) =>
        value.finalize(
          wrapper: WrapperModel(),
          failure: (e) => showToast(e),
          success: (data) {
            _messageEntity = UserMessageEntity.fromJson(data);
            _model._changeAttention(_messageEntity!.isAttrntion ?? false);
          }
        ));
  }

  @override
  Widget get body => LoadingWidget(builder: (_, __) {
    if (_messageEntity == null) {
      return SizedBox();
    }
    return view;
  }, future: _future);

  @override
  get viewModel => _messageEntity;

  @override
  List<Widget>? get actions => [
    Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: AppColors.buttonGradientColors
        )
      ),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Image.asset(AppImages.liveNotify)),
            TextSpan(
              text: intl.openLiveNotify,
              style: TextStyle(
                fontSize: 12,
                fontWeight: w_400,
                color: Colors.white
              )
            )
          ]
        )
      )
    ).cupertinoButton(onTap: (){
      
    }).center.padding(padding: EdgeInsets.only(right: 8))
  ];

  @override
  void sayHi() {
    // TODO: implement sayHi
    Navigator.of(context).pushNamed(AppRoutes.conversation,
        arguments: {
          "name": _messageEntity!.name,
          "id": widget.id,
          "isFollowed": _messageEntity!.isAttrntion
        });
  }

  @override
  void message() {
    // TODO: implement message
    Navigator.of(context).pushNamed(AppRoutes.conversation,
        arguments: {
          "name": _messageEntity!.name,
          "id": widget.id,
          "isFollowed": _messageEntity!.isAttrntion
        });
  }

  @override
  void attention() {
    // TODO: implement attention
    show();
    HttpChannel.channel.favoriteInsert(widget.id).then((value) =>
        value.finalize(wrapper: WrapperModel(),
          failure: (e) => showToast(e),
          success: (_) {
            showToast(intl.attentionSuccess);
            _messageEntity!.isAttrntion = true;
            _model._changeAttention(_messageEntity!.isAttrntion ?? false);
          }
        ));
  }

  @override
  // TODO: implement attentionWidget
  Widget get attentionWidget => SelectorCustom<_AttentionModel, bool>(
    builder: (value) {
      String text = "+${intl.follow}";
      if (value) {
        text = "${intl.followed}";
      }
      return Text(text, style: AppStyles.f16w400c165_59_227);
    },
    selector: (s) => s._attention
  );
}

class _AttentionModel extends CommonNotifierModel {
  late bool _attention;

  void _changeAttention(bool attention){
    _attention = attention;
    updateState();
  }
}