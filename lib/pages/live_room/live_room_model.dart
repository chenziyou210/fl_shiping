/*
 *  Copyright (C), 2015-2021
 *  FileName: live_room_model
 *  Author: Tonight丶相拥
 *  Date: 2021/7/28
 *  Description: 
 **/

import 'package:hjnzb/agora_rtc/agora_rtc.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/gift_entity.dart';
import 'package:hjnzb/generated/live_room_info_entity.dart';
import 'package:hjnzb/generated/sample_user_info_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/pages/live_room/mute_model.dart';

import '../../generated/LiveRoomInfoEntity.dart';
// import 'model/trtc_model.dart';

class LiveRoomModel extends AppModel {
  LiveRoomModel({required bool isAnchor, MuteModel? model}) {
    // this.trtcModel = TRTCModel(viewNeedPop, scrollPopToTop, isAnchor: isAnchor,
    //     mute: model);
  }
  LiveRoomViewModel viewModel = LiveRoomViewModel();
  // late TRTCModel trtcModel;

  void dispose(){
    // trtcModel.dispose();
  }

  void dataRefresh(){
    viewModel.dataRefresh();
  }

  void loadMore(){
    viewModel.loadMore();
  }

  void follow(String id){
    HttpChannel.channel.favoriteInsert(id)..then((value) =>
        value.finalize(wrapper: WrapperModel(), success: (_) {
      viewModel._following();
    }));
  }

  /// 计时收费
  void timerLive(dynamic value, String id){
    HttpChannel.channel.timerLiveRoom(id)..then((value) =>
      value.finalize(wrapper: WrapperModel(),
        failure: (e) {
          showToast(e);
          AgoraRtc.rtc.leaveChannel();
        },
        success: (_) {

        }
      ));
  }

  void followCancel(String id){
    HttpChannel.channel.favoriteCancel(id)..then((value) =>
        value.finalize(wrapper: WrapperModel(), success: (_) {
          viewModel._cancelFollow();
        }));
  }

  /// 获取信息
  Future<SampleUserInfoEntity> userInfo(String id, int state) async{
    show();
    return HttpChannel.channel.getUserInfo(id, state, "").then((value) {
      WrapperModel wrapper = value.finalize(wrapper: WrapperModel(),
          failure: (e) => showToast(e),
          success: (data) {
            dismiss();
          }
      );
      return SampleUserInfoEntity.fromJson(wrapper.object);
    });
  }

  // /// 房间验证
  // Future<WrapperModel> verify(String roomId, bool state, value) async{
  //   show();
  //   var result = await HttpChannel.channel.verifyLiveRoom(roomId: roomId,
  //       state: state ? 1 : 2, value: value).then((value) =>
  //       value.finalize<WrapperModel>(
  //           wrapper: WrapperModel(),
  //           failure: (e) => showToast(e),
  //           success: (_) {
  //             dismiss();
  //           }
  //       ));
  //   return result;
  // }

  Future roomInfo({required String roomId}){
    return HttpChannel.channel.liveRoomInfo(roomId: roomId)
      ..then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          if (data != null) {
            viewModel._setRoomInfo(LiveRoomInfoEntity.fromJson(data));
            // trtcModel.viewModel.setAudienceCount(viewModel._entity!.audiencesCount ?? 0);
          }
        }
      ));
  }

  /// 游戏现状
  Future<void> runtimeGame() async{
    await HttpChannel.channel.runtimeGame().then((value) =>
      value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          AppManager.getInstance<Game>().setCurrentData(data);
        }
      ));
    return;
  }
}

class LiveRoomViewModel extends CommonNotifierModel with PagingMixin<GiftEntity>, Toast {
  /// 房间信息
  LiveRoomInfoEntity? _entity;
  LiveRoomInfoEntity? get roomInfo => _entity;

  // 姓名
  String? _name = "Henrietta";
  String? get name => _name;

  // id
  String? _id = "4126345";
  String? get id => _id;

  String? _coin = "345667";
  String? get coin => _coin;

  bool _follow = false;
  bool get follow => _follow;

  void _following(){
    _follow = true;
    updateState();
  }

  void _cancelFollow(){
    _follow = false;
    updateState();
  }

  void _setRoomInfo(LiveRoomInfoEntity info) {
    this._entity = info;
    this._follow = this._entity!.isFollowed ?? false;
    updateState();
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return _getData(page, (e) {
      showToast(e);
    }, (data) {
      this.data += data;
      page ++;
      updateState();
    });
  }

  @override
  Future dataRefresh() {
    // TODO: implement refresh
    page = 1;
    return _getData(page, (e){
      showToast(e);
    }, (data) {
      this.data = data;
      page ++;
      updateState();
    });
  }

  Future _getData(int page, void Function(String) failure, void Function(List<GiftEntity>) success){
    return HttpChannel.channel.roomGiftList(pageNum: page)..then(
            (value) => value.finalize(
              wrapper: WrapperModel(),
              failure: failure,
              success: (data) {
                List lst = data["data"] ?? [];
                success(lst.map((e) => GiftEntity.fromJson(e)).toList());
              }
            ));
  }
}