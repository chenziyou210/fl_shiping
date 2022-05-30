import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_images/app_images.dart';
import 'my_mine_logic.dart';
import 'my_mine_state.dart';

/// @description:
/// @author  Austin  个人中心
/// @date: 2022-05-24 16:16:17
class MyMinePage extends StatelessWidget {
  final MyMineLogic logic = Get.put(MyMineLogic());
  final MyMineState state = Get.find<MyMineLogic>().state;

  MyMinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyMineLogic>(builder: (c) {
      if (state.context == null) {
        state.context = context;
        logic.update();
      }
      return Scaffold(
        body: SafeArea(child: body(context)),
      );
    });
  }

  Widget body(BuildContext context) {
    return SmartRefresher(
      controller: state.refreshController,
      onRefresh: () {
        logic.requestUserInfo();
      },
      onLoading: () {},
      child: state.data == null
          ? Text(
              "数据加载中...",
              style: TextStyle(fontSize: 18.pt, color: Colors.white),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  setBut(context),
                  avatar(context),
                  attention(),
                  Column(
                    children: [
                      wallet(),
                      banner(),
                      groupGbView(goupList(state.gameGroup, state.img)),
                      groupGbView(goupList(state.editGroup, state.imgs)),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // 设置
  Widget setBut(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            logic.gotoSetting(context);
          },
          child: Padding(
            padding: EdgeInsets.all(12.0.pt),
            child: Image.asset(
              AppImages.mine_setting,
              width: 28.pt,
              height: 28.pt,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }

  Widget avatar(BuildContext context) {
    return InkWell(
      onTap: () {
        logic.gotoUserInfo(context);
      },
      child: Padding(
        padding: EdgeInsets.all(12.pt),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(
                  "http://file.qqtouxiang.com/meinv/2020-05-27/1cf7ba76d79039e71db1de18cea78d7a.jpeg"),
              child: Container(
                alignment: Alignment(0, .5),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.pt),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          state.data['username'] ?? "加载中...",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.pt),
                        ),
                        showLevel(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.pt),
                      child: Text(
                        "ID:${state.data['shortId'] ?? 0}",
                        style: TextStyle(color: Colors.white, fontSize: 12.pt),
                      ),
                    ),
                    //
                    Row(
                      children: [
                        showSex(),
                        Text(
                          "${state.data['signature'] ?? "TA好像忘记签名了"}".isEmpty
                              ? "TA好像忘记签名了"
                              : state.data['signature'],
                          style: TextStyle(color: Colors.grey, fontSize: 12.pt),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              AppImages.mine_right,
              width: 18.pt,
              height: 18.pt,
            ),
          ],
        ),
      ),
    );
  }

  Widget attention() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(),
        attentionItem('${state.data['attentionNum'] ?? 0}', '关注'),
        Container(
          height: 14.pt,
          width: 1.pt,
          color: Colors.grey,
        ),
        attentionItem('${state.data['fansNum'] ?? 0}', '粉丝'),
        Container(),
      ],
    );
  }

  Widget attentionItem(String data, String name) {
    return GestureDetector(
      onTap: () {
        logic.gotoFollowAndFans(state.context!, name == '关注' ? 0 : 1);
      },
      child: Column(
        children: [
          Text(
            data,
            style: TextStyle(fontSize: 14.pt, color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.pt),
            child: Text(
              name,
              style: TextStyle(fontSize: 12.pt, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget wallet() {
    return Container(
      margin: EdgeInsets.all(8.pt),
      padding: EdgeInsets.all(6.pt),
      decoration: BoxDecoration(
        color: AppColors.mine_wallet_gb,
        border: Border.all(color: AppColors.mine_wallet_line, width: 1.pt),
        borderRadius: BorderRadius.all(
          Radius.circular(12.pt),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          walletItem(AppImages.mine_wallet1, "钱包"),
          walletItem(AppImages.mine_wallet2, "提现"),
          walletItem(AppImages.mine_wallet3, "贵族"),
          walletItem(AppImages.mine_wallet4, "活动"),
          walletItem(AppImages.mine_wallet5, "推广"),
        ],
      ),
    );
  }

  Widget walletItem(
    String iamges,
    String name,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iamges,
          width: 48.pt,
          height: 48.pt,
          fit: BoxFit.cover,
        ),
        Text(
          name,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget banner() {
    return Container(
      height: 160.pt,
      alignment: Alignment.center,
      width: double.infinity,
      color: AppColors.mine_wallet_gb,
      child: Text(
        "Banner",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget groupGbView(Widget view) {
    return Container(
      color: AppColors.mine_wallet_line,
      margin: EdgeInsets.symmetric(horizontal: 16.pt, vertical: 4.pt),
      child: view,
    );
  }

  Widget goupList(List data, List<String> img) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.mine_wallet_line,
          borderRadius: BorderRadius.all(Radius.circular(12.pt))),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return GestureDetector(
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.pt, vertical: 16.pt),
                  child: Row(
                    children: [
                      Image.asset(
                        img[index],
                        width: 24.pt,
                        height: 24.pt,
                      ),
                      SizedBox(width: 24),
                      Text(
                        data[index],
                        style: TextStyle(color: Colors.white),
                      ).expanded(),
                      Image.asset(
                        AppImages.mine_right,
                        width: 18.pt,
                        height: 18.pt,
                      ),
                    ],
                  ),
                ),
                index == data.length - 1
                    ? Container()
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.pt),
                        height: 1.pt,
                        color: AppColors.mine_wallet_line,
                      ),
              ],
            ),
            onTap: () {
              logic.mineItemEvent(data[index], context);
            },
          );
        }),
        itemCount: data.length,
      ),
    );
  }

  Widget showSex() {
    return Image.asset(
      state.data['sex'] == 1 ? AppImages.ic_mine_man : AppImages.ic_mine_woman,
      width: 18.pt,
      height: 18.pt,
    );
  }

  Widget showLevel() {
    var live = state.data['rank'] ?? 1;
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
    return Stack(
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
    );
  }
}
