/*
 *  Copyright (C), 2015-2021
 *  FileName: furender_parameter_store
 *  Author: Tonight丶相拥
 *  Date: 2021/9/2
 *  Description: 
 **/


import 'dart:convert';
// import 'package:agora_rtc_engine/furender/furender.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class FuRenderParameterStore implements ValueChangeListener {
  @override
  Future<Map<String, dynamic>> getOriginalValue() async{
    // TODO: implement getOriginalValue
    return {};
  }

  @override
  void valueChange(Map<String, dynamic> map) {
    // TODO: implement valueChange
  }

  // SharedPreferences? _sharedPreferences;
  // final String _parameter = "fuRenderParameterSetting";
  // @override
  // void valueChange(Map<String, dynamic> map) async{
  //   // TODO: implement valueChange
  //   if (_sharedPreferences == null) {
  //     _sharedPreferences = await SharedPreferences.getInstance();
  //   }
  //   _sharedPreferences!.setString(_parameter, json.encode(map));
  // }
  //
  // Future<Map<String, dynamic>> getOriginalValue() async{
  //   if (_sharedPreferences == null) {
  //     _sharedPreferences = await SharedPreferences.getInstance();
  //   }
  //   String value = _sharedPreferences!.getString(_parameter) ?? "";
  //   Map<String, dynamic> dic;
  //   try {
  //     dic = json.decode(value);
  //   }catch(e) {
  //     dic = {};
  //   }
  //   return Future.value(dic);
  // }
}


mixin ValueChangeListener {
  Future<Map<String, dynamic>> getOriginalValue();
  void valueChange(Map<String, dynamic> map);
}