
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/car_list_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';

class CarBuy extends StatefulWidget {
  final CarListEntity model;
  CarBuy(this.model);
  @override
  createState()=> _CarBuyState(model);
}

class _CarBuyState extends State<CarBuy> with Toast{
  _CarBuyState(this.model);
  final CarListEntity model;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String m = AppImages.month_us;
    String d = AppImages.jidu_us;
    String y = AppImages.nianka_us;
    if (AppInternational.current is $zh_CN){
      m = AppImages.month_zh;
      d = AppImages.jidu_zh;
      y = AppImages.nianka_zh;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(model.carName,
                fontWeight: w_500,
                fontSize: 14.pt,
                color: Colors.black,
              ),
              SizedBox(width: 8,),
              ExtendedImage.network(model.carStaticUrl, width: 62.pt),
            ]
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Card(m, AppImages.month_xuanzhong,
                    onTap: (){
                      if (_index == 0)
                        return;
                      _index = 0;
                      setState(() {});
                    }, show: _index == 0,
                  title: AppInternational.current.superCarMonthMember,
                  nowPrice: model.monthPrice.toString(),
                  unit: AppInternational.current.month,
                ),
                SizedBox(height: 16),
                _Card(d, AppImages.jiduxuanzhong,
                    onTap: (){
                      if (_index == 1)
                        return;
                      _index = 1;
                      setState(() {});
                    }, show: _index == 1,
                  title: AppInternational.current.superCarJiDuMember,
                  nowPrice: model.quarterSpecialPrice.toString(),
                  orgPrice: model.quarterOriginalPrice.toString(),
                  unit: AppInternational.current.jiDu,
                ),
                SizedBox(height: 16),
                _Card(y, AppImages.nianxuanzhong,
                    onTap: (){
                      if (_index == 2)
                        return;
                      _index = 2;
                      setState(() {});
                    }, show: _index == 2,
                  title: AppInternational.current.superCarYearMember,
                  nowPrice: model.yeatSpecialPrice.toString(),
                  orgPrice: model.yeatOriginalPrice.toString(),
                  unit: AppInternational.current.year,
                ),
              ]
            ).sizedBox(width: double.infinity),
            physics: ClampingScrollPhysics(),
          ).expanded(),
          SizedBox(height: 16),
          Container(
            width: 336.pt,
            height: 44.pt,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(colors: AppColors.buttonGradientColors)
            ),
            child: CustomText(AppInternational.current.buy,
              fontSize: 16.pt, fontWeight: w_500,
              color: Colors.white
            ).center,
          ).cupertinoButton(onTap: (){
            show();
            HttpChannel.channel.carBuy(id: model.id, type: _index).then((value){
              value.finalize(wrapper: WrapperModel(),
                failure: (e)=> showToast(e),
                success: (_){
                  dismiss();
                  Navigator.of(context).pop();
                }
              );
            });
          }),
          SizedBox(height: 16)
        ]
      )
    );
  }
}

class _Card extends StatelessWidget {
  _Card(this.image, this.backgroundImage, {
    required this.onTap,
    required this.show,
    this.orgPrice,
    required this.unit,
    required this.nowPrice,
    required this.title
  });
  final String image;
  final String backgroundImage;
  final VoidCallback onTap;
  final bool show;
  final String? orgPrice;
  final String nowPrice;
  final String title;
  final String unit;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Offstage(
          offstage: !show,
          child: Image.asset(backgroundImage),
        ).sizedBox(height: 134),
        Stack(
          children: [
            Image.asset(image),
            Positioned(
                child: CustomText(title,
                  fontSize: 16,
                  fontWeight: w_600,
                  color: Colors.white,
                ), right: 16, top: 12),
            Positioned(child: Column(
              children: [
                RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 15,
                            fontWeight: w_500
                        ),
                        children: [
                          TextSpan(
                            text: AppInternational.current.nowPrice + ": ",
                          ),
                          TextSpan(
                              text: nowPrice,
                              style: TextStyle(
                                  fontWeight: w_600,
                                  fontSize: 20
                              )
                          ),
                          TextSpan(
                            text: "  " + AppInternational.current.diamond + "/" + unit,
                          ),
                        ]
                    )
                ).center,
                Offstage(
                  offstage: orgPrice == null,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 15,
                        fontWeight: w_500,
                        decoration: TextDecoration.lineThrough
                      ),
                      children: [
                        TextSpan(
                          text: AppInternational.current.orgPrice + ": ",
                        ),
                        TextSpan(
                          text: orgPrice,
                          style: TextStyle(
                            fontWeight: w_600,
                            fontSize: 20
                          )
                        ),
                        TextSpan(
                          text: "  " + AppInternational.current.diamond + "/" + unit,
                        ),
                      ]
                    )
                  ).center,
                ).sizedBox(height: 30)
              ]
            ), bottom: 4, left: 16,)
          ],
        ).padding(padding: EdgeInsets.only(left: 16))
      ]
    ).inkWell(onTap: onTap);
  }
}