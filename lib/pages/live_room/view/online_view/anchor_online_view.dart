/*
 *  Copyright (C), 2015-2021
 *  FileName: anchor_online_view
 *  Author: Tonight丶相拥
 *  Date: 2021/12/11
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/audience_online_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/pages/live_room/live_room_enum.dart';
import '../../live_room_chat_model.dart';
import 'online_view.dart';
import 'audience_online_logic.dart';
import 'online_cell.dart';


class AnchorOnlineView extends StatefulWidget {
  AnchorOnlineView(this.anchorId, this._imController);
  final String anchorId;
  final IMModel _imController;
  @override
  createState()=> _AnchorOnlineViewState();
}

class _AnchorOnlineViewState extends OnlineViewState<AnchorOnlineView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnchorOnlineLogic()..anchorId = widget.anchorId;
    controller.dataRefresh();
  }

  @override
  Widget cellAtIndex(int index) {
    // TODO: implement cellAtIndex
    var model = controller.data[index];
    return AnchorAudienceCell(model, intl, widget.anchorId, muting: (){
      widget._imController.sendText("", type: TextType.mute, mutingId: model.userId!);
    }, mutingCancel: (){
      widget._imController.sendText("", type: TextType.muteCancel, mutingId: model.userId!);
    });
  }
}

class AnchorAudienceCell extends StatefulWidget {
  AnchorAudienceCell(this.model, this.intl, this.anchorId,
      {required this.muting, required this.mutingCancel});
  final AudienceOnlineEntity model;
  final AppInternational intl;
  final String anchorId;
  final VoidCallback muting;
  final VoidCallback mutingCancel;
  @override
  createState()=> _AnchorAudienceCellState();
}

class _AnchorAudienceCellState extends State<AnchorAudienceCell> with Toast {

  late bool _isManager;
  late bool _isMuting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isManager = widget.model.adminFlag == 1;
    _isMuting = widget.model.banFlag == 1;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        OnlineCell(widget.model).expanded(),
        Column(
            children: [
              Image.asset(_isManager ? AppImages.livingManager : AppImages.livingNotManager),
              SizedBox(height: 4),
              CustomText("${widget.intl.setLivingManager}",
                  fontSize: 12.pt,
                  fontWeight: w_500,
                  color: Colors.white
              )
            ]
        ).gestureDetector(
            onTap: (){
              if (_isManager) {
                _cancelStatus(1, success: (){
                  _isManager = !_isManager;
                  widget.model.adminFlag = _isManager ? 1 : 0;
                  setState(() {});
                });
              }else {
                _addStatus(1, success: (){
                  _isManager = !_isManager;
                  widget.model.adminFlag = _isManager ? 1 : 0;
                  setState(() {});
                });
              }
            }
        ),
        SizedBox(width: 8),
        Column(
            children: [
              CupertinoSwitchWidget(
                  value: _isMuting,
                  needInternalState: false,
                  onChanged: (state){
                    if (_isMuting) {
                      _cancelStatus(2, success: (){
                        _isMuting = !_isMuting;
                        widget.model.banFlag = _isMuting ? 1 : 0;
                        widget.mutingCancel();
                        setState(() {});
                      });
                    }else {
                      _addStatus(2, success: (){
                        _isMuting = !_isMuting;
                        widget.model.banFlag = _isMuting ? 1 : 0;
                        widget.muting();
                        setState(() {});
                      });
                    }
                  },
                  activeColor: Colors.red,
                  trackColor: Color.fromARGB(255, 120, 120, 120),
                  thumbColor: Colors.white
              ).transformScale(0.6).sizedBox(height: 20),
              SizedBox(height: 4),
              CustomText("${widget.intl.isMuting}",
                  fontSize: 12.pt,
                  fontWeight: w_500,
                  color: Colors.white
              )
            ]
        )
      ],
    );
  }

  void _cancelStatus(int type, {required VoidCallback success}){
    show();
    HttpChannel.channel.livingCancelStatus(anchorId: widget.anchorId,
        userId: widget.model.userId!,
        state: type).then((value) {
      return value.finalize(
          wrapper: WrapperModel(),
          failure: (e)=> showToast(e),
          success: (_) {
            dismiss();
            success();
          }
      );
    });
  }

  void _addStatus(int type, {required VoidCallback success}){
    show();
    HttpChannel.channel.livingAddStatus(anchorId: widget.anchorId,
        userId: widget.model.userId!,
        state: type).then((value) {
       return value.finalize(wrapper: WrapperModel(),
         failure: (e)=> showToast(e),
           success: (_) {
             dismiss();
             success();
           }
       );
    });
  }
}