import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/i18n/i18n.dart';

import 'points_redemption_record_logic.dart';

class PointsRedemptionRecordPage extends StatefulWidget {
  @override
  createState()=> _PointsRedemptionRecordPageState();
}

class _PointsRedemptionRecordPageState extends State<PointsRedemptionRecordPage> {

  final PointsRedemptionRecordLogic _controller = PointsRedemptionRecordLogic();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<PointsRedemptionRecordLogic>();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    var intl = AppInternational.of(context);

    return Scaffold(
      appBar: DefaultAppBar(
        title: CustomText("${intl.exchangeRecord}",
          fontSize: 16,
          color: Color.fromARGB(255, 34, 40, 49),
          fontWeight: w_500
        )
      ),
      body: Column(
        children: [
          RefreshWidget(
            enablePullUp: true,
            onLoading: (c) async{
              await _controller.loadMore();
              if (_controller.hasMoreData) {
                c.loadComplete();
              }else {
                c.loadNoData();
              }
            },
            onRefresh: (c) async{
              await _controller.dataRefresh();
              c.refreshCompleted();
              c.resetNoData();
            },
            children: [
              Obx((){
                return SliverList(delegate: SliverChildBuilderDelegate((_, index) {
                  var model = state.data[index];
                  return Container(
                    child: Column(
                        children: [
                          Row(
                              children: [
                                CustomText("${intl.redeemGift}：",
                                  fontSize: 14,
                                  fontWeight: w_400,
                                  color: Color.fromARGB(255, 81, 77, 77)
                                ).expanded(),
                                ExtendedImage.network(model.giftImg ?? "",
                                  width: 36,
                                  height: 36,
                                )
                              ]
                          ),
                          SizedBox(height: 8),
                          CustomDivider(),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              CustomText("${intl.consumePoints}:",
                                fontSize: 14,
                                fontWeight: w_400,
                                color: Color.fromARGB(255, 81, 77, 77)
                              ).expanded(),
                              CustomText("${model.totalPointAmount}",
                                fontSize: 14,
                                fontWeight: w_600,
                                color: Color.fromARGB(255, 228, 31, 39)
                              )
                            ]
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              CustomText(intl.exchangeTime + ":",
                                fontSize: 14,
                                fontWeight: w_400,
                                color: Color.fromARGB(255, 81, 77, 77)
                              ).expanded(),
                              CustomText("${DateTime.fromMillisecondsSinceEpoch(model.updateTime ?? 0)}"
                                .replaceAll("T", " ").split(".")[0],
                                fontSize: 14, fontWeight: w_400,
                                color: Color.fromARGB(255, 81, 77, 77)
                              )
                            ]
                          )
                        ]
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 8) + EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                  );
                }, childCount: state.data.length));
              })
            ]
          ).expanded()
        ]
      )
    );
  }
}
