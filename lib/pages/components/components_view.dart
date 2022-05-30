import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../app_images/app_images.dart';
import '../../common/app_common_widget.dart';
import '../../config/app_colors.dart';
import '../live/live_home_data.dart';

class UniversalBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Obx(() {
     var value = Get.find<LiveHomeData>().state.homeBanner;
     if (value.length == 0) {
       return Container();
     }
     return Container(
       height: 120,
       padding: EdgeInsets.all(10),
       child: new Swiper(
         itemBuilder: (BuildContext context, int index) {
           return Container(
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(6),
                 image: DecorationImage(
                   image: NetworkImage(
                     value[index].pic.toString(),
                   ),
                   fit: BoxFit.fill,
                 )),
           );
         },
         autoplay: true,
         itemCount: value.length,
         scrollDirection: Axis.horizontal,
         pagination: new SwiperPagination(
             builder: new DotSwiperPaginationBuilder(
                 color: Colors.white30,
                 activeColor: AppMainColors.mainColor,
                 size: 8.0,
                 activeSize: 8.0)),
         control: null,
         layout: SwiperLayout.DEFAULT,
         onTap: (index) => print('点击了第$index个'),
       ),
     );
   });
  }
}



class UniversalAnnouncement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() {
      var announcementString =
          Get.find<LiveHomeData>().state.announcementString;
      if (announcementString.isEmpty) {
        return Container();
      }
      return Container(
        height: 40,
        margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppMainColors.separaLineColor6,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //设置四周边框
          border: new Border.all(
              width: 1, color: AppMainColors.separaLineColor10),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.homeHeadlines,
                  width: 50.pt, height: 40.pt, fit: BoxFit.fill),
              Marquee(
                  text: announcementString.value
                      .replaceAll("\r", "")
                      .replaceAll("\n", ""),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: w_500,
                      color: Colors.white),
                  scrollAxis: Axis.horizontal,
                  velocity: 50.0,
                  blankSpace: 259.pt,
                  accelerationCurve: Curves.linear,
                  decelerationCurve: Curves.easeOut)
                  .expanded(),
            ]),
      );
    });
  }
}

