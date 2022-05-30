import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'my_fans_logic.dart';
import 'my_fans_state.dart';

/// @description:
/// @author
/// @date: 2022-05-25 18:52:49
class MyFansPage extends StatelessWidget with Toast {
  final MyFansLogic logic = Get.put(MyFansLogic());
  final MyFansState state = Get.find<MyFansLogic>().state;

  MyFansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyFansLogic>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppMainColors.backgroudColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(35.pt),
            child: _header(),
          ),
          title: Column(
            children: [
              Text(
                'LUCKY',
                style:
                    TextStyle(color: AppMainColors.whiteColor100, fontSize: 18),
              ),
            ],
          ),
        ),
        body: _body(),
      );
    });
  }

  Widget _body() {
    return SmartRefresher(
      controller: state.refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () {
        logic.requestPage(0);
      },
      onLoading: () {
        logic.requestPage(0);
      },
      child: PageView.builder(
        controller: state.pageController,
        itemCount: 2,
        itemBuilder: (c, i) {
          return _page(i);
        },
        onPageChanged: (i) {
          if (i == 0) {
            logic.setFollowOrFans(true);
          } else {
            logic.setFollowOrFans(false);
          }
          state.refreshController.requestRefresh();
        },
      ),
    );
  }
  //header

  _header() {
    return Container(
      height: 35.pt,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SizedBox(),
            InkWell(
              onTap: () {
                logic.setFollowOrFans(true);
              },
              child: Column(
                children: [
                  Text(state.titles[0],
                      style: TextStyle(
                          color: state.folowOrFans
                              ? AppMainColors.whiteColor100
                              : AppMainColors.textColor20,
                          fontSize: 16.pt)),
                  state.folowOrFans
                      ? Image.asset(AppImages.ic_line_colors)
                      : Container(),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                logic.setFollowOrFans(false);
              },
              child: Column(
                children: [
                  Text(state.titles[1],
                      style: TextStyle(
                          color: state.folowOrFans
                              ? AppMainColors.textColor20
                              : AppMainColors.whiteColor100,
                          fontSize: 16.pt)),
                  state.folowOrFans
                      ? Container()
                      : Image.asset(AppImages.ic_line_colors)
                ],
              ),
            ),
            SizedBox(),
          ]),
          Container(
              width: double.infinity,
              height: 0.5.pt,
              color: AppMainColors.textColor20),
        ],
      ),
    );
  }

  _page(int index) {
    return state.listData.isEmpty
        ? Container(
            child: Text(
              "Empty View",
              style: TextStyle(color: Colors.white),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.listData.length,
            itemBuilder: ((context, index) {
              return _item(state.listData[index]);
            }),
          );
  }

  _item(var dataValue) {
    return Padding(
      padding: EdgeInsets.all(8.pt),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8.pt),
            margin: EdgeInsets.all(4.pt),
            width: 70.pt,
            height: 70.pt,
            child: CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(dataValue['header']),
              child: Container(
                alignment: Alignment(0, .5),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 80.pt,
                      child: Text(
                        "${dataValue['username']}",
                        style: TextStyle(color: AppMainColors.whiteColor100),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    showLevel(dataValue),
                  ],
                ),
                SizedBox(
                  height: 8.pt,
                ),
                Row(
                  children: [
                    showSex(dataValue),
                    SizedBox(
                      width: 180.pt,
                      child: Text(
                        "${dataValue['signature'] ?? "TA好像忘记签名了"}".isEmpty
                            ? "TA好像忘记签名了"
                            : dataValue['signature'],
                        maxLines: 1,
                        style: TextStyle(color: Colors.grey, fontSize: 12.pt),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _but(),
        ],
      ),
    );
  }

  Widget showSex(var data) {
    return Image.asset(
      data['sex'] == 1 ? AppImages.ic_mine_man : AppImages.ic_mine_woman,
      width: 18.pt,
      height: 18.pt,
    );
  }

  Widget showLevel(var data) {
    var live = data['rank'] ?? 1;
    var colors = AppMainColors.string2Color("FFBC13");
    if (live < 10) {
      colors = AppMainColors.string2Color("FFBC13");
    } else if (live < 20 && live > 10) {
      colors = AppMainColors.string2Color("4085EF");
    } else if (live < 30 && live > 20) {
      colors = AppMainColors.string2Color("8222FF");
    } else if (live < 40 && live > 30) {
      colors = AppMainColors.string2Color("ED23F1");
    } else if (live < 50 && live > 40) {
      colors = AppMainColors.string2Color("FF2B2B");
    } else {
      colors = AppMainColors.string2Color("000000");
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.pt),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.6,
            child: Container(
              width: 35.pt,
              height: 16.pt,
              padding: EdgeInsets.symmetric(horizontal: 8.pt, vertical: 2.pt),
              decoration: BoxDecoration(
                color: colors,
                border:
                    Border.all(color: AppColors.mine_wallet_line, width: 1.pt),
                borderRadius: BorderRadius.all(
                  Radius.circular(15.pt),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.ic_mine_level1,
                    width: 12.pt,
                    height: 12.pt,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      "$live",
                      style: TextStyle(color: Colors.white, fontSize: 10.pt),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _but() {
    return InkWell(
      onTap: () {
        state.refreshController.requestRefresh();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.pt, vertical: 2.pt),
        decoration: BoxDecoration(
          color: AppColors.mine_wallet_gb,
          border: Border.all(color: AppColors.mine_wallet_line, width: 1.pt),
          borderRadius: BorderRadius.all(
            Radius.circular(16.pt),
          ),
        ),
        child: Text(
          "已关注",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
