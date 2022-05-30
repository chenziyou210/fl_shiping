/*
 *  Copyright (C), 2015-2021
 *  FileName: live_room_new_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/9
 *  Description: 
 **/

import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/agora_rtc/agora_rtc.dart';
import 'package:hjnzb/common/app_common_widget.dart'
    show EventBus, enterRoomSuccess, verifyRoomSuccess,
    liverOffline, gameTimeOut, freeTimeOut;
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/anchor_list_model_entity.dart';
import 'package:hjnzb/generated/gift_entity.dart';
import 'package:hjnzb/generated/live_room_info_entity.dart';
import 'package:hjnzb/generated/living_audience_entity.dart';
import 'package:hjnzb/generated/sample_user_info_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/pages/live_room_preview/live_room_type.dart';

import '../../generated/LiveRoomInfoEntity.dart';

class LiveRoomNewLogic extends GetxController with Toast, WidgetsBindingObserver{
  LiveRoomNewLogic(){
    EventBus.instance.addListener(_enterRoomSuccess, name: enterRoomSuccess);
    EventBus.instance.addListener(_gameTimeOut, name: gameTimeOut);
    EventBus.instance.addListener(_liverOffline, name: liverOffline);
    WidgetsBinding.instance?.addObserver(this);
  }
  final _LiveRoomNewState state = _LiveRoomNewState();

  Timer? _timer;
  Timer? _freeTimer;

  void _enterRoomSuccess(_){
    var model = state.rooms[state._roomIndex.value];
    _timerCancel();
    if (LiveRoomType.timer.rawValue == model.roomType
        && state._freeTimeCount.value <= 0) {
      _timer = Timer.periodic(Duration(seconds: 60), (_) {
        _timerLive(model.id!);
      });
    }
    state._enableRoom();
  }

  void _freeTimerInitialize(int count) async{
    int index = state._roomIndex.value;
    var model = state.rooms[index];
    if (_freeTimer != null) {
      _freeTimer!.cancel();
      _freeTimer = null;
    }
    if (count == 0){
      EventBus.instance.notificationListener(name: freeTimeOut, parameter: model);
    }else {
      await state._payEnterRoom();
      state._initFreeCount(count);
      _freeTimer = Timer.periodic(Duration(seconds: 1), (timer) async{
        --count;
        if (count >= 0) {
          state._initFreeCount(count);
        }else if (count < 0){
          return;
        }
        if (count == 0){
          _freeTimer?.cancel();
          if (index != state.roomIndex.value) {
            state._initFreeCount(-1);
            return;
          }
          EventBus.instance.notificationListener(name: freeTimeOut, parameter: model);
          await state._leaveChannel();
          return;
        }
      });
    }
  }

  /// 支付费用
  void pay(){
    var model = state.rooms[state._roomIndex.value];
    _timerLive(model.id!, success: (){
      state._initFreeCount(-1);
      state._payEnterRoom();
    });
  }

  void _gameTimeOut(_){
    runtimeGame();
  }

  void _timerCancel(){
    _timer?.cancel();
    _timer = null;
  }

  void _liverOffline(_){
    _timerCancel();
    state._setLivingRoomState(LivingRoomState.liverOffline);
  }

  /// 刷新礼物
  void getGiftData(){
    HttpChannel.channel.roomGiftList(pageNum: 1, pageSize: 99999)..then(
            (value) => value.finalize(
            wrapper: WrapperModel(),
            success: (data) {
              List lst = data["data"] ?? [];
              state._setGifts(lst.map((e) => GiftEntity.fromJson(e)).toList());
            }
        ));
  }

  /// 关注
  void follow(String id){
    HttpChannel.channel.favoriteInsert(id)..then((value) =>
        value.finalize(wrapper: WrapperModel(), success: (_) {
          state._following();
        }));
  }

  void following(){
    state._following();
  }

  void cancelFollowing(){
    state._cancelFollow();
  }

  void setCoins(int value){
    state._setCoins(value);
  }

  /// 计时收费
  void _timerLive(String id, {void Function()? success}){
    HttpChannel.channel.timerLiveRoom(id)..then((value) =>
        value.finalize(wrapper: WrapperModel(),
            failure: (e) {
              showToast(e);
              AgoraRtc.rtc.leaveChannel();
              state._disableRoom();
              state._setLivingRoomState(LivingRoomState.lackOfBalance);
            },
            success: (_) => success?.call()
        ));
  }

