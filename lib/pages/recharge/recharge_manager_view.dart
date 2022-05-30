import 'package:flutter/material.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:marquee/marquee.dart';
import '../../app_images/app_images.dart';
import '../../manager/app_manager.dart';
import '../../page_config/page_config.dart';
import 'recharge_page.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';

/*
 *  Description:  充值界面
 **/

class RechargeManagerPage extends StatefulWidget {
  @override
  createState() => _RechargeManagerPageState();
}

class _RechargeManagerPageState extends AppStateBase<RechargeManagerPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> titles = [
      "GOPAY",
      "QQ",
      "人工充值",
      "银联",
      "支付宝",
      "微信",
    ];

    return Scaffold(
        appBar: DefaultAppBar(
          automaticallyImplyLeading: false,
          leading: SizedBox.shrink(),
          title: CustomText("${intl.rechargeCentre}",
              fontSize: 16, color: Colors.white),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 10, top: 6),
              child: CustomText("${intl.customService}",
                  fontSize: 14, color:  Colors.white),
            ).gestureDetector(onTap: () {
              pushViewControllerWithName(AppRoutes.contactServicePage,
                  arguments: {
                    "url": AppManager.getInstance<GlobalSettingModel>()
                            .viewModel
                            .serviceUrl ??
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
                        color:  Colors.white),
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
                      child: CustomText("${intl.redeemDiamonds}",
                          fontSize: 12, color: Colors.white),
                    )).gestureDetector(onTap: () {
                  pushViewControllerWithName(AppRoutes.redeemDiamonds);
                })
              ]),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.red,
              elevation: 5.0,
            ),
          ),
          CustomTabBar(
            tabs: (_) => titles
                .map((e) => Container(
                      width: 100,
                      height: 60,
                      child: Row(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CustomDivider(
                                    color: AppMainColors.separaLineColor4,
                                    height: 0.5),
                                Container(
                                  height: 6,
                                ),
                                Image.asset(AppImages.announcement,
                                        width: 26, height: 26)
                                    .expanded(),
                                Container(
                                  child:
                                      Text(e, style: TextStyle(fontSize: 13)),
                                  padding: EdgeInsets.only(top: 6.0),
                                ).expanded(),
                                CustomDivider(
                                    color: AppMainColors.separaLineColor4,
                                    height: 0.5),
                              ]).expanded(),
                          Container(
                            width: 0.5,
                            height: 60,
                            color: AppMainColors.separaLineColor4,
                          ),
                        ],
                      ),
                    ))
                .toList(),
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor:  Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 0),
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
          TabBarView(children: [
            RechargePage(0),
            RechargePage(1),
            RechargePage(2),
            RechargePage(3),
            RechargePage(4),
            RechargePage(5),
          ], controller: _tabController)
              .expanded()
        ]));
  }
}
