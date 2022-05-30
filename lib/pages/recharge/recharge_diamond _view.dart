import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import '../../app_images/app_images.dart';
import '../../http/http_channel.dart';
import '../../manager/app_manager.dart';
import '../../page_config/page_config.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';

/*
 *  Description:  兑换钻石
 **/

class RechargeDiamondPage extends StatefulWidget {
  @override
  createState() => _RechargeDiamondPageState();
}

class _RechargeDiamondPageState extends AppStateBase<RechargeDiamondPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> amountList = [
      "10",
      "20",
      "30",
      "40",
      "50",
      "60",
      "70",
      "80",
      "90",
      "100",
    ];

    return Scaffold(
        appBar: DefaultAppBar(
          leading: CustomBackButton(
              icon: Image.asset(AppImages.backIconWhite,width: 14)
          ),
          title: CustomText("${intl.redeemDiamonds}",
              fontSize: 16, color: Colors.white),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 10, top: 6),
              child: CustomText("${intl.customService}",
                  fontSize: 14, color: Colors.white),
            ).gestureDetector(onTap: () {
              pushViewControllerWithName(AppRoutes.contactServicePage,
                  arguments: {
                    "url":
                    // AppManager.getInstance<GlobalSettingModel>()
                    //         .viewModel
                    //         .serviceUrl ??
                        "https://www.baidu.com",
                    "title": "${intl.customService}",
                  });
            }),
          ],
        ),
        body: Column(children: [
          SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomText("${intl.information}",
                    fontSize: 14, color: Colors.white)
                .padding(padding: EdgeInsets.only(left: 10, right: 4)),
            Marquee(
                    text: "充值50元气，最高加赚28.88元，累计充值更可获得更多奖励",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: w_500,
                        color: Colors.white),
                    scrollAxis: Axis.horizontal,
                    velocity: 100.0,
                    blankSpace: 259.pt,
                    accelerationCurve: Curves.linear,
                    decelerationCurve: Curves.easeOut)
                .sizedBox(height: 34.pt)
                .expanded(),
          ]),
          Container(
            alignment: Alignment.center,
            height: 120,
            padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 10),
            child: Material(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText("${intl.balance}",
                            fontSize: 13, color: Colors.white),
                        CustomText(
                            "${AppManager.getInstance<AppUser>().lockMoney}",
                            fontSize: 16,
                            color: Colors.yellow),
                      ]),
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomText("${intl.diamond}",
                      fontSize: 13, color: Colors.white),
                  CustomText("${AppManager.getInstance<AppUser>().coins}",
                      fontSize: 16, color: Colors.yellow),
                ]).expanded(),
                Material(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                    color: Colors.yellow,
                    elevation: 5.0,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 6, bottom: 6, right: 10),
                      child: CustomText("${intl.recharge}",
                          fontSize: 12, color: Colors.white),
                    )).gestureDetector(onTap: () {
                  Navigator.of(context).pop();
                })
              ]),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.red,
              elevation: 5.0,
            ),
          ),
          RefreshIndicator(
              child: diamondRechargeList(amountList).paddingAll(10),
              onRefresh: () async {
                await HttpChannel.channel
                    .userInfo()
                    .then((value) => value.finalize(
                        wrapper: WrapperModel(),
                        success: (data) {
                          AppManager.getInstance<AppUser>()
                              .fromJson(data, false);
                        }));
                return;
              })
        ]));
  }

  GridView diamondRechargeList(List<String> amountList) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        childAspectRatio: 2.6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 14,
      ),
      itemCount: amountList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              showRechargeDiamondDialog(context, amountList, index);
            },
            child: Column(
              children: [
                Container(
                    alignment: Alignment(0, 0),
                    decoration: new BoxDecoration(
                      color: Colors.pink,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: CustomText("${amountList[index]}${intl.diamond}",
                        fontSize: 14, color: Colors.white)),
                Container(
                    alignment: Alignment(0, 0),
                    decoration: new BoxDecoration(
                      color: Colors.pink,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child:
                        CustomText("100元", fontSize: 14, color: Colors.white)),
              ],
            ));
      },
    );
  }

  Future<dynamic> showRechargeDiamondDialog(
      BuildContext context, List<String> amountList, int index) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('提示'),
              content: Text("确定消耗100元兑换${amountList[index]}${intl.diamond}"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("取消"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("确定"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
