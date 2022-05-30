/*
 *  Copyright (C), 2015-2021
 *  FileName: screen_util_custom
 *  Author: Tonight丶相拥
 *  Date: 2021/11/3
 *  Description: 
 **/

part of appcommon;

class ScreenUtil {
  static ScreenUtil? _instance;
  factory ScreenUtil() => _instance ??= ScreenUtil._internal();
  ScreenUtil._internal();

  double _screenWidth = 0;
  double _screenHeight = 0;
  double _density = 1;
  double _pixelRatio = 3;

  void initialize({double designWidth = 375}) {
    _screenWidth = window.physicalSize.width / window.devicePixelRatio;
    _screenHeight = window.physicalSize.height / window.devicePixelRatio;
    _density = _screenWidth / designWidth;
    _pixelRatio = window.devicePixelRatio;
  }

  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;
  double get density => _density;
  double get pixelRatio => _pixelRatio;

  //状态栏高度
  double statueBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  //底部导航栏高度
  double bottomNavigationBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  // /// 判断键盘是否隐藏
  // Future<bool> isKeyboardHidden() async {
  //   // 如果窗口底部嵌入值不大于0，说明键盘未显示
  //   final check = () =>
  //   (WidgetsBinding.instance?.window.viewInsets.bottom ?? 0) <=
  //       100 * _pixelRatio;
  //   // 如果键盘显示，直接返回结果
  //   if (!check()) return false;
  //   // 如果键盘隐藏，为了应对键盘显隐动画过程时导致的误判，等待0.1秒后再次检测，返回结果
  //   return await Future.delayed(Duration(milliseconds: 100), check);
  // }
}



extension IntExtension on int {
  double get pt {
    // print("the density is ${ScreenUtil().density} ~~~");
    return ScreenUtil().density * this;
  }
  double get dp => ScreenUtil().pixelRatio * this;
}

extension DoubleExtension on double {
  // double get pt => ScreenUtil().density * this;
  double get pt {
    // print("the density is ${ScreenUtil().density} ~~~");
    return ScreenUtil().density * this;
  }
  double get dp => ScreenUtil().pixelRatio * this;
}