  /// 取消关注
  void followCancel(String id){
    HttpChannel.channel.favoriteCancel(id)..then((value) =>
        value.finalize(wrapper: WrapperModel(), success: (_) {
          state._cancelFollow();
        }));
  }

  /// 获取信息
  /// 1:查粉丝信息 2:查主播信息
  Future<SampleUserInfoEntity> userInfo(String id, int state, String userId) async{
    show();
    return HttpChannel.channel.getUserInfo(id, state,userId).then((value) {
      WrapperModel wrapper = value.finalize(wrapper: WrapperModel(),
          failure: (e) => showToast(e),
          success: (data) {
            dismiss();
          }
      );
      return SampleUserInfoEntity.fromJson(wrapper.object);
    });
  }

  String? _roomId;
  ///  房间信息
  Future roomInfo({required String roomId}){
    this._roomId = roomId;
    return _roomInfo(roomId);
  }

  Future _roomInfo(String roomId){
    if (_roomId != roomId)
      return Future.value();
    return HttpChannel.channel.liveRoomInfo(roomId: roomId)
      ..then((value) => value.finalize(
          wrapper: WrapperModel(),
          success: (data) {
            if (data != null) {
              state._setRoomInfo(LiveRoomInfoEntity.fromJson(data));
            }
          },
          failure: (e) {
            _roomInfo(roomId);
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

  /// 加入房间
  Future<void> _addRoom() async{
    _timer?.cancel();
    /// 上一个房间不为空: 退出直播间
    if (state._lastRoom != null){
      await AgoraRtc.rtc.leaveChannel();
      // HttpChannel.channel.audienceExitRoom(
      //     roomId: state._lastRoom!,
      //     follow: false);
      HttpChannel.channel.changeRoom();
    }
    /// 上一个验证请求未完成：取消上一个验证请求
    if (state._cancelToken != null)
      HttpChannel.channel.cancelRequest(state._cancelToken!);
    show();
    var model = state._rooms[state._roomIndex.value];
    /// 验证进入直播间
    await HttpChannel.channel.verifyLiveRoom(
      roomId: model.id!,
      cancelToken: (token) {
        state._cancelToken = token;
      }
    ).then((value) {
          state._cancelToken = null;
          return value.finalize(
            wrapper: WrapperModel(),
            failure: (e){
              showToast(e);
              state._disableRoom();
              state._setLivingRoomState(LivingRoomState.lackOfBalance);
            },
            success: (data) {
              dismiss();
              var channelName = data["channelName"];
              var token = data["channelToken"];
              var uid = data["channelUid"];
              // print("the channel is $channelId, the token is $token, the uid is $uid ----- ");
              EventBus.instance.notificationListener(parameter: data,
                name: verifyRoomSuccess);
              state._enterRoom(channelName: channelName, token: token, uid: uid);
              if (LiveRoomType.timer.rawValue == model.roomType ||
                LiveRoomType.ticket.rawValue == model.roomType){
                _freeTimerInitialize(model.seeTryTime ?? 0);
              }else {
                state._payEnterRoom();
              }
              /// 直播间信息
              roomInfo(roomId: model.id!);
              if (_onlineTimer != null) {
                _onlineTimer?.cancel();
                _onlineTimer = null;
              }
              /// 粉丝信息
              audienceNumber(roomId: model.id!);
            }
          );
    });
    return;
  }

  Timer? _onlineTimer;

  /// 观众数
  void audienceNumber({required String roomId}){
    if (_onlineTimer == null) {
      _onlineTimer = Timer.periodic(Duration(seconds: 5), (_) {
        audienceNumber(roomId: roomId);
      });
    }
    HttpChannel.channel.audienceNumber(roomId).then((value) {
      return value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data["audienceList"] ?? [];
          int onlineNumber = data["onlinenum"] ?? 0;
          state._setAudiences(lst.map((e) =>
            LivingAudienceEntity.fromJson(e)).toList(), onlineNumber);
        }
      );
    });
  }


  /// 更换房间
  void changeRoom({required int index,
    List<AnchorListModelEntity>? anchorListData}) {
    _freeTimer?.cancel();
    state._initFreeCount(-1);
    if (anchorListData != null)
      state._setRooms(anchorListData);
    state._setRoomIndex(index);
    state._disableRoom();
    _addRoom();
  }

  @override
  InternalFinalCallback<void> get onDelete {
    EventBus.instance.removeListener(_enterRoomSuccess,
      name: enterRoomSuccess);
    EventBus.instance.removeListener(_liverOffline, name: liverOffline);
    EventBus.instance.removeListener(_gameTimeOut, name: gameTimeOut);
    WidgetsBinding.instance?.removeObserver(this);
    state._initFreeCount(-1);
    _timer?.cancel();
    _onlineTimer?.cancel();
    _freeTimer?.cancel();
    return super.onDelete;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // todo 重连
    }
  }
}

class _LiveRoomNewState {

