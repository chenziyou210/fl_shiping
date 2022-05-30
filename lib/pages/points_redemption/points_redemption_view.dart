import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/page_config/page_config.dart';

import 'points_redemption_logic.dart';

class PointsRedemptionPage extends StatefulWidget {
  @override
  createState()=> _PointsRedemptionPageState();
}

class _PointsRedemptionPageState extends State<PointsRedemptionPage> {

  final PointsRedemptionLogic _controller = PointsRedemptionLogic();

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
    Get.delete<PointsRedemptionLogic>();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    
    var intl = AppInternational.of(context);

    return Scaffold(
        appBar: DefaultAppBar(
          actions: [
            Image.asset(AppImages.scoreDescription).cupertinoButton(
              onTap: (){
                showDialog(context: context, builder: (_)=> _ScoreMallDescription());
              }
            ).padding(padding: EdgeInsets.only(right: 8)).center
          ],
          title: CustomText(intl.pointsMall,
            fontSize: 16,
            fontWeight: w_500,
            color: Color.fromARGB(255, 34, 40, 49)
          )
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              Image.asset(AppImages.points),
              SizedBox(width: 8),
              Obx((){
                return RichText(text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: w_400
                  ),
                  children: [
                    TextSpan(
                      text: "${state.remainPoint.value}",
                      style: TextStyle(
                        color: Color.fromARGB(255, 222, 68, 89)
                      )
                    ),
                    TextSpan(
                      text: intl.point,
                      style: TextStyle(
                        color: Colors.black
                      )
                    )
                  ]
                ));
              }),
              Spacer(),
              Row(
                children: [
                  Image.asset(AppImages.pointsExchange),
                  SizedBox(width: 8),
                  CustomText("${intl.exchangeRecord}",
                    fontSize: 14,
                    fontWeight: w_400,
                    color: Colors.black
                  )
                ]
              ).paddingSymmetric(vertical: 4, horizontal: 4).cupertinoButton(
                onTap: (){
                  Navigator.of(context).pushNamed(AppRoutes.pointsRedemptionRecord);
                }
              )
            ]
          ).padding(padding: EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: 16),
          RichText(text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: w_400
            ),
            children: [
              TextSpan(
                style: TextStyle(
                  color: Color.fromARGB(255, 222, 68, 89)
                ),
                text: "${intl.platformGift}  "
              ),
              TextSpan(
                text: "${intl.pointSpecial}",
                style: TextStyle(
                  color: Colors.black
                )
              )
            ]
          )).container(decoration: BoxDecoration(
            border: Border(left: BorderSide(
              width: 2,
              color: Color.fromARGB(255, 222, 68, 89)
            ))
          ), padding: EdgeInsets.only(left: 4)).padding(padding: EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: 8),
          Expanded(child: RefreshWidget(
            onRefresh: (c) async{
              await _controller.dataRefresh();
              c.refreshCompleted();
              c.resetNoData();
            },
            onLoading: (c) async{
              await _controller.loadMore();
              if (_controller.hasMoreData) {
                c.loadComplete();
              }else {
                c.loadNoData();
              }
            },
            enablePullUp: true,
            children: [
              Obx((){
                return SliverGrid(delegate: SliverChildBuilderDelegate((_, index) {
                  var model = state.data[index];
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 164,
                        child: Column(children: [
                          Container(
                            width: 164,
                            height: 164,
                            color: Color.fromARGB(255, 244, 244, 244),
                            child: ExtendedImage.network(model.picUrl ?? ""),
                          ),
                          SizedBox(height: 8),
                          SelectableText("${model.name}",
                            maxLines: 1,
                            enableInteractiveSelection: false,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: w_500,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              SelectableText("${model.point}${intl.point}",
                                maxLines: 1,
                                enableInteractiveSelection: false,
                                style: TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  color: Color.fromARGB(255, 222, 68, 89)
                                )
                              ).expanded(),
                              Container(
                                color: Color.fromARGB(255, 222, 68, 89),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: CustomText("${intl.exchange}",
                                  fontSize: 14,
                                  fontWeight: w_500,
                                  color: Colors.white
                                )
                              ).cupertinoButton(onTap: (){
                                _controller.exchangeGift(index);
                              })
                            ]
                          )
                        ], crossAxisAlignment: CrossAxisAlignment.start))
                    ],
                  );
                }, childCount: state.data.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 230
                ));
              })
            ]
          ))
        ]
      )
    );
  }
}

class _ScoreMallDescription extends AlertDialog {

  final intl = AppInternational.current;

  @override
  // TODO: implement contentPadding
  EdgeInsetsGeometry get contentPadding => EdgeInsets.zero;

  @override
  // TODO: implement content
  Widget? get content => Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          color: Color.fromARGB(255, 222, 68, 89),
          child: CustomText("${intl.pointDescription}",
            fontSize: 16,
            fontWeight: w_600,
            color: Colors.white
          ).center
        ),
        SizedBox(height: 32),
        CustomText("${intl.pointDescriptionDetail}",
          fontSize: 12,
          fontWeight: w_500,
          color: Color.fromARGB(255, 100, 102, 106)
        ).paddingSymmetric(horizontal: 16),
        SizedBox(height: 64)
      ]
    )
  );
}