/*
 *  Copyright (C), 2015-2021
 *  FileName: token_mixin
 *  Author: Tonight丶相拥
 *  Date: 2021/7/29
 *  Description: 
 **/

part of appmanager;

mixin _TokenMixin {
  String? _token;
  DateTime? _expire;

  // json 设置token
  void _setTokenWithJson(Map<String, dynamic> json) {
    String? token = json[_tokenKey];
    _token = token;
    int? expire = json[_expireKey];
    _expire = DateTime.fromMillisecondsSinceEpoch(expire ?? 0);
  }

  void _save(){
    AppCacheManager.cache.setUserToken(_toString());
  }

  // string 设置token
  void _setTokenWithString(String? jsonStr) {
    Map<String, dynamic> json;
    try {
      json = jsonDecode(jsonStr!);
    }catch(_){
      json = {};
    }
    fromJson(json);
    // _setTokenWithJson(json, false);
  }

  // 转json
  Map<String, dynamic> toJson(){
    Map<String, dynamic> _dic = {};
    _dic[_tokenKey] = this._token;
    _dic[_expireKey] = this._expire?.millisecondsSinceEpoch;
    return _dic;
  }

  void fromJson(Map<String, dynamic> json, [bool needSetToken = true]);

  // 转string
  String _toString(){
    return jsonEncode(this.toJson());
  }

  // key
  final String _tokenKey = "token";
  final String _expireKey = "expire";
}