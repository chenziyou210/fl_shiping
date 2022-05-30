import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base/app_base.dart';
import '../../common/app_common_widget.dart';
import '../../http/http_channel.dart';
import '../../manager/app_manager.dart';

class RechargePage extends StatefulWidget {
  RechargePage(this.tag);

  final int tag;

  @override
  createState() => _RechargePageState();
}

class _RechargePageState extends AppStateBase<RechargePage> {
  List<String> amountList = [];
  List<String> paymentChannelsList = [
    "30-100",
    "支付宝小额",
    "支付宝大额",
    "支付宝小额",
    "支付宝大额",
    "支付宝小额",
    "支付宝大额",
    "支付宝小额",
  ];
  List<String> lists1 = [
    "10元",
    "10元",
    "10元",
    "10元",
    "10元",
    "10元",
    "10元",
    "10元",
    "10元",
    "10元",
  ];
  List<String> lists2 = [
    "40元",
    "40元",
    "40元",
    "40元",
    "40元",
    "40元",
    "40元",
    "40元",
    "40元",
    "40元",
  ];

  int channelsIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amountList.addAll(lists1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Container(
        child: RefreshIndicator(
            child: CustomScrollView(slivers: [
              SizedBox(height: 16).sliverToBoxAdapter,
              Container(
                  child: Column(children: [
                Row(
                  children: [
                    Container(width: 10),
                    Material(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.red,
                        elevation: 5.0,
                        child: Container(
                          width: 6,
                          height: 20,
                          padding: EdgeInsets.only(left: 10),
                        )),
                    CustomText("${intl.selectPaymentChannel}",
                            fontSize: 14, color:  Colors.white)
                        .paddingOnly(left: 10)
                  ],
                ),
                rechargeChannelSelection().paddingAll(10),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: CustomText(
                      "温馨提示:\n" +
                          "近期微信支付宝风控严重,如多次尝试无法成功充值请使用银行转账或人工客服,谢谢\n" +
                          "支付宝固定金额充值，请勿修改充值金额!\n" +
                          "如遇到充值未到账，请及时联系在线客服处理!\n" +
                          "超时支付，重复扫码，修改金额等错误方式无法自动到账!\n",
                      fontSize: 14,
                      color: Colors.red),
                ),

                Row(
                  children: [
                    Container(width: 10),
                    Material(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.red,
                        elevation: 5.0,
                        child: Container(
                          width: 6,
                          height: 20,
                          padding: EdgeInsets.only(left: 10),
                        )),
                    CustomText("${intl.selectRechargeAmount}",
                            fontSize: 14, color:  Colors.white)
                        .paddingOnly(left: 10)
                  ],
                ),
                rechargeAmountSelection().paddingAll(10),
                SizedBox(height: 10),
              ])).sliverToBoxAdapter
            ]),
            onRefresh: () async {
              await HttpChannel.channel
                  .userInfo()
                  .then((value) => value.finalize(
                      wrapper: WrapperModel(),
                      success: (data) {
                        AppManager.getInstance<AppUser>().fromJson(data, false);
                      }));
              return;
            }));
  }

  GridView rechargeAmountSelection() {
    return GridView.builder(
      physics: new NeverScrollableScrollPhysics(),
      //禁用滑动事件
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        childAspectRatio: 3.0,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10, //显示区域宽高相等
      ),
      itemCount: amountList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              showRechargeDialog(context, index);
            },
            child: Container(
                alignment: Alignment(0, 0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //设置四周边框
                  border: new Border.all(width: 1, color: Colors.red),
                ),
                child: CustomText(amountList[index],
                    fontSize: 14, color: Colors.red)));
      },
    );
  }

  Future<dynamic> showRechargeDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('提示'),
              content: Text("确定充值${amountList[index]}吗？"),
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

  GridView rechargeChannelSelection() {
    return GridView.builder(
      physics: new NeverScrollableScrollPhysics(),
      //禁用滑动事件
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        childAspectRatio: 3.0,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: paymentChannelsList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              setState(() {
                channelsIndex = index;
                if (channelsIndex % 2 == 0) {
                  amountList.clear();
                  amountList.addAll(lists1);
                } else {
                  amountList.clear();
                  amountList.addAll(lists2);
                }
              });
            },
            child: Container(
                alignment: Alignment(0, 0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //设置四周边框
                  border: new Border.all(
                      width: 1,
                      color:
                          channelsIndex == index ? Colors.red : Colors.black),
                ),
                child: CustomText(paymentChannelsList[index],
                    fontSize: 14,
                    color:
                        channelsIndex == index ? Colors.red : Colors.black)));
      },
    );
  }
}