  /// 房间定位
  RxInt _roomIndex = (-1).obs;
  RxInt get roomIndex => _roomIndex;

  RxInt _freeTimeCount = (-1).obs;
  RxInt get freeTimeCount => _freeTimeCount;

  int? _cancelToken;

  String? _lastRoom;

  String _channelName = "";
  String get channelName => _channelName;

  String _token = "";
  String get token => _token;

  int _uid = -1;
  int get uid => _uid;

  /// 主播硬币
  RxInt _coins = (0).obs;
  RxInt get coins => _coins;

  /// 房间信息
  LiveRoomInfoEntity? _roomInfo;
  LiveRoomInfoEntity? get roomInfo => _roomInfo;

  /// 房间信息是否为空
  RxBool _roomInfoEmpty = true.obs;
  RxBool get roomInfoEmpty => _roomInfoEmpty;

  /// 房间是否有效
  RxBool _roomValid = false.obs;
  RxBool get roomValid => _roomValid;

  /// 是否关注
  RxBool _isFollowing = false.obs;
  RxBool get isFollowing => _isFollowing;

  /// 当前直播间发生异常
  Rx<LivingRoomState> _livingState = Rx(LivingRoomState.linking);
  Rx<LivingRoomState> get livingState => _livingState;

  /// 礼物
  RxList<GiftEntity> _gifts = RxList();
  RxList<GiftEntity> get gifts => _gifts;

  /// 观众数量
  RxList<LivingAudienceEntity> _audiences = RxList();
  RxList<LivingAudienceEntity> get audiences => _audiences;

  /// 观众人数
  RxInt _audience = 0.obs;
  RxInt get audience => _audience;

  /// 直播间
  RxList<AnchorListModelEntity> _rooms = RxList();
  RxList<AnchorListModelEntity> get rooms => _rooms;

  void _setRoomInfo(LiveRoomInfoEntity? info){
    _roomInfo = info;
    if (info?.isFollowed ?? false) {
      _following();
    }else {
      _cancelFollow();
    }
    _roomInfoEmpty.value = info == null;
    _coins.value = info?.coins ?? 0;
  }

  void _setCoins(int value){
    _coins.value = value;
  }

  void _setGifts(List<GiftEntity> gifts){
    this._gifts.value = gifts;
  }

  void _following(){
    this._isFollowing.value = true;
  }

  void _cancelFollow(){
    this._isFollowing.value = false;
  }

  void _disableRoom(){
    _roomValid.value = false;
    _roomInfoEmpty.value = true;
    _roomInfo = null;
    _coins.value = 0;
  }

  void _enableRoom(){
    _roomValid.value = true;
  }

  void _initFreeCount(int count){
    _freeTimeCount.value = count;
  }

  void _setRoomIndex(int index){
    if(index==-1){
      index=0;
    }
    if (_roomIndex.value != -1) {
      _lastRoom = _rooms[_roomIndex.value].id;
    }
    _roomIndex.value = index;
    _setLivingRoomState(LivingRoomState.linking);
  }

  void _setLivingRoomState(LivingRoomState state){
    _livingState.value = state;
  }

  void _setRooms(List<AnchorListModelEntity> data){
    _rooms.value = data;
  }

  void _enterRoom({
    required String channelName,
    required String token,
    required int uid
  }){
    this._channelName = channelName;
    this._token = token;
    this._uid = uid;
    // AgoraRtc.rtc.addChannel(channelId, token, uid);
  }

  Future<void> _leaveChannel() async{
    await AgoraRtc.rtc.leaveChannel();
    return;
  }

  Future _payEnterRoom(){
    return AgoraRtc.rtc.addChannel(channelName, token, uid);
  }

  void _setAudiences(List<LivingAudienceEntity> audience, int count){
    this._audiences.value = audience;
    this._audience.value = count;
  }
}

enum LivingRoomState {
  /// 余额不足 或其他失败原因
  lackOfBalance,
  /// 主播离线
  liverOffline,
  /// 连接中
  linking
}