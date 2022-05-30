
// import 'package:flutter/cupertino.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:marquee/marquee.dart';

import '../../../../app_images/app_images.dart';
import '../../../../common/colors.dart';
import '../../../../generated/anchor_list_model_entity.dart';
import '../models/homepage_model.dart';


class HomePageViews extends StatelessWidget {

  final HomeInfoModel itemModel;
  final GestureTapCallback? onPressed;
  const HomePageViews(this.itemModel,this.onPressed,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   late Widget tempItemView ;
    switch (itemModel.viewType) {
      case 'Anchor': tempItemView = HomeAnchorItem(itemModel.anchorItem);break;
      case 'Nearby': tempItemView = HomeAnchorItem(itemModel.anchorItem);break;
      case 'Game':  tempItemView = HomeGameItem(itemModel.game);break;
      case 'Banner': tempItemView = HomeBannerWidget(itemModel.banner);break;
      case 'Ranking': tempItemView = HomeRankingWidget(itemModel.ranking);break;
      case 'Marquee': tempItemView = HomeMarqueeWidget(itemModel.marquee);break;
    // 默认返回主播cell样式
      default:tempItemView = HomeAnchorItem(itemModel.anchorItem);break;
    }

   return tempItemView.inkWellContent(tempItemView,onTap: this.onPressed);
  }
}



/// 跑马灯
class HomeMarqueeWidget extends StatelessWidget {
  final HomeMarqueeInfo marquee;
  const HomeMarqueeWidget(
      this.marquee, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppMainColors.whiteColor10,
          border:Border.all(color: AppMainColors.whiteColor15),
          borderRadius: BorderRadius.all(Radius.circular(9.0.pt),
          )
      ),
      margin: EdgeInsets.all(4),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.homeHeadlines,
                width: 50.pt, height: 40.pt, fit: BoxFit.fill),
            Marquee(
                text: marquee.content!,
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
          ]
      ),
    );
  }
}


/// 火力排行版
class HomeRankingWidget extends StatelessWidget {
  final HomeRankingInfo ranking;
  const HomeRankingWidget(this.ranking,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppMainColors.whiteColor10,
          border:Border.all(color: AppMainColors.whiteColor15),
          borderRadius: BorderRadius.all(Radius.circular(9.0.pt),
          )
      ),
      child: Row(
        children: [
          Image.asset(
            AppImages.homeRanking,
            width: 90.pt,
            // height: 8.pt,
          ),
          RichText(
              text: TextSpan(
                text: "俄罗斯小仙女 荣登榜首第一名\n",
                style: AppStyles.f14w400c255_255_255,
                children: [
                    TextSpan(
                      text: "323.2w 火力值",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppMainColors.mainColor,
                          height: 1.5,
                        ),
                      ),
                ]
              )
          ),
          Expanded(child: Container()),
          Image.asset(
            AppImages.homeRankingList,
            height: 44,
            // width: 90.pt,
            // height: 8.pt,

          ),
        ],
      ),
    );
  }
}


/// banner图
class HomeBannerWidget extends StatelessWidget {

  final List <HomeBannerInfo> banners;
  const HomeBannerWidget(this.banners,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 120,
      padding: EdgeInsets.all(10),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: NetworkImage(
                    banners[index].pic!,
                  ),
                  fit: BoxFit.fill,
                )),
          );
        },
        autoplay: true,
        itemCount: banners.length,
        scrollDirection: Axis.horizontal,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                color: Colors.white30,
                activeColor: AppMainColors.mainColor,
                size: 8.0,
                activeSize: 8.0)),
        control: null,
        layout: SwiperLayout.DEFAULT,
        onTap: (index) => print('点击了第$index个'),
      ),
    ).inkWell();
  }
}


/// 游戏item
class HomeGameItem extends StatelessWidget {

  final HomeGameInfo game ;
  const HomeGameItem(this.game,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: EdgeInsets.all(4),
        // conainer 单独包裹 fadeinimage 切圆角 没效果 包一层Cliprrect
        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(8.0)),
          child: FadeInImage.assetNetwork(
              placeholder: AppImages.imgPlaceHolder,
              placeholderFit: BoxFit.cover,
              image: game.imageUrl!,
              fit: BoxFit.fill,
              imageErrorBuilder: (context,error,stackTrace){
                return Image.asset(AppImages.imgPlaceHolder,fit: BoxFit.fill,);
              }),
        ) ,
      );
  }
}

