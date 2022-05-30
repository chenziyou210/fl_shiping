import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'dart:ui' as ui show Image, ImageFilter, TextHeightBehavior;

import 'my_mine_info_logic.dart';
import 'my_mine_info_state.dart';

/// @description:
/// @author
/// @date: 2022-05-25 12:15:59
class MyMineInfoPage extends StatelessWidget {
  final MyMineInfoLogic logic = Get.put(MyMineInfoLogic());
  final MyMineInfoState state = Get.find<MyMineInfoLogic>().state;

  MyMineInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            _bg(context),
            _title(context),
            Positioned(
              bottom: 16.pt,
              left: 0,
              right: 0,
              child: _avator(context),
            ),
          ],
        ),
        //资料
        _information(context),
        _userInfo(),
      ],
    );
  }

  Widget _bg(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Image.network(
            "http://file.qqtouxiang.com/meinv/2020-05-27/1cf7ba76d79039e71db1de18cea78d7a.jpeg",
            width: double.infinity,
            height: 360.pt,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          color: Colors.black.withAlpha(180),
          height: 360.pt,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withAlpha(200),
          ),
        ),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            logic.gotoBack(context);
          },
          child: Padding(
            padding: EdgeInsets.all(12.pt),
            child: Image.asset(
              AppImages.backIconWhite,
              width: 20.pt,
              height: 20.pt,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            logic.gotoEditUserInfo(context);
          },
          child: Padding(
            padding: EdgeInsets.all(12.pt),
            child: Image.asset(
              AppImages.ic_edit_profile,
              width: 24.pt,
              height: 24.pt,
            ),
          ),
        ),
      ],
    );
  }

  Widget _avator(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.pt),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80.pt,
                height: 80.pt,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                      "http://file.qqtouxiang.com/meinv/2020-05-27/1cf7ba76d79039e71db1de18cea78d7a.jpeg"),
                ),
              ),
              SizedBox(
                width: 40.pt,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _setText("15", "关注"),
                    _setText("50", "粉丝"),
                    _setText("123", "送出礼物"),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.pt),
            child: Text(
              "甜心布丁",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.pt,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "TA好像忘记签名了",
            style:
                TextStyle(color: AppColors.mine_wallet_text, fontSize: 12.pt),
          ),
        ],
      ),
    );
  }

  // 关注  粉丝  礼物
  Widget _setText(String value, String name) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 18.pt),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.pt),
          child: Text(
            name,
            style:
                TextStyle(color: AppColors.mine_wallet_text, fontSize: 12.pt),
          ),
        ),
      ],
    );
  }

  //  资料
  Widget _information(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.pt, left: 24.pt, right: 24.pt),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: _infoContribute(),
          ),
        ],
      ),
    );
  }

  //贡献
  Widget _infoContribute() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.pt, vertical: 3.pt),
                child: Text(
                  "资料",
                  style: TextStyle(
                      fontSize: 16.pt,
                      color: AppMainColors.string2Color("FF1EAF"),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                child: Image.asset(
                  AppImages.mine_info_ellipse,
                  width: 16.pt,
                  height: 16.pt,
                ),
                bottom: 0,
                right: 0,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.pt),
            padding: EdgeInsets.all(16.pt),
            decoration: BoxDecoration(
                color: AppColors.mine_wallet_gb,
                border:
                    Border.all(color: AppColors.mine_wallet_line, width: 1.pt),
                borderRadius: BorderRadius.all(Radius.circular(12.pt))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "个人贡献榜",
                      style: TextStyle(color: Colors.white, fontSize: 14.pt),
                    ),
                    SizedBox(
                      height: 8.pt,
                    ),
                    Text(
                      '收到4323火力值',
                      style: TextStyle(
                          color: AppColors.mine_wallet_text, fontSize: 12.pt),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100.pt,
                      child: Stack(
                        children: [
                          Positioned(
                            child: _avatorItem(0,
                                "http://file.qqtouxiang.com/meinv/2020-05-27/1cf7ba76d79039e71db1de18cea78d7a.jpeg"),
                          ),
                          Positioned(
                            left: 30.pt,
                            child: _avatorItem(1,
                                "http://touxiangkong.com/uploads/allimg/2021082611/kk3vleczyrq.jpg"),
                          ),
                          Positioned(
                            left: 60.pt,
                            child: _avatorItem(2,
                                "http://touxiangkong.com/uploads/allimg/2021082611/v1aqb1fiq54.jpg"),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      AppImages.mine_right,
                      width: 18.pt,
                      height: 18.pt,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatorItem(int index, String value) {
    return SizedBox(
      width: 40.pt,
      height: 40.pt,
      child: CircleAvatar(
        radius: 48,
        backgroundImage: NetworkImage(value),
      ),
    );
  }

  Widget _userInfo() {
    var list = ["ID:", "家乡:", "职业:", "年龄:", "感情:"];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.pt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "个人信息",
            style: TextStyle(color: Colors.white, fontSize: 16.pt),
          ),
          Container(
            margin: EdgeInsets.only(top: 12.pt),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return _userInfoItem(list[index], "123");
              }),
              itemCount: list.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfoItem(String name, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.pt),
      child: Row(
        children: [
          SizedBox(
            width: 60.pt,
            child: Text(
              name,
              style: TextStyle(color: AppColors.mine_wallet_text),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
