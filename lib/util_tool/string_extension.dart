/*
 *  Copyright (C), 2015-2021
 *  FileName: string_extension
 *  Author: Tonight丶相拥
 *  Date: 2021/12/17
 *  Description: 
 **/

extension StringExtension on String {
  String get getDateTime {
    /// 是否为空
    if (this.isEmpty)
      return this;
    /// 毫秒
    int? value;
    try{
      value = int.parse(this);
    }catch(_) {}
    /// 时间
    DateTime? time;
    if (value == null) {
      try{
        time = DateTime.parse(this);
      }catch(_) {}
    }else {
      try{
        time = DateTime.fromMillisecondsSinceEpoch(value);
        if (time.isAfter(DateTime.now())) {
          time = DateTime.fromMicrosecondsSinceEpoch(value);
        }
      }catch(_){}
    }
    if (time == null)
      return this;
    /// 返回时间
    return time.toIso8601String().replaceAll("T", " ").split(".").first;
  }
}