/*
 *  Copyright (C), 2015-2022
 *  FileName: package_view
 *  Author: Tonight丶相拥
 *  Date: 2022/4/25
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/gift_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import '../../../../common/app_styles.dart';
import '../../../../common/colors.dart';
import '../../../../manager/app_manager.dart';
import '../gift_card/gift_card.dart';

import '../../../../generated/package_gift_entity.dart';

class PackageView extends StatefulWidget {
  @override
  createState()=> _PackageViewState();
}

class _PackageViewState extends State<PackageView> with AutomaticKeepAliveClientMixin {

  List<PackageGiftEntity> _gifts = [];

  late final Future future;

  /// 页码控制器
  final PageController _controller = PageController();

  /// 礼物坐标
  GiftIndex _index = GiftIndex();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    future = HttpChannel.channel.userPackageList();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    var intl = AppInternational.of(context);

    return Container(
      child: [LoadingWidget(
        placeHolderBuilder: (_)=> Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.packageEmpty),
            SizedBox(height: 16),
            CustomText("${intl.dataEmpty}",
              fontSize: 14,
              fontWeight: w_500,
              color: Color.fromARGB(255, 109, 112, 133)
            )
          ]
        ),
        builder: (_, snapshot) {
          List data = snapshot.data.data["data"];
          _gifts = data.map((e) => PackageGiftEntity.fromJson(e)).toList();
          return Container(
            child: Column(
              children: [
                Expanded(
                    child: PageView.builder(
                        itemCount: _gifts.length % 8 != 0 ?
                        (_gifts.length ~/ 8 + 1)
                            : _gifts.length ~/ 8,
                        itemBuilder: (_, int page) {
                          List<PackageGiftEntity> data = (page + 1) * 8 > _gifts.length ?
                          _gifts.getRange(page * 8, _gifts.length).toList()
                              : _gifts.getRange(page * 8, (page + 1) * 8).toList();
                          // var e = widget.gifts[index];
                          return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: 113
                              ),
                              itemBuilder: (_, index) {
                                var model = data[index];
                                Widget widget = GiftCard(GiftEntity()
                                  ..picurl = model.giftImg
                                  ..coins = model.remainQuantity.toString()
                                  ..name = model.giftName
                                );
                                if (page == _index.page && index == _index.index) {
                                  widget = Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(255, 31, 34, 51).withOpacity(0.5)
                                    ),
                                    child: widget,
                                  );
                                  widget = CustomGradientBorderContainer(
                                    child: widget,
                                    strokeWidth: 0.5,
                                    radius: 10,
                                    gradient: LinearGradient(colors: AppColors.buttonGradientColors),
                                  );
                                  widget = CustomGradientBorderContainer(
                                    child: widget,
                                    strokeWidth: 0.5,
                                    radius: 10,
                                    gradient: LinearGradient(colors: AppColors.buttonGradientColors),
                                  );
                                }else {
                                  widget = GestureDetector(
                                      child: widget,
                                      onTap: (){
                                        _index.setLocation(page, index);
                                        setState(() {});
                                      }
                                  );
                                }
                                return widget;
                              }, //physics: NeverScrollableScrollPhysics(),
                              itemCount: data.length
                          );
                        }, controller: _controller)),
                SizedBox(height: 8),
                DotsIndicatorNormal(controller: _controller,
                    unSelectColor: Colors.red,
                    onPageSelected: (index) {
                      _controller.animateToPage(index, duration: Duration(
                          milliseconds: 100
                      ), curve: Curves.easeIn);
                    },
                    itemCount: _gifts.length % 8 != 0 ? (_gifts.length ~/ 8 + 1)
                        : _gifts.length ~/ 8),
                SizedBox(height: 8),
              ]
            )
          );
        },
        future: future
      ).expanded(), SizedBox(height: 16),
        Row(
          children: [
            Image.asset(AppImages.coin),
            SizedBox(width: 8),
            SelectorCustom<AppUser, double?>(builder: (value) {
              return Text.rich(TextSpan(
                  text: intl.diamond,
                  style: AppStyles.f15w500c255_255_255,
                  children: [
                    TextSpan(
                      text: ": ${value ?? 0}",
                      style: AppStyles.f15w500c255_199_0
                    )
                  ]
              ));
            }, selector: (a) => a.lockMoney),
            Spacer(),
            CustomDropDownButton("$_number",
              isBottom: false,
              iconColor: Colors.white,
              textColor: Colors.white,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20)
              ),
              popChildBuilder: ()=> Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _gift.map((e) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText("${e.number}",
                            fontSize: 12,
                            fontWeight: w_400,
                            color: Colors.white,
                          ).sizedBox(width: 30),
                          SizedBox(width: 16),
                          CustomText("${e.description}",
                              fontSize: 12,
                              fontWeight: w_400,
                              color: Color.fromARGB(255, 255, 89, 95)
                          )
                        ]
                    )
                ).cupertinoButton(onTap: (){
                  _number = e.number;
                  Navigator.of(context).pop();
                  setState(() {});
                }, miniSize: 30)).toList(),
              ).singleScrollView().container(
                 decoration: ShapeDecoration(
                      color: Color.fromARGB(255, 57, 61, 81),
                      shape: BottomTriangleBorder(
                          offsetX: 40,
                          borderRadius: BorderRadius.circular(7),
                          triangleWidth: 20,
                          fillColor: Color.fromARGB(255, 57, 61, 81)
                      )
                  ),
                  height: 175
              )),
            SizedBox(width: 8),
            Container(
              height: 34,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                gradient: LinearGradient(
                  colors: AppColors.buttonGradientColors
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(intl.giving,
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: w_400
                  )
                ]
              ),
            ).cupertinoButton(onTap: (){
              if (!_index.isZero()) {
                Navigator.of(context).pop();
                return;
              }
              var model = _gifts[_index.page * 8 + _index.index];
              Navigator.of(context).pop(GiftModel(model.giftId!, "$_number", model.giftName!, 2));
            }),
            SizedBox(width: 8)
          ]
        )
      ].column()
    );
  }

  int _number = 1;

  AppInternational get intl => AppInternational.current;

  List<GiftDescriptionEntity> get _gift => [
    GiftDescriptionEntity(1314, "${intl.inAllOnesLife}"),
    GiftDescriptionEntity(520, "${intl.iLoveYou}"),
    GiftDescriptionEntity(188, "${intl.wantToHug}"),
    GiftDescriptionEntity(66, "${intl.sixSixLucky}"),
    GiftDescriptionEntity(10, "${intl.perfect}"),
    GiftDescriptionEntity(1, "${intl.undividedAttention}")
  ];
}