/// 主播item
class HomeAnchorItem extends StatelessWidget {
  final AnchorListModelEntity anchorItem;
  const HomeAnchorItem(this.anchorItem,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.pt,),
        child: Stack(
          children: [
            /// 背景图
            Positioned.fill(
                child: FadeInImage.assetNetwork(
                    placeholder: AppImages.imgPlaceHolder,
                    placeholderFit: BoxFit.cover,
                    image: anchorItem.roomCover!,
                  // image: "https://img.syt5.com/2020/1217/20201217080332457.jpg",

                  fit: BoxFit.cover,
                    imageErrorBuilder: (context,error,stackTrace){
                      return Image.asset(AppImages.imgPlaceHolder,fit: BoxFit.cover,);
                    },
                ),
            ),
            /// 诚实名字信息遮罩
            Positioned(
                left: 0,right: 0,bottom: 0,height: 100.pt,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppMainColors.blackColor0,
                        AppMainColors.blackColor70,
                      ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                    )
                  ),
                )
            ),
            /// 房间类型
            Container(
              height: 18.pt,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                  "一分快三",
                style: AppStyles.f10w500c255_255_255,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppMainColors.mainGradientStartColor,AppMainColors.mainGradientEndColor]),
                borderRadius: BorderRadius.all(Radius.circular(20.0.pt)),
              ),
            ).position(top: 8.pt, left: 8.pt,),
            ///是否展示直播
            Container(
              // height: 16.pt,
              width: 48.pt,
              padding: EdgeInsets.all(2),
              // padding: EdgeInsets.symmetric(vertical: 2.0),

              decoration: BoxDecoration(
                color: AppMainColors.blackColor70,
                border:Border.all(color: AppMainColors.whiteColor70),
                borderRadius: BorderRadius.all(Radius.circular(9.0.pt),
                )
              ),
              child: Row(
                children: [
                  Image.asset(
                    AppImages.ic_live,
                    width: 8.pt,
                    height: 8.pt,
                  ),
                  SizedBox(width: 4.pt),
                  Text(
                    "直播中",
                    style: AppStyles.f10w400c255_255_255,
                  )
                ],
              ),
            ).position(top: 8.pt, right: 8.pt),

            /// 名字地址信息副文本
            RichText(
              text: TextSpan(
                text: "",
                style: AppStyles.f12w500c255_255_255,
                children: [
                  //头部标签 + 消费时长 9砖石...
                  WidgetSpan(
                      child: Row(
                        children: [
                          // top 图标
                          Container(
                            height: 16.pt,
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              gradient:
                              LinearGradient(colors: AppMainColors.rankBgGradient),
                              borderRadius: BorderRadius.all(Radius.circular(2.0.pt)),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppImages.ic_home_rank,
                                  height: 12.pt,
                                  width: 12.pt,
                                ),
                                //排名文字
                                Text(
                                  "TOP1",
                                  textAlign: TextAlign.center,
                                  style: AppStyles.f10w500c255_255_255,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 4.pt),
                          //收费字段
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.pt),
                            height: 16.pt,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Color.fromARGB(153, 255, 255, 255)),
                                borderRadius: BorderRadius.all(Radius.circular(2.0.pt)),
                                color: (Colors.black.withAlpha(153))),
                            child: Text("dddd", style: AppStyles.f10w400c70white),
                          ),
                        ],
                      ),
                  ),

                  TextSpan(
                    text: "${anchorItem.roomTitle}\n",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.c255_255_255,
                        height: 2.0,
                    ) ,

                  ),
                  TextSpan(
                    text: "打开了打卡拉斯的\n",
                    // text: "${anchorItem.city} ${anchorItem.province}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppMainColors.whiteColor70,
                      height: 1.5
                    ),
                  ),
                ]
              ),
            ).position(left: 8.pt, right: 8.pt, bottom: 5.pt),

            /// 观看人数
            Container(
              child: Text(
                "14000",
                style: AppStyles.f12w400white70,
              ),
            ).position(right: 8.pt, bottom: 5.pt)

          ],
        ),
      ),
    );
  }
}
