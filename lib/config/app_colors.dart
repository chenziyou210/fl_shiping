import 'package:flutter/cupertino.dart';
import 'dart:math';

class AppMainColors {
  ///随机色
  static Color RandomColor = Color.fromRGBO(
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1);

  ///主题色
  /* 用于重要场景、主按钮、icon选中、文字*/
  static const Color mainColor = Color(0xffFF1EAF);
  // 1  0
  // 0  1 对脚线渐变
  static const Color mainGradientStartColor = Color(0xffFF65C8);
  static const Color mainGradientEndColor = mainColor;

  ///点缀色
  /*用于重要icon、次要按钮、金额、提示文*/
  static const Color adornColor = Color(0xff32C5FF);
  // 1  0
  // 0  1 对脚线渐变
  static const Color adornGradientStartColor = Color(0xff9BA5FF);
  static const Color adornGradientEndColor = adornColor;

  ///背景色
  /*用于页面背景*/
  static const Color backgroudColor = Color(0xff101010);

  ///appbae背景色
  /*用于页面背景*/
  static const Color appbarColor = Color(0xff202020);

  ///搜索边框色
  static const Color searchBorderColor = Color(0x66FFFF01);

  ///辅助色
  /*用于数字上升、金额变动为正数*/
  static const Color assistColor = Color(0xffEC9718);

  ///白色
  /*用于重要突出文字、正标题、输入后文字  数字代表透明度*/
  static const Color whiteColor100 = Color(0xffFFFFFF);
  /*用于副标题、长篇正文*/
  static const Color whiteColor70 = Color(0xB3FFFFFF);
  /*用于层次较弱文字、未输入前提示文字*/
  static const Color whiteColor40 = Color(0x66FFFFFF);
  /*用于层次较弱文字、未输入前提示文字度*/
  static const Color textColor20 = Color(0x33FFFFFF);

  static const Color whiteColor20 = Color(0x33FFFFFF);
  /*用于层次较弱文字、未输入前提示文字度*/
  static const Color whiteColor15 = Color(0x0fFFFFFF);
  /*用于层次较弱文字、未输入前提示文字度*/
  static const Color whiteColor10 = Color(0x0aFFFFFF);
  /*用于层次较弱文字、未输入前提示文字度*/
  static const Color whiteColor0 = Color(0x00FFFFFF);
  static const Color whiteColor6 = Color(0x0FFFFFFF);

  ///黑色
  /*用于层次较弱文字、未输入前提示文字度*/
  static const Color blackColor0 = Color(0x00000000);
  /*用于层次较弱文字、未输入前提示文字度*/
  static const Color blackColor70 = Color(0xB3000000);

  ///分割线
  /*用于顶部条或底部条分层分割 && 用于卡片底色、内容底色  数字代表透明度*/
  static const Color separaLineColor10 = Color(0x1AFFFFFF);
  /*用于卡片底色、内容底色*/
  static const Color separaLineColor6 = Color(0x0DFFFFFF);
  static const Color separaLineColor4 = Color(0x0AFFFFFF);

  // 粉色0.2
  static Color pink20 = Color.fromRGBO(255, 30, 175, 0.2);

  // 颜色值转换
  static Color string2Color(String colorString) {
    int? value = 0x00000000;
    if (colorString.isNotEmpty) {
      if (colorString[0] == '#') {
        colorString = colorString.substring(1);
      }
      value = int.tryParse(colorString, radix: 16);
      if (value != null) {
        if (value < 0xFF000000) {
          value += 0xFF000000;
        }
      }
    }
    return Color(value!);
  }

  //首页推荐，直播item-左上角标签
  static const List<Color> gameLabelGradient = [
    Color(0xFFFF1EAF),
    Color(0xFFFC6868)
  ];
  static const List<Color> rankBgGradient = [
    Color(0xFFEC9718),
    Color(0xFFECBB3C)
  ];

  static const List<Color> fireGradient = [
    Color(0xFFFF4EF8),
    Color(0xFFFFA572)
  ];
  static const List<Color> anchorGradient = [
    Color(0xFF9BA5FF),
    Color(0xFF32C5FF)
  ];
}
