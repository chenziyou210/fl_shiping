/*
 *  Copyright (C), 2015-2021
 *  FileName: live_new_logic
 *  Author: Tonight丶相拥
 *  Date: 2021/12/7
 *  Description: 
 **/

import 'dart:convert';

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/app_activity_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/pages/login/user_info_operation.dart';

import '../../generated/json/base/json_convert_content.dart';
import '../../i18n/i18n.dart';

class LiveHomeData extends GetxController with WidgetsBindingObserver ,Toast{

  LiveHomeData(){
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      UserInfoOperation().imLogIn();
    }
  }


  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete {
    WidgetsBinding.instance?.removeObserver(this);
    return super.onDelete;
  }

  final _LiveHomeState state = _LiveHomeState();


  Future getHomeTabData(BuildContext context){
    return HttpChannel.channel.cateGoryLabel()..then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data ?? [];
          List<HomeTabDataEntity> tabData = lst.map((e) => HomeTabDataEntity.fromJson(e)).toList();
          state._setData(tabData,context);

        }
    ));
  }

  Future appBannerLoad(){
    return HttpChannel.channel.advertiseBanner(advertiseType: 3)..then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data ?? [];
          List<HomeBannerEntity> banner = lst.map((e) => HomeBannerEntity.fromJson(e)).toList();
          state._setBannerData(banner);
        }
    ));
  }

  Future appAnnouncementLoad(){
    return HttpChannel.channel.announcementList(1)..then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data ?? [];
          List<HomeAnnouncementEntity> announcement = lst.map((e) => HomeAnnouncementEntity.fromJson(e)).toList();
          state._setAnnouncementData(announcement);
        }
    ));
  }

}

class HomeTabDataEntity {

  int? id;
  String? name;
  HomeTabDataEntity();

  // HomeTabDataEntity(int id,String name){
  //   this.id=id;
  //   this.name=name;
  // }

  factory HomeTabDataEntity.fromJson(Map<String, dynamic> json) => $HomeTabDataEntityFromJson(json);

  // Map<String, dynamic> toJson() => $ExchangeGiftListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

}

class HomeAnnouncementEntity {
  String? content;
  String? jumpPath;
  String? title;

  HomeAnnouncementEntity({this.content, this.jumpPath,this.title});

  HomeAnnouncementEntity.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    jumpPath = json['jumpPath'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['content'] = this.content;
    data['jumpPath'] = this.jumpPath;
    data['title'] = this.title;
    return data;
  }
}

class HomeBannerEntity {
  String? pic;
  String? url;

  HomeBannerEntity({this.pic, this.url});

  HomeBannerEntity.fromJson(Map<String, dynamic> json) {
    pic = json['pic'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pic'] = this.pic;
    data['url'] = this.url;
    return data;
  }
}


HomeTabDataEntity $HomeTabDataEntityFromJson(Map<String, dynamic> json) {
  final HomeTabDataEntity homeTabDataEntity = HomeTabDataEntity();

  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    homeTabDataEntity.id = id;
  }
  final String? labelName = jsonConvert.convert<String>(json['name']);
  if (labelName != null) {
    homeTabDataEntity.name = labelName;
  }
  return homeTabDataEntity;
}


class _LiveHomeState {
  RxList<HomeTabDataEntity> _homeTabdata = <HomeTabDataEntity>[].obs;
  RxList<HomeTabDataEntity> get homeTabdata => _homeTabdata;

  RxList<HomeBannerEntity> _homeBanner = <HomeBannerEntity>[].obs;
  RxList<HomeBannerEntity> get homeBanner => _homeBanner;

  RxList<HomeAnnouncementEntity> _homeAnnouncement = <HomeAnnouncementEntity>[].obs;
  RxList<HomeAnnouncementEntity> get homeAnnouncement => _homeAnnouncement;

  RxString _announcementString = "".obs;
  RxString get announcementString => _announcementString;

  void _setData(List<HomeTabDataEntity> value,BuildContext context){
    _homeTabdata.value = value;
    var attention=new HomeTabDataEntity();
    attention.name="${AppInternational.of(context).attention}";
    attention.id=1111;
    _homeTabdata.insert(0,attention);
  }

  void _setBannerData(List<HomeBannerEntity> value){
    _homeBanner.value = value;
  }

  void _setAnnouncementData(List<HomeAnnouncementEntity> value){
    _homeAnnouncement.value = value;
    for (var i = 0; i < value.length; i++) {
      _announcementString.value=_announcementString+"${i+1}. ${value[i].content}" +"    ";
    }

  }

